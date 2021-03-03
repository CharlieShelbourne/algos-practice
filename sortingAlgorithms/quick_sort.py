
def quick_sort(sort_list, low_ind, high_ind):

    
    #recursion call for quick sort, split array using pivot 

    #if i have length array <= 1 i must return 


    if low_ind < high_ind: #if not true the array is length 1 or less 
        
        pi = partition(sort_list, low_ind, high_ind)

        quick_sort(sort_list, low_ind, high_ind = pi - 1)
        quick_sort(sort_list, low_ind = pi + 1, high_ind = high_ind)


def partition(sort_list, low_ind, high_ind):

    #take low as lowest index - 1 
    
    #take the last number(pivot) and move it to its sorted position 
    #all elements below pivot must be less than and all element ubove pivot must be greater than 
    pivot = sort_list[high_ind]
    i = low_ind - 1 

    for j in range(low_ind, high_ind):
        if sort_list[j] < pivot:
            i += 1
            sort_list[i], sort_list[j] = sort_list[j], sort_list[i]
        else: 
            continue
    sort_list[i+1], sort_list[high_ind] = pivot, sort_list[i+1]
    return i+1


test_list = [0, 4, 2, 1]

quick_sort(test_list, low_ind = 0, high_ind = 3)

print(test_list)
    

