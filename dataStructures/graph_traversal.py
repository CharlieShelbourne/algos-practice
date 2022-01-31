
from xml.dom import Node


graph = {
    4: [],
    6: [],
    2: [1,3,4],
    1: [2,3,4],
    3: [4,5],
    5: [6],
}

# I can start at any node in the graph 
# I used depth first serach and recursion to record node in a top down approach 
# Need to make sure every node is visted, therefore need to lauch DFS from multiple nodes (for loop)
# Output a post-order traversal 
# reverse this order to get a topological order
global visited
global post_order_traversal
def topological_sort(graph : dict):
    visited = set()
    post_order_traversal = []

    def dfs(node):
        
        visited.add(node)
        # print(node, visited)

        if len(graph[node]) < 1:
            post_order_traversal.append(node)
            return 

        for child in graph[node]:
            if child not in visited:
                dfs(child)
        post_order_traversal.append(node)
            
        return

    for cur_node in graph:
        if cur_node not in visited:
            dfs(cur_node)

    return list(reversed(post_order_traversal))

print(topological_sort(graph))


def pre_order_sort(graph : dict):
    visited = set()
    pre_order_traversal = []

    def dfs(node, traversal):
        
        visited.add(node)
        traversal.append(node)

        if len(graph[node]) < 1:
            return 

        for child in graph[node]:
            if child not in visited:
                dfs(child, traversal)
            
        return

    for cur_node in graph:
        if cur_node not in visited:
            dfs(cur_node, pre_order_traversal)

    return pre_order_traversal

print(pre_order_sort(graph))