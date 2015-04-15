# MMDController.py
"""This script implements the mmd controller"""

# Things that need to be implemented:
# 1. Data Normalization
# 2. MMD criterion computation
# 3. Controller Selection Mechanism - max_d
# 4. Set new controller function

from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics.pairwise import rbf_kernel
from sklearn.metrics.pairwise import euclidean_distances
from sklearn.metrics.pairwise import pairwise_distances
from sklearn.metrics.pairwise import pairwise_kernels
from sklearn import preprocessing
import numpy as np

class MMDController:
	def __init__(self):
		self.controller_list = [];
		self.max_mmd = [];
		self.unnormalized_data_list = [];
		self.unnormalized_data_list.append([]);
		self.unnormalized_data_list.append([]);
		self.normalized_data_list = [];
		self.scaler_list = [];
		self.Q = [];

	def computeStateDifference(self,x,y,**kwargs):
		
		'''
		# extract part of x that makes sense with euclidean distance
		new_x = x[0:3]
		new_y = y[0:3]
		state_dim = np.shape(x)[0]
		for idx in range(6,12,6): # exclud RPY for palm and obj
			new_x = np.hstack( (new_x,x[idx:idx+3]) )
			new_y = np.hstack( (new_y,y[idx:idx+3]) )
		new_x = np.hstack( (new_x,x[12:]) ) 
		new_y = np.hstack( (new_y,y[12:]) ) 	
		'''

		# computes the abs difference between given two state vectors
		diff_matrix = np.abs(x-y)
		cylinder_rpy_stddev = kwargs.get('cylinder_rpy_stddev',1)
		robot_rpy_stddev = kwargs.get('robot_rpy_stddev',1)

		

		cylinder_rpy_diff = diff_matrix[3:6]*cylinder_rpy_stddev
		robot_rpy_diff = diff_matrix[9:12]*robot_rpy_stddev

		cylinder_rpy_diff[cylinder_rpy_diff>np.pi] = 2*np.pi-cylinder_rpy_diff[cylinder_rpy_diff>np.pi]
		robot_rpy_diff[robot_rpy_diff>np.pi] = 2*np.pi-robot_rpy_diff[robot_rpy_diff>np.pi]

		if (np.any(cylinder_rpy_diff>np.pi) or np.any(cylinder_rpy_diff < 0)):
			print 'angle shit happened'
			if np.any(np.abs(cylinder_rpy_diff[cylinder_rpy_diff>np.pi]) > 1e-5) or np.any(np.abs(cylinder_rpy_diff[cylinder_rpy_diff<0]) > 1e-5):
				print 'angle shit really happened in cylinder'
				import pdb; pdb.set_trace()
		if np.any(robot_rpy_diff>np.pi) or np.any(robot_rpy_diff < 0):
			print 'angle shit happened'
			if np.any(np.abs(robot_rpy_diff[robot_rpy_diff>np.pi]) > 1e-5) or np.any(np.abs(robot_rpy_diff[robot_rpy_diff<0]) > 1e-5):
				print 'angle shit really happened in robot'
				import pdb; pdb.set_trace()

		# compute the proper difference of roll pitch yaw of palm and cylinder 
		'''
		if diff_matrix[0,5] > np.pi:
			diff_matrix[0,5] = abs(2*np.pi-diff_matrix[0,5])

		if diff_matrix[0,11] > np.pi:
			diff_matrix[0,11] = abs(2*np.pi-diff_matrix[0,11])
		'''
		diff_matrix[-1] = diff_matrix[-1]*np.sqrt(10)
		diff_matrix[-2] = diff_matrix[-2]*np.sqrt(10)
		
		return diff_matrix

	def custom_kernel(self,x,y,**kwargs):
		gamma = kwargs.get('gamma',1)
		cylinder_rpy_stddev_ = kwargs.get('cylinder_rpy_std',1)
		robot_rpy_stddev_ = kwargs.get('robot_rpy_std',1)

		difference = self.computeStateDifference(x,y,cylinder_rpy_stddev=cylinder_rpy_stddev_,robot_rpy_stddev=robot_rpy_stddev_)
		sqred_l2_dist =np.sum( np.power(difference,2) )
		return np.exp(-sqred_l2_dist/(2*gamma))

	def setNewController(self,x,y):
		x = np.transpose(x)
		y = np.transpose(y)

		self.Q = np.eye( 45 )
		x=self.setAnglesToBetweenZeroToThreeSixty(x)
		y=self.setAnglesToBetweenZeroToThreeSixty(y)

		self.unnormalized_data_list[0].append(x)
		self.unnormalized_data_list[1].append(y)

		# first normalize the data, and save the scaler
		scaler = preprocessing.StandardScaler()
		scaler.fit(x)
		self.scaler_list.append(scaler)
		scaled_x = scaler.transform(x,copy=True)
		self.normalized_data_list.append(scaled_x)

		# compute the max_mmd
		n_data = np.shape(x)[0]
		max_mmd = -float('inf')
		for i in range(n_data):
			xi = np.reshape( scaled_x[i,:],(1,np.shape(x)[1]) )
			mmd_i = self.computeMMD(xi,scaled_x,scaler.std_[3:6],scaler.std_[9:12])
			if mmd_i > max_mmd:
				max_mmd = mmd_i
		self.max_mmd.append(max_mmd)	

		# train the new controller, then append it to self.controllers
		controller = RandomForestRegressor()
		controller.fit(scaled_x,y)
		self.controller_list.append( controller )
		
	def setAnglesToBetweenZeroToThreeSixty(self,x):
		cylinder_rpy = x[:,3:6]
		robot_rpy = x[:,9:12]
		
		n = np.shape(cylinder_rpy)[0]
		n_rpy = 3
		for t_idx in range(n):
			for rpy_idx in range(n_rpy):
				while cylinder_rpy[t_idx,rpy_idx] < 0:
					cylinder_rpy[t_idx,rpy_idx] = cylinder_rpy[t_idx,rpy_idx]+2*np.pi
				while cylinder_rpy[t_idx,rpy_idx] > 2*np.pi:
					cylinder_rpy[t_idx,rpy_idx] = cylinder_rpy[t_idx,rpy_idx]-2*np.pi

				while robot_rpy[t_idx,rpy_idx] < 0:
					robot_rpy[t_idx,rpy_idx] = robot_rpy[t_idx,rpy_idx]+2*np.pi
				while robot_rpy[t_idx,rpy_idx] > 2*np.pi:
					robot_rpy[t_idx,rpy_idx] = robot_rpy[t_idx,rpy_idx]-2*np.pi
		if np.any(robot_rpy>2*np.pi) or np.any(robot_rpy< 0):
			print 'angle shit happened'
			import pdb; pdb.set_trace()
		# NOTE: '=' operator on Python arrays make shallow copies
		return x

	def computeMMD(self,D1,D2,cylinder_rpy_std_,robot_rpy_std_):
		gamma_=100
		#a=self.custom_kernel(D1,D1,gamma=0.5)
		a=pairwise_kernels(D1,D1,metric=self.custom_kernel,gamma=gamma_,cylinder_rpy_std=cylinder_rpy_std_,robot_rpy_std=robot_rpy_std_)
		b=pairwise_kernels(D1,D2,metric=self.custom_kernel,gamma=gamma_,cylinder_rpy_std=cylinder_rpy_std_,robot_rpy_std=robot_rpy_std_)
		c=pairwise_kernels(D2,D2,metric=self.custom_kernel,gamma=gamma_,cylinder_rpy_std=cylinder_rpy_std_,robot_rpy_std=robot_rpy_std_)

		
		n_d1 = np.shape(D1)[0]
		n_d2 = np.shape(D2)[0]
		
		mmd = (1.0/(n_d1*n_d1))*np.sum(a) - 2.0/(n_d1*n_d2)*np.sum(b) + (1.0/(n_d2*n_d2))*np.sum(c)
		return mmd
		
	
	def checkDiscrepancy(self,x_query):
		# this function determines which of the classfiers to use
		n_ctrlls = np.shape(self.controller_list)[0]
		x_query = np.reshape(x_query,(1,np.shape(x_query)[0]))		

		min_mmd = float('inf')
		candidates = []
		mmd_list = []
		for i in range(n_ctrlls):
			scaler = self.scaler_list[i]
			x_scaled = scaler.transform(x_query)
			D = self.normalized_data_list[i]
			mmd = self.computeMMD(x_scaled,D,self.scaler_list[i].std_[3:6],self.scaler_list[i].std_[9:12])
			mmd_list.append(mmd)
			if mmd <= self.max_mmd[i]:
				candidates.append(i)

		if np.shape(candidates)[0] > 0:
			# choose the controller with a minimum distance data point
			# loop thru candidates
			min_d = float('inf')
			for cand_idx in candidates:
				D = self.normalized_data_list[cand_idx]
				scaler = self.scaler_list[cand_idx]
				x_scaled = scaler.transform(x_query)
				dists = euclidean_distances(x_scaled,D)
				d = np.min(dists)
				if d < min_d:
					selected_idx = cand_idx
					x_scaled_selected = x_scaled
					min_d = d
			return ( selected_idx,mmd_list,x_scaled_selected, False )
		else:
			return (-1,mmd_list,-1,True)
			
			
	def predict(self,x_query):
		# this function predicts the output of x_query
		min_idx,d_list,scaled_x,empty_candidate = self.checkDiscrepancy(x_query)
		if empty_candidate:
			# choose the controller with the closest mmd
			min_idx = np.argmin(d_list)
			scaler = self.scaler_list[min_idx]
			scaled_x = scaler.transform(x_query)
		print min_idx
		prediction = self.controller_list[min_idx].predict(scaled_x)
		return prediction
		
		

	
