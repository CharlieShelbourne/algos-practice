

""" Conditions of a binary tree:
    1. No duplicate values 
    2. All left decendent nodes must be < value of the parent
    3. All right decendent nodes must be > value of parent 
"""

class Node:
    def __init__(self, data: int):
        self.data = data
        self.left = None
        self.right = None

    def add_node(self, data):
        if data < self.data:
            if self.left is not None:
                self.left.add_node(data)
            else:
                self.left = Node(data)
        elif data > self.data:
            if self.right is not None:
                self.right.add_node(data)
            else:
                self.right = Node(data)

    def get_node(self, data: int) -> int:
        if self.data == data:
            return None
        if data < self.data:
            if self.left is not None:
                if data == self.left.data:
                    return data
                else: 
                    self.left.get_node(data)

        if data > self.data:
            if self.right is not None:
                if data == self.right.data:
                    return data
                else:
                    self.right.get_node(data)

N1 = Node(5)
N1.add_node(2)
N1.add_node(4)

ans = N1.get_node(4)
print(type(ans))





