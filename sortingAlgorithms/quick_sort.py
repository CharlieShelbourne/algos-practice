# choose a pivot point (middle) use to sort elements (two pointer method) 
# swapping elements left of pivot that are > pivot with elements right of pivot if less than pivot 
# find the partition point and reprat untill sorted 

# average case O(nlogn)
# worse case O(n^2)

def quick_sort(arr):
    qs(arr, 0, len(arr)-1)

def qs(array, left, right): 
    if left >= right:
        return
    # pick pivot point to be middle give better performance 
    pivot = array[(left + right) // 2]
    part = parition(array, left, right, pivot)
    qs(array, left, part-1)
    qs(array, part, right) 

def parition(array, left, right, pivot):
    while left <= right:
        while array[left] < pivot:
            left += 1
        print(array, right)
        while array[right] > pivot:
            right -= 1
        
        if left <= right:
            array[left], array[right] = array[right], array[left]
            left += 1
            right -= 1

    return left

# [2,6,3,7,8]
# index 0 : [2,3,6,7,8], part = 2
# 
# [2,3], [6,7,8]
# index 1 : [2,3], part = 1
# index 2 : [6,7,8], part = 4
# 
# []

print(quick_sort([2,6,3,7,8]))     