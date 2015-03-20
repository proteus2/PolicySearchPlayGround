# trainDAggController.py
"""Trains and predicts the robot grasping simulator """
import os.path
import pickle

from sklearn.ensemble import RandomForestRegressor
import scipy.io as sio
import numpy as np
import matlab.engine
from MMDController import MMDController

#eng = matlab.engine.start_matlab()
#eng.cd('/home/beomjoon/Documents/Github/drake-distro/drake/solvers/trajectoryOptimization/dev')

# load initial data
train_data = sio.loadmat('init_train_data')

x_list = train_data['train_x']
y_list = train_data['train_y']

# train initial supervised learner
controller = MMDController()
n_init_data = np.shape(x_list)[1]
aggregated_x = x_list[0,0];
aggregated_y = y_list[0,0]
for i in range(1,n_init_data):
	i = 1;
	x = x_list[0,i]
	y = y_list[0,i]
	aggregated_x = np.vstack((aggregated_x,x));
	aggregated_y = np.vstack((aggregated_y,y));


# predict
init_conds_list = train_data['init_conds_list']
N = train_data['N']
state_dim = np.shape(init_conds_list)[0]
prediction_dim = 43;


eng = matlab.engine.start_matlab()
eng.cd('/home/beomjoon/Documents/Github/PolicySearchPlayGround/drake-distro/')
eng.addpath_pods()
eng.cd('/home/beomjoon/Documents/Github/PolicySearchPlayGround/drake-distro/drake')
eng.addpath_drake()
eng.cd('/home/beomjoon/Documents/Github/PolicySearchPlayGround/drake-distro/drake/solvers/trajectoryOptimization/dev')
def save_object(obj, filename):
    with open(filename, 'wb') as output:
        pickle.dump(obj, output, pickle.HIGHEST_PROTOCOL)

controller = RandomForestRegressor()
controller.fit(aggregated_x,aggregated_y)
n_traj_opt_calls = 0;
for idx in range(10):
	for initIdx in range(n_init_data):
		xt = init_conds_list[0:prediction_dim,initIdx]
		xt[-1] = 0
		xtraj = np.zeros( (prediction_dim,N) )

		there_were_no_empty_cand = True
		for i in range(0,N):
			xtraj[0:,i] = xt
			
			# check discrepancy
			fname = './DAgger_training_output/new_traj_'+str(n_traj_opt_calls)+'.mat'
			if not os.path.isfile(fname):
				eng.getTrajectory(xt.tolist(),'./DAgger_training_output/')
			
			new_data = sio.loadmat(fname)
			x = new_data['x']
			y = new_data['y']
			x = x[:,0:prediction_dim]
			y = y[:,0:prediction_dim]

			aggregated_x = np.vstack((aggregated_x,x));
			aggregated_y = np.vstack((aggregated_y,y));

			n_traj_opt_calls = n_traj_opt_calls + 1;

			# make prediction
			xt = controller.predict(xt)

			xt = np.reshape(np.transpose(xt),prediction_dim,)
		
		print 'one iteration done'
		save_object( controller, './DAgger_training_output/DAgg_controller_idx='+str(idx)+'_'+'init_idx='+str(initIdx) )
		sio.savemat( './DAgger_training_output/DAgg_predicted_traj'+'_'+str(initIdx)+'_'+str(idx)+'.mat', {'xtraj':xtraj},{'init_conds_list':init_conds_list} )
		controller.fit(aggregated_x,aggregated_y)
	# aggregate data
	
	# train new controller here

		
