""" Min-Heap:
1. complete binary tree, filled up to right most node on last level
2. root is minimum element of tree 
3. 2 key operations: inster and extract_min
    a. insert: start by inserting element at bottom (next avaliable left to right) 
    b. fix: swap element with parent until we find appropriate spot 
    c: extract_min: extract top element and swap with last element in tree (bottommost rightmost element)
"""

class Node: 
    def __init__(self, data): 
        self.data = data
        self.left = None
        self.right = None
        self.size_left = 0
        self.size_right = 0 

    def insert(self, data):
        if self.left is None:
            self.left = Node(data)
            self.size_left += 1
            self.fix_left()
        elif self.right is None:
            self.right = Node(data)
            self.size_right += 1
            self.fix_right()
        elif (self.size_left - self.size_right) > 0:
            self.right.insert(data)
            self.size_right += 1
            self.fix_right()
        else:
            self.left.insert(data)
            self.size_left += 1
            self.fix_left()
           
    def fix_left(self): 
        if self.data > self.left.data:
            self.data, self.left.data = self.left.data, self.data
    
    def fix_right(self): 
        if self.data > self.right.data:
            self.data, self.right.data = self.right.data, self.data
        
        


Heap = Node(7)
Heap.insert(6)
Heap.insert(5)
Heap.insert(4)
Heap.insert(3)
Heap.insert(2)
Heap.insert(1)
print(1)
 

