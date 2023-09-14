



def quadraticSolverB(a, b, c, res):
    temporary_old_x = 0
    old_x = 0
    new_x = 9999
    while ( abs(new_x - temporary_old_x) > res):
        
        new_x = -( ( (a*old_x**2) + c)/b ) 
        temporary_old_x = old_x
        old_x = new_x
        
    return new_x

print(quadraticSolverB(2, -5, 2, 0.00001))
