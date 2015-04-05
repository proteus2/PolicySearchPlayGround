# trainMMDController.py
"""Trains and predicts the robot grasping simulator """
import os.path
import pickle

from sklearn.ensemble import RandomForestRegressor
import scipy.io as sio
import numpy as np
import matlab.engine
from MMDController import MMDController

# make observations - done via sample_CoM_from_obs
	# sample observations from Truncated normal distribution http://en.wikipedia.org/wiki/Truncated_normal_distribution
	# len,radius are sampled from: mu = [0.04, 0.2], sigma = [0.01 0.01; 0.01 0.1],abs(mvnrnd(mu,sigma,n_obs))

# load observations
n_obs = 10;
n_samples_per_obs = 2;
com_data = sio.loadmat('./partial_observable_init_training_data/com_list_for_observations_list.mat')
com_list = com_data['com_list']

# initial data
controller = MMDController()
init_conds_list = np.zeros((n_obs,43))
rad_list 	= np.zeros((n_obs,1))
len_list	= np.zeros((n_obs,1))

for i in range(n_obs):
	fname 	   ='./partial_observable_init_training_data/xy_format_new_traj_' + str(i+1) + '.mat'
	train_data = sio.loadmat(fname)
	x_list     = train_data['x']
	y_list 	   = train_data['y']
	rad_list[i,0]   = train_data['radius']
	len_list[i,0]   = train_data['len']
	controller.setNewController(x_list,y_list)
	init_conds_list[i,:] = x_list[0,:]


# predict
eng = matlab.engine.start_matlab()
eng.cd('/home/beomjoon/Documents/Github/PolicySearchPlayGround/drake-distro/')
eng.addpath_pods()
eng.cd('/home/beomjoon/Documents/Github/PolicySearchPlayGround/drake-distro/drake')
eng.addpath_drake()
eng.cd('/home/beomjoon/Documents/Github/PolicySearchPlayGround/drake-distro/drake/solvers/trajectoryOptimization/dev')

def save_object(obj, filename):
    with open(filename, 'wb') as output:
        pickle.dump(obj, output, pickle.HIGHEST_PROTOCOL)


path = './MMD_training_output_partially_observable/'
n_traj_opt_calls = 0
n_mmd_iterations = 10
N=10
prediction_dim = 43;
coms = np.zeros((2,3))
for idx in range(n_mmd_iterations):
	for obsIdx in range(n_obs):
		xt = init_conds_list[obsIdx,:]
		xt[-1] = 0
		xtraj = np.zeros( (prediction_dim,N) )
		radius = rad_list[obsIdx,0]
		length = len_list[obsIdx,0]
		coms[0,:] = com_list[obsIdx,:,0]
		coms[1,:] = com_list[obsIdx,:,1]

		there_were_no_empty_cand = True
		for i in range(0,N):
			xtraj[0:,i] = xt
			
			# check discrepancy
			min_idx,d_list,scaled_x,empty_candidate = controller.checkDiscrepancy(xt)
			if empty_candidate:		
				there_were_no_empty_cand = False
				fname = path+'new_traj_'+str(n_traj_opt_calls)+'.mat'
				if not os.path.isfile(fname):
					eng.getPartiallyObservableTrajectory(xt.tolist(),path,radius,length,coms.tolist())
				
				new_data = sio.loadmat(fname)
				x = new_data['x']
				y = new_data['y']
				x = x[:,0:prediction_dim]
				y = y[:,0:prediction_dim]
				controller.setNewController(x,y)
				n_traj_opt_calls = n_traj_opt_calls + 1;

				# make prediction
				xt = controller.predict(xt)
			else:
				xt = controller.predict(xt)

			xt = np.reshape(np.transpose(xt),prediction_dim,)
		
		print 'one iteration done'
		save_object( controller, path+'controller_idx='+str(idx)+'_'+'obsidx='+str(obsIdx) )
		sio.savemat(path+'MMD_predicted_traj'+'_'+str(obsIdx)+'_'+str(idx)+'.mat', {'xtraj':xtraj},{'init_conds_list':init_conds_list} )
		
	if there_were_no_empty_cand:
		break