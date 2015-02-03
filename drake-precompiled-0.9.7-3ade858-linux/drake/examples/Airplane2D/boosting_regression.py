import numpy as np
import scipy.io as sio
from sklearn import ensemble
from sklearn.metrics import mean_squared_error
from sklearn.ensemble import RandomForestRegressor



x=sio.loadmat('data_set')['x']
y=sio.loadmat('data_set')['y']
x = x.transpose();
y = np.reshape(y.transpose(),np.shape(y)[1],);
params = {'n_estimators': 10000, 'max_depth': 3, 'min_samples_split': 2,
          'learning_rate': 1.01, 'loss': 'ls'}
clf = ensemble.GradientBoostingRegressor(**params)
clf2 = ensemble.AdaBoostRegressor(n_estimators=1000)
clf3 = RandomForestRegressor(n_estimators=50)
clf.fit(x,y);
clf2.fit(x,y);
clf3.fit(x,y);

mse = mean_squared_error(y,clf.predict(x))
mse2 = mean_squared_error(y,clf2.predict(x))
mse3 = mean_squared_error(y,clf3.predict(x))
print mse,mse2,mse3
import pdb; pdb.set_trace()

print 'asdf'
