
class Node: 
    def __init__(self,name):
        self.name = name
        self.left = None
        self.right = None
        self.visit = False

    def insert(self, name):
        if name < self.name: 
            if self.left is None: 
                self.left = Node(name)
            else:
                self.left.insert(name)
        elif name > self.name:
            if self.right is None:
                self.right = Node(name)
            else: 
                self.right.insert(name)


def visit(node):
    node.visit = True

def in_order_traversal(node):
    if node != None: 
        in_order_traversal(node.left)
        visit(node)
        in_order_traversal(node.right)

def pre_order_traversal(node): 
    if node != None: 
        visit(node)
        pre_order_traversal(node.left)
        pre_order_traversal(node.right)

def post_order_traversal(node):
    if node != None:
        pre_order_traversal(node.left)
        pre_order_traversal(node.right)
        visit(node)