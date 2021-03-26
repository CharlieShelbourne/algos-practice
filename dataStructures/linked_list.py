
class Node: 
    def __init__(self, data=None):
        self.val = data
        self.next = None

class SinglyLinkedList:
    def __init_(self):
        self.head = None

    def appendToTail(self, data):
        val = self.head
        while val.nextVal is not None:
            val = val.nextVal
        val.nextVal = Node(data)

    def listPrint(self):
        val = self.head
        while val is not None:
            print(val.data)
            val = val.nextVal 


def appendToTail(head,data):
    val = head
    while val.next is not None:
        val = val.next
    val.next= Node(data)
    return head



"""
Remove Duplicates

1 -> 1 -> 2 -> 3 -> 3 ->
1 -> 2 -> 3 ->

Give the head Node, delete all duplicates
"""
# Return head 
# given head, check if the next node is current node 
# move to next node and check again 
# loop nodes untill reach None
# 
# self.head = data 
# self.next = None  

def giveHead(headNode: Node):
    n = headNode

    while n.nextVal is not None:
        #check if next is equal to current
        if n.nextVal.data == n.data: 
            #remove duplication
            n.nextVal = n.nextVal.nextVal
        else:
            n = n.nextVal
        
    return headNode
    

# 1 -> 1 -> 2 -> 3

def listPrint(head):
    val = head
    while val is not None:
        print(val.val)
        val = val.next 


# 1 -> 2 -> 3 -> 4 -> 5

def kthToLast(kth : int, head: Node):
    #if only 1 node return
    if head.nextVal is None:
        return "list consists of only 1 node"
    val = head
    #find kth node
    while val.data != kth:
        if val.nextVal is None: 
            return "kth is larger than length of linked list"
        #if not kth remove node
        val.data = val.nextVal.data
        val.nextVal = val.nextVal.nextVal
    
    #return list with nodes up to kth removed
    return head
    

#2 - 4 - 5 - 2 
#5 - 6 - 5 - 1

#343+465 = 807

# add digits, store and move to next 
#if number is 10 or greater must carry addition 
#if we reach the end of both list must exit array and indlude carry digit 

def addTwoNumbers(l1,l2):
    list1 = l1
    list2 = l2
    carry = 0
    while l1 is not None and l2 is not None:

        # add current numbers
        tempSum = l1.val + l2.val + carry
        carry = 0
        # if result 10 or greater then carry 10, save remainder 
        if tempSum >= 10: 
            #split the remainer and the carry
            carry = tempSum // 10
            remainder = tempSum % 10
            l1.val = remainder

        else:
            l1.val = tempSum

        # if l1 or l2 is at the end then add a 0 node 
        if l1.next is None and l2.next is not None: 
            l1.next = Node(0)
        elif l2.next is None and l1.next is not None: 
            l2.next = Node(0)
        elif l1.next is None and l2.next is None and tempSum >= 10: 
            l1.next = Node(carry)

        l1 = l1.next
        l2 = l2.next 

    return list1
        
    
list1 = Node(9)
list1 = appendToTail(list1,9)
list1 = appendToTail(list1,9)
list2 = Node(5)
list2 = appendToTail(list2,6)
list2 = appendToTail(list2,4)
list2 = appendToTail(list2,1)

result = addTwoNumbers(list1,list2)
listPrint(result)





























