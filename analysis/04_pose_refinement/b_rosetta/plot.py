import matplotlib.pyplot as plt
import numpy as np

# Load data from file
data = np.loadtxt("tmp2.dat")

# Extract columns 1 and 2
x = data[:, 0]
y = data[:, 1]

# Create the plot
plt.scatter(x, y, s=1)
plt.xlabel("rmsd")
plt.ylabel("reweighted score")
plt.grid()

#set ylim to 1000
plt.ylim(-500, 1000)

# Display the plot
plt.show()