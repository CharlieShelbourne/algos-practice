import numpy as np

class hash_map:
    def __init__(self): 
        self.object_list = [None, None, None, None]
    
    @staticmethod
    def hash_code(key: str): 
        return len(key)

    @staticmethod
    def mapping(hash_code: int):
        return hash_code%4

    def post(self, key: str, input: str):
        hash = self.hash_code(key)
        ind = self.mapping(hash)
        if self.object_list[ind] is None:
            self.object_list[ind] = [(key,input)]
        else:
            self.object_list[ind].append(input)

    def get(self, key: str):
        hash = self.hash_code(key)
        ind = self.mapping(hash)
        if self.object_list[ind] is None: 
            return None
        else: 
            for object in self.object_list[ind]: 
                if object[0] == key:
                    return object[1]


map = hash_map()
map.post("charlie", "07879558056")
print(map.get("charlie"))
