# trainMMDController.py
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
#for i in range(n_init_data):
i = 1;
x = x_list[0,i]
y = y_list[0,i]
controller.setNewController(x,y)


# predict
init_conds_list = train_data['init_conds_list']
N = train_data['N']
state_dim = np.shape(init_conds_list)[0]
prediction_dim = 43;

def save_object(obj, filename):
    with open(filename, 'wb') as output:
        pickle.dump(obj, output, pickle.HIGHEST_PROTOCOL)

save_object( controller, 'sup_controller' )
				
