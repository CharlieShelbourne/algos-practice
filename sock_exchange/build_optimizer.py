def optimal_order(predecessors_map, weight_map):
    vertices = frozenset(predecessors_map.keys())
    # print(vertices)
    memo_map = {frozenset(): (0, [])}
    # print(memo_map)
    return optimal_order_helper(predecessors_map, weight_map, vertices, memo_map)


def optimal_order_helper(predecessors_map, weight_map, vertices, memo_map):
    if vertices in memo_map:
        return memo_map[vertices]
    possibilities = []
    # koop through my verticies (number reducing by 1 each time)
    for v in vertices:
        # use DFS to get to either x or v which are the 2 smallest numbers
        if any(u in vertices for u in predecessors_map[v]):
            continue
        sub_obj, sub_order = optimal_order_helper(predecessors_map, weight_map, vertices - frozenset({v}), memo_map)
        # x + x*y + x*y*z = x*(1 + y*(1 + z))
        possibilities.append((weight_map[v] * (1.0 + sub_obj), [v] + sub_order))

    print(possibilities)
    best = min(possibilities)
    memo_map[vertices] = best
    # print(memo_map)
    return best


print(optimal_order({'u': [], 'v': ['u'], 'w': [], 'x': ['w']}, {'u': 1.2, 'v': 0.5, 'w': 1.1, 'x': 1.001}))