
def quickSort(list_in):
    print(len(list_in))
    if len(list_in) == 0:
        return
    elif len(list_in) == 1:
        return list_in[0]
    else: 
        
        pivot = list_in[-1]
        list_left =[]
        list_right = []

        for val in list_in: 
            if val < pivot:
                list_left.append(val)
            else: 
                list_right.append(val)

        quickSort(list_left)
        quickSort(list_right)


print(quickSort([0,2,1]))