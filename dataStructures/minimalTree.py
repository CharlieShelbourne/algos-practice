sorted_array = [0,1,2,3,4,5,6]

""" Tree ruels left branch < n <= right branch """

# minimal = medium must be root node or middle node

# when 2 nodes, minium is left and max is right

class Node: 
    def __init__(self, data):
        self.data = data 
        self.left = None
        self.right = None 


def minimal_tree(sorted_array):
    if len(sorted_array) <= 1:
        return sorted_array

    # split array in middle
    parent_node = int((sorted_array[0]+sorted_array[len(sorted_array)-1])/2)

    current_mid = int(len(sorted_array)/2)

    sorted_array[int((0+(current_mid-1))/2)] = parent_node

    sorted_array[int((current_mid + 1 + len(sorted_array))/2)] = parent_node

    sorted_array[:current_mid] = minimal_tree(sorted_array[:current_mid])
    sorted_array[current_mid+1:] = minimal_tree(sorted_array[current_mid+1:])

    return sorted_array

print(minimal_tree(sorted_array))


