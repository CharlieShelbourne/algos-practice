class Node: 
    def __init__(self, data):
        self.data = data
        self.neighbours = []
        self.marked = False
        self.visited = False 
    

def find_path(start_root: Node, end_name: str):
    if len(start_root.neighbours) == 0:
        return
    queue = []

    queue.append(start_root)
    start_root.marked = True

    # while loop to loop through queue and visit nodes 
    while len(queue) != 0: 
        n = queue[0]

        for neighbour in n.neighbours:
            if neighbour.marked is False:
                if neighbour.data == end_name:
                    return True
                else:
                    queue.append(neighbour)
                    neighbour.marked = True
        
        # pop node off queue 
        queue = queue[1:]
    return False


node1 = Node("C")
node2 = Node("h")
node3 = Node("a")
node4 = Node("r")
node5 = Node("l")
node6 = Node("i")
node7 = Node("e")

node1.neighbours.append(node2)
node2.neighbours.append(node3)
node3.neighbours.append(node4)
node4.neighbours.append(node5)
node5.neighbours.append(node6)
#node6.neighbours.append(node7)

print(find_path(node1, "e"))


        



    
