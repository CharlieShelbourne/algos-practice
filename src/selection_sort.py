""" Repeatedly finds minimum element and put at begining. Maintains two subarrays in a given array """

def selection_sort(list_in: list): 
    
    if len(list_in) <= 1:
        return list_in

    sorted_list = []

    while len(list_in)>1:
        sorted_list.append(min(list_in))
        list_in.remove(min(list_in))
    
    sorted_list.append(list_in[0])

    return sorted_list

print(selection_sort([3,2,4,1,0]))


def selection_sort2(list_in: list): 
    
    if len(list_in) <= 1:
        return list_in

    for i in range(len(list_in)): 
        smallest = list_in[i]
    
        for j in range(i+1,len(list_in)):
            if list_in[j] < smallest:
                smallest = list_in[j]
                ind = j

        list_in[ind] = list_in[i]
        list_in[i] = smallest

    return list_in

print(selection_sort2([3,2,4,1,0]))