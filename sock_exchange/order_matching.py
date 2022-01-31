
from dataclasses import dataclass

import heapq as hq
from datetime import datetime

@dataclass(frozen=True)
class SellOrder:
    id: int
    price: float
    quantity: int
    stock: str
    time_stamp: int
    residual_orders: list

    def __lt__(self, other):
        if type(other) is not SellOrder:
            raise TypeError
        
        if self.price < other.price:
            return True
        elif self.price > other.price:
            return False
        
        if self.time_stamp < other.time_stamp:
            return True
        else:
            return False

@dataclass(frozen=True)
class BuyOrder:
    id: int
    price: float
    quantity: int
    stock: str
    time_stamp: int
    residual_orders: list

    def __lt__(self, other):
        if type(other) is not BuyOrder:
            raise TypeError
        
        if self.price > other.price:
            return True
        elif self.price < other.price:
            return False
        
        if self.time_stamp < other.time_stamp:
            return True
        else:
            return False


# match buy orders to sell orders
# update orders as they arrive
# maitain the order of buys highest prices sells first or first come first served
# maintain order of sells, sell lowest price first or first come first served
# order splitting, if a buy or sell order is not totally for filled and new order is placed with the remaining amount (time stamp kept)

class order_matcher:

    def __init__(self, buys: list = [], sells: list = []):
        self.sell_iter = len(sells)
        self.buy_iter = len(buys)

        hq.heapify(buys) # O(B)
        hq.heapify(sells) # O(S)
    
        self.buys = buys
        self.sells = sells

    def match(self):
        if not self.buys or not self.sells:
            return None

        if self.buys[0].price < self.sells[0].price:
            return None

        buy = hq.heappop(self.buys)
        sell = hq.heappop(self.sells)

        residual_quantity = buy.quantity - sell.quantity
        #case stock left to buy
        if residual_quantity < 0:
            new_sell = SellOrder(id=self.sell_iter, price=sell.price, quantity=-residual_quantity, stock=sell.stock, time_stamp=sell.time_stamp, residual_orders=[])
            self.sell_iter += 1
            sell.residual_orders.append(new_sell.id)
            self.add_sell(new_sell) # O(logS)
        # case more sock wanted
        elif residual_quantity > 0:
            new_buy = BuyOrder(id=self.buy_iter, price=buy.price, quantity=residual_quantity, stock=buy.stock, time_stamp=buy.time_stamp, residual_orders=[])
            buy.residual_orders.append(new_buy.id)
            self.add_buy(new_buy) # O(logB)
            
        return (buy, sell)

    def add_buy(self, buy):
        hq.heappush(self.buys, buy)

    def add_sell(self, sell):
        hq.heappush(self.sells, sell)

        



buys = [BuyOrder(id=i, price=i, quantity=i, stock="AMZ", time_stamp=i, residual_orders=[]) for i in range(5)]
sells = [SellOrder(id=i, price=i, quantity=i, stock="AMZ", time_stamp=i, residual_orders=[]) for i in range(5)]

matcher = order_matcher(buys=buys, sells=sells)
matched_orders = [matcher.match() for i in range(6)]

print(matched_orders)
print(len(matcher.buys))
print(len(matcher.sells))
print(matcher.buys)
print(matcher.sells)