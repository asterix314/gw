import random
from collections import deque

class RandomPolicy:
    def __init__(self, size):
        self.size = size
        self.cache = []
        self.name = 'rr'

        random.seed(207)

    def access(self, current):
        if current in self.cache: # hit!
            return True

        self.cache.append(current)

        if len(self.cache) > self.size: # exceed
            self.cache.remove(random.choice(self.cache))

        return False


class FifoPolicy:
    def __init__(self, size):
        self.size = size
        self.cache = deque()
        self.name = 'fifo'

    def access(self, current):
        if current in self.cache: # hit!
            return True

        if len(self.cache) == self.size: # full
            self.cache.popleft()

        self.cache.append(current)

        return False


class CustomPolicy:
    def __init__(self, size):
        self.size = size
        self.cache = [27,2,53,3,49][:size] # most frequently accessed
        self.name = 'custom'

    def access(self, current):
        return current in self.cache

def run_test(trace, pol):
    hit = []
    for i in range(len(trace)):
        # update cache
        hit += [pol.access(trace[i])]
    return sum(hit) / len(hit)


if __name__ == '__main__':
    # parameters
    caps = [1, 2, 3, 4, 5]

    # load trace from file
    traces = []
    for name in ['trace1.txt', 'trace2.txt']:
        with open(name) as f:
            traces += [list(eval(f.read()))]

    # test all strategies
    strategies = [
#        FifoPolicy,
        RandomPolicy,
        CustomPolicy,
    ]

    # run strategy over trace
    for i in range(len(traces)):
        for cap in caps:
            for Strategy in strategies:
                pol = Strategy(size=cap)
                print(f'data={i + 1},\tcap={cap},\tname={pol.name},\thitrate={run_test(traces[i], pol)}')
            print()