from heapq import heappush, heappop

# find an efficent sorting algorithm that sorts a list where the correct poisiton of each element is within a fix distance k 

a = [3,1,4,2,6,7,5]
k = 3

# select sort - o(n^2)
# merger sort - o(nlogn)
# quick sort - avg O(nlogn), worst case O(n^2)
# heap sort - O(nlogn)

def select_sort(arr, k):
    for i in range(len(arr)): # O(n)
        j = i + 1
        while j <= i+k: # O(k)
            if j < len(arr) and arr[j] < arr[i]:
                min_j = j
            j += 1
        
        arr[i], arr[min_j] = arr[min_j], arr[i]
            
            
# [3,1,4,2,6,7,5]
# index 0 : [3,1,4,2,6,7,5]
# index 1 : [1,2,4,3,6,7,5]
# index 2 : [1,2,3,4,6,7,5]

def heap_sort(arr, k):
    heap = []
    for i in range(k): # O(k)
        # add to min heap
        heappush(heap, arr[i]) # O(logk)

    result = []
    for i in range(k+1, len(arr)): # O(n)
        # append to of heap to arr
        result.append(heappop(heap)) # O(logk)
        # add arr[i] to heap
        heappush(heap, arr[i]) # O(logk)
    
    while heap: # O(k)
        result.append(heappop(heap)) # O(logk)

    return result


# O(2klogk + nlogk) -> O(nlogk)

print(heap_sort([3,1,4,2,6,7,5], 3))