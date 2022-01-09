from collections import deque

class Graph:

    def __init__(self, graph):
        self.graph = graph
        self.ROW = len(graph)

    """
    Returns true if path exists from s to t and fills list of parents storing path
    """
    def BFS(self, s, t, parent):
        
        # keep track of visited nodes
        visited = [False] * self.ROW

        queue = deque()

        # start BFS with source node
        queue.append(s)
        visited[s] = True

        while queue:

            node = queue.popleft()

            # add current nodes neigbours to queue and mark as visted 
            for ind, val in enumerate(self.graph[node]):
                if visited[ind] == False and val > 0:
                    # print(ind, val)
                    queue.append(ind)
                    visited[ind] = True
                    parent[ind] = node
                    print(parent)
                    # strop BFS if we find a link between s and t
                    if ind == t:
                        return True
        
        return False

    def ford_fulkerson(self, source, sink):

        parent = [-1]*self.ROW

        max_flow = 0

        while self.BFS(source, sink, parent):
            
            path_flow = float('inf')
            print(path_flow)
            s = sink
            print(parent)
            while s != source:
                path_flow = min(path_flow, self.graph[parent[s]][s])
                s = parent[s]
                # print(s)
        
            max_flow += path_flow

            v = sink 
            while v != source:
                u = parent[v]
                # performs cut sending min link to 0
                self.graph[u][v] -= path_flow
                self.graph[v][u] += path_flow
                v = parent[v]

            print(max_flow)

        return max_flow


graph = [[0, 16, 13, 0, 0, 0],
         [0, 0, 10, 12, 0, 0],
         [0, 4, 0, 0, 14, 0],
         [0, 0, 9, 0, 0, 20],
         [0, 0, 0, 7, 0, 4],
         [0, 0, 0, 0, 0, 0]]

source = 0
sink = 5

g = Graph(graph)
max_flow = g.ford_fulkerson(source, sink)
print(max_flow)