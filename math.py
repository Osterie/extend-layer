from numpy import *
from numpy.linalg import *
import numpy as np


B = np.array([ [-1/2, 1/2] , [1/2, -1/2]])
p = np.array([[1,1],[1,-1]])
# x = solve(A,b) 
# I = eye(3)
# B = array([ [1,2,3] , [4 ,5, 6] ])
C = np.linalg.inv(p)@B@p
print(C)