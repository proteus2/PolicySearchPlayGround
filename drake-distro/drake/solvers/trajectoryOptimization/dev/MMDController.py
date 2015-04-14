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
		# extract part of x that makes sense with euclidean distance
		new_x = x[0:3]
		new_y = y[0:3]
		state_dim = np.shape(x)[0]
		for idx in range(6,state_dim,6):
			new_x = np.hstack( (new_x,x[idx:idx+3]) )
			new_y = np.hstack( (new_y,y[idx:idx+3]) )


		# computes the abs difference between given two state vectors
		diff_matrix = np.abs(new_x-new_y)
		
		# compute the proper difference of roll pitch yaw of palm and cylinder 
		'''
		if diff_matrix[0,5] > np.pi:
			diff_matrix[0,5] = abs(2*np.pi-diff_matrix[0,5])

		if diff_matrix[0,11] > np.pi:
			diff_matrix[0,11] = abs(2*np.pi-diff_matrix[0,11])
		'''
		return diff_matrix

	def custom_kernel(self,x,y,**kwargs):
		gamma = kwargs.get('gamma',1)
		difference = self.computeStateDifference(x,y)
		sqred_l2_dist =np.sum( np.power(difference,2) )
		return np.exp(-sqred_l2_dist/(2*gamma))

	def setNewController(self,x,y):
		x = np.transpose(x)
		y = np.transpose(y)
		self.Q = np.eye( np.shape(x[0,:])[1] )

		#x=self.setAnglesToBetweenZeroToThreeSixty(x)
		#y=self.setAnglesToBetweenZeroToThreeSixty(y)
		self.unnormalized_data_list[0].append(x)
		self.unnormalized_data_list[1].append(y)
		
		# first normalize the data, and save the scaler
		scaler = preprocessing.StandardScaler().fit(x)
		self.scaler_list.append(scaler)
		scaled_x = scaler.transform(x)
		self.normalized_data_list.append(scaled_x)
		 
		# compute the max_mmd
		n_data = np.shape(x)[0]
		max_mmd = -float('inf')
		for i in range(n_data):
			xi = np.reshape( scaled_x[i,:],(1,np.shape(x)[1]) )
			mmd_i = self.computeMMD(xi,scaled_x)
			if mmd_i > max_mmd:
				max_mmd = mmd_i
		self.max_mmd.append(max_mmd)	

		# train the new controller, then append it to self.controllers
		controller = RandomForestRegressor()
		controller.fit(x,y)
		self.controller_list.append( controller )
		
	def setAnglesToBetweenZeroToThreeSixty(self,x):
		pass	

	def computeMMD(self,D1,D2):
		gamma=0.5
		#a=self.custom_kernel(D1,D1,gamma=0.5)
		a=pairwise_kernels(D1,D1,metric=self.custom_kernel,gamma=0.5)
		b=pairwise_kernels(D1,D2,metric=self.custom_kernel,gamma=0.5)
		c=pairwise_kernels(D2,D2,metric=self.custom_kernel,gamma=0.5)
		
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
			mmd = self.computeMMD(x_scaled,D)
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
		prediction = self.controller_list[min_idx].predict(x_query)
		return prediction
		
		

	
