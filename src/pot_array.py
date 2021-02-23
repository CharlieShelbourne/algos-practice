import numpy as np

class PotArray: 
    
    def __init__(self,variables,matrix):
        self.variables = variables
        self.matrix = matrix 

    def get_variables(self): 
        return self.variables

    def get_probability(self):
        return self.matrix 


