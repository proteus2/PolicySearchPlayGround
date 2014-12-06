from sklearn.ensemble import RandomForestRegressor
import scipy.io as iomat
import numpy as np

data = iomat.loadmat('trajectory_list')
x = np.transpose( data['x_traj_list'] )
y = np.transpose( data['u_traj_list'] )
RF = RandomForestRegressor(50)
RF.fit(x,y)

import pdb; pdb.set_trace()
