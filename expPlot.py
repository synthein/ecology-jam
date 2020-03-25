import matplotlib.pyplot as plt
import random
import math

rate = 1
def exponentialRandom():
    uniform = random.random()
    return -math.log(uniform) / rate

samples = []

for i in range(1000):
    samples.append(exponentialRandom())

fig, axs = plt.subplots(1, 1, sharey=True, tight_layout=True)

axs.set_title("Clover spawning")
axs.set_ylabel("Number of instances (N = 1000)")
axs.set_xlabel("Distance from parent")

axs.hist(samples, bins=15)

plt.show()
