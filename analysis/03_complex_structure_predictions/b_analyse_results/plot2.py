import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap

# Load data from file
data = []
with open("tuned_all_ligand_rmsd.dat", "r") as f:
    for line in f:
        line = line.strip().split()
        data.append([float(line[4]), float(line[8]), int(line[0])])

# Extract x, y, and color values
x = [d[0] for d in data]
y = [d[1] for d in data]
colors = [d[2] for d in data]

# Create colormap for unique colors
unique_colors = list(set(colors))
n_colors = len(unique_colors)
cmap = ListedColormap(['C{}'.format(i) for i in range(n_colors)])

# Create plot with colored points
fig, ax = plt.subplots()
sc = ax.scatter(x, y, marker='o', s=10, c=colors, cmap=cmap)
plt.xlabel('RMSD')
plt.ylabel('iPTM')
# plt.title('Data from all_metrics.dat')
plt.grid(True)

# Add legend with custom labels
custom_labels = ["CRF-R", "OP-R", "NPY-R", "NK-R", "VIP-R",
                 "OT-R", "GCG-R", "GHS-R"]
legend = ax.legend(handles=sc.legend_elements()[0], labels=custom_labels,
                   loc='upper right', title='Families', fontsize='x-small')
plt.setp(legend.get_title(), fontsize='x-small')

plt.xlim(0, 30)

#plt.savefig('iptm.png', dpi=300, bbox_inches='tight')
plt.show()
