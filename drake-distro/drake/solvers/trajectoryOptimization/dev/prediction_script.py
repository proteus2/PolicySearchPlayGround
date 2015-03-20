# prediction_script.py
"""Python module that outputs the prediction value  """
from sklearn.ensemble import RandomForestRegressor



def trainRF(x,y):
	RF = RandomForestRegressor();
	return x
	RF.fit(x,y)
	return RF

if __name__ == '__main__':
	a=trainRF(3,3)
	print a
