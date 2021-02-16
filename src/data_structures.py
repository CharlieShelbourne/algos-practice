
def find_numbers(list_of_numbers):
    
    if len(list_of_numbers) == 0: 
        return "empty list"
    
    even_num_count = 0
    for number in list_of_numbers:

        if (len(str(number))%2) == 0:
            even_num_count += 1

    return print(even_num_count)


#find_numbers([12,345,2,6,7896])


def sorted_squares(list_numbers):

    if len(list_numbers) == 0: 
        return "empty list"

    for i, number in enumerate(list_numbers):
        list_numbers[i] = list_numbers[i] ** 2

    return print(sorted(list_numbers)) 

#sorted_squares([-4,-1,0,3,10])


def string_permutation(string1, string2):

    if string1 == string2:
        return True
    elif len(string1) != len(string2):
        return False
    else: 
        count = 0
        for i, char in enumerate(sorted(string1)):
            if char == sorted(string2)[i]:
                count += 1

        return count == len(string1)


#print(string_permutation("Charlie","eilrah"))


def URLify(string_in):

    if len(string_in) == 0: 
        return "empty string"

    string_out = ""
    for i, char in enumerate(string_in):
        if i == 0 and char == " ": 
            string_out += "%20"
        elif char == " " and string_in[i-1] !=" ":
            string_out += "%20"
        else:  
            string_out += char
    return string_out

#print(URLify("Mr John Smith    "))

arr = [1, 2, 3, 4]

# a1 >= a2 <= a3 >= a4 <= a5 ...
# [2, 1, 4, 3] (return this one)
# [4, 1, 3, 2]
# [1,2,3,4,5]
#[2,1,4,3,5]
# If there are mutliple answers, return the one which is lexicographically smallest

# [1, 2, 3]
# i = 0
# i = 2

# for i range(3)

# for i range(0, 3, 2)

def wave_array(list_in):

    if len(list_in) ==0:
        return []
    elif len(list_in) == 1:
        return list_in
    else: 
        list_in = sorted(list_in)

        for i in range(0,len(list_in)-1,2):
            temp = list_in[i]
            list_in[i] = list_in[i+1]
            list_in[i+1]= temp
        
        return list_in

print(wave_array([1, 2, 3, 4, 5, 6, 7]))
    




# [1, 2, 3, 4] = [2,1,4,3]
# [1, 2, 3, 4, 5] = [2,1,4,3,5]