# the heap has a binary tree strucutre and is an almost complete tree 
# max heap: a parent node has a value that is larger or equalt to its children
# min heap: a parent node has a value that is smaller or equal to its children 

# storing a heap within an array 
# child nodes
# left child of a[k] -> a[2*k]
# right child of a[k] -> a[2*k+1]

# parent nodes
# parent of a[k] -> a[k//2]


# build heap
def max_heap(arr):
    heap = [None] + arr
    
    for i in range(len(heap)-1, 1, -1):
        if heap[i] is not None and heap[i] > heap[i//2]:
            heap[i], heap[i//2] = heap[i//2], heap[i]
        
    return heap

def min_heap(arr):
    heap = [None] + arr
    
    for i in range(len(heap)-1, 1, -1):
        if heap[i] is not None and heap[i] < heap[i//2]:
            heap[i], heap[i//2] = heap[i//2], heap[i]
        
    return heap

print(max_heap([0,1,2,3,4,5]))
print(min_heap([5,4,3,2,1,0]))

