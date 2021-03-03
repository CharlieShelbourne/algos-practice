""" Sorts adjacent elements if they are in the wrong order """


# [3,4,2,1,0]


def bubble_sort(list_in: list): 
    if len(list_in) <= 1:
        return list_in

    for i in range(len(list_in)):
        swap = False
        for j in range(0,len(list_in)-1):
            if list_in[j] > list_in[j+1]:
                temp = list_in[j]
                list_in[j] = list_in[j+1]
                list_in[j+1] = temp
                swap = True

        if swap == False: 
            return list_in
                
    return list_in

print(bubble_sort([3,4,2,1,0]))

# [3,4,2,1,0] 0
# [3,2,4,1,0] 1
# [3,2,1,4,0] 2
# [3,2,1,0,4] 3