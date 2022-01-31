# given a sequence of characters compress the sequences using the huffman tree method
# convert characters into bit sequences thereby reducing the number of bits it take to hold a sequence 

# steps 
# parse the input charracter sequences 
# count frequency of occurences for each character 
# build huffman tree 
    # interatively find smallest and add node/nodes to tree 
# traverse tree building bit sequencesfor each character: 0 for left branch 1 for right branch

class Node:
    def __init__(self, count, char=None):
        self.count = count
        self.left = None
        self.right = None
        self.char = char

    # override the comparison operator
    def __lt__(self, nxt):
        return self.count < nxt.count

from collections import Counter, deque
import heapq as hq

def compress_string(input_string):

    # create count of all chars
    char_counts = Counter(input_string) # O(n)

    print(char_counts)

    unique_chars = list(char_counts.keys())

    # sort unqiue chars min occurences to max
    # build list of nodes 
    heap = hq.heapify([])
    # print(heap)
    nodes = [Node(count=char_counts[c], char=c) for c in unique_chars] # O(n) worse case
    hq.heapify(nodes) # O(n) worst case
    # loop through nodes and bulld Huffman tree
    root = None
    # sub_trees = deque()
    while len(nodes) > 1: # O(n) worse case
        node1 = hq.heappop(nodes)
        node2 = hq.heappop(nodes)

        root = Node(node1.count + node2.count)
        print(f"left {node1.count}")
        root.left = node1
        print(f"right {node2.count}")
        root.right = node2

        nodes.append(root)


    if len(nodes) > 0:
        root = nodes[0]

    bit_map = {}
    # traverse tree and update bit map
    # dfs 
    stack = [(root,'')]
    while stack:  # O(n) worst case
        node, bits = stack.pop()
        if node is not None:
            # print(node.char)
            if node.char is not None:
                bit_map[node.char] = bits
                # print(node.char)

            stack.append((node.right, bits + '1'))
            stack.append((node.left, bits + '0'))
            
    
    print(bit_map)

    # build string with binary codes
    output = ''
    for char in input_string: # O(n)
        output = output + bit_map[char]

    return output

print(compress_string("AAAAAAAAAAAAAAABBBBBBBCCCCCCDDDDDDEEEEE"))
    



    

     