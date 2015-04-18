# trainPartiallyObservableSupController.py

"""Trains and predicts the robot grasping simulator """
import os.path
import pickle

from sklearn.ensemble import RandomForestRegressor
from sklearn import preprocessing
import scipy.io as sio
import numpy as np
import copy
#import matlab.engine
from MMDController import MMDController

# make observations - done via sample_CoM_from_obs
	# sample observations from Truncated normal distribution http://en.wikipedia.org/wiki/Truncated_normal_distribution
	# len,radius are sampled from: mu = [0.04, 0.2], sigma = [0.01 0.01; 0.01 0.1],abs(mvnrnd(mu,sigma,n_obs))

# load observations
n_obs = 40;
n_samples_per_obs = 2;
com_data = sio.loadmat('./partial_observable_init/com_list_for_partially_observations_list.mat')
com_list = com_data['com_list']

# initial data
controller = MMDController()
init_conds_list = np.zeros((n_obs,43))
rad_list 	= np.zeros((n_obs,1))
len_list	= np.zeros((n_obs,1))
com_list	= np.zeros((n_obs,3))

for i in range(n_obs):
	fname      ='./observable_init/new_traj_' + str(i) + '.mat'
        train_data = sio.loadmat(fname)
        q_sol = train_data['q_sol']
        h_sol = train_data['h_sol']
        rad_list[i,0]   = train_data['radius']
        len_list[i,0]   = train_data['len']
        com_list[i,:]   = train_data['com_list']

	
	h_sol = np.hstack( (np.matrix(([0])),h_sol) )
	qh_sol = np.vstack( (q_sol,h_sol) )
	qh_obs_sol = copy.deepcopy(qh_sol)

	# make a deepcopy, so that even when x is normalized it does not change the value qh_sol
	x_list = copy.deepcopy(qh_sol[:,0:9]) 
	n_x = np.shape(x_list)[1]
	rads = np.empty(n_x)
	lens = np.empty(n_x)
	lens.fill(len_list[i,0])
	rads.fill(rad_list[i,0])

	coms = np.matlib.repmat(np.transpose(np.asmatrix((com_list[i,:]))),1,n_x)
        x_list = np.vstack((x_list,coms))

	y_list = copy.deepcopy(qh_sol[:,1:10])

	if i == 0:
		x = x_list
		y = y_list
	else:
		x = np.hstack((x,x_list))
		y = np.hstack((y,y_list))

	# The value of qh_sol is changed after x_list has been passed in.
	# Interestingly, Python arguments are pass by reference by default.
	# (From StackOverflow:Objects in python (and most mainstream languages) are passed as reference.)

	# Just resetting qh_sol for init condition setup
	init_conds_list[i,:] = np.transpose(qh_sol)[0,:]

x = np.transpose(x)
y = np.transpose(y)
 
scaler = preprocessing.StandardScaler()
scaler.fit(x)
scaled_x = scaler.transform(x,copy=True)

controller = RandomForestRegressor(n_estimators=10)

controller.fit(scaled_x,y)



# predict
def save_object(obj, filename):
    with open(filename, 'wb') as output:
        pickle.dump(obj, output, pickle.HIGHEST_PROTOCOL)

path = './sup_training_output_observable/'
n_traj_opt_calls = 0
n_mmd_iterations = 1
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
		coms[0,:] = com_list[obsIdx,:]

		print xt[0:3]
		there_were_no_empty_cand = True
		for i in range(0,N):
			print 'Completed ' + str(idx) + 'th mmd iteration ' + str((float(i)/N)*100.0) + ' % of the ' + str(obsIdx)+ 'th observation'
			xtraj[0:,i] = copy.deepcopy(xt)
			print 'xtraj = ' +str(xtraj[0:3,i])
			xt=np.hstack( (xt,com_list[obsIdx,:]) )

			xt =np.transpose( copy.deepcopy(controller.predict(scaler.transform(xt) )) )
			print 'pred = ' + str(np.transpose(xt[0:3]))
			if i < 9:
				print 'true = ' + str( np.transpose(y_list[:,i])[0,0:3]) 
			print '\n'

			xt = np.reshape(np.transpose(xt),prediction_dim,)

		print 'one iteration done'
		save_object( controller, path+'controller_idx='+str(idx)+'_'+'obsidx='+str(obsIdx) )
		sio.savemat(path+'MMD_predicted_traj'+'_'+str(obsIdx)+'_'+str(idx)+'.mat', {'xtraj':xtraj,'init_conds_list':init_conds_list,'rad':radius,'len':length} )
