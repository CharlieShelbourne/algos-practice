""" Repeatedly finds minimum element and put at begining. Maintains two subarrays in a given array """

def selection_sort(arr):

    for i in range(len(arr)): # O(n)
        for j in range(i+1, len(arr)): # O(n)
            arr[i], arr[j] = min(arr[i], arr[j]), max(arr[i], arr[j]) # O(1)

    return arr

print(selection_sort([5,2,6,8,1,4]))
        

# [5,2,6,8,1,4]
# i = 0 -> [1,5,6,8,2,4]
# i = 1 -> [1,2,5,6,8,4]
# i = 2 -> [1,2,4,6,8,5]
# bottle neck is most elements do not change each iteration 