import sys
import numpy as np
import argparse

# create argument parser
parser = argparse.ArgumentParser()
parser.add_argument('-i', '--input', help='input PDB file')
parser.add_argument('-m', '--matrix', help='matrix file')
parser.add_argument('-c', '--chains', help='chains in format R,P')
parser.add_argument('-o', '--output', help='output file')
parser.add_argument('-r', '--repeat', help='number of times to repeat PDB in output file to simulate a trajectory')
args = parser.parse_args()

original_pdb = args.input #sys.argv[1]
selected_chains = args.chains.split(',') #sys.argv[2].split(',')
output_filename = args.output #sys.argv[3]
matrix_filename = args.matrix #sys.argv[4]
repeat = int(args.repeat) #int(sys.argv[5])

m = [ line.split()[2:] for line in open(matrix_filename,'r').readlines()[2:5]]
m = np.array(m,dtype=np.float64)

t = [ line.split()[1] for line in open(matrix_filename,'r').readlines()[2:5]]
t = np.array(t,dtype=np.float64)

chain_dict = {}
for line in open(original_pdb):

    if line[0:4] == 'ATOM' or line[0:6] == 'HETATM':

        chain = line.split()[4]
        if chain in selected_chains:
            x0 = float(line[30:38])
            y0 = float(line[38:46])
            z0 = float(line[46:54])

            x = t[0] + m[0,0]*x0 + m[0,1]*y0 + m[0,2]*z0
            y = t[1] + m[1,0]*x0 + m[1,1]*y0 + m[1,2]*z0
            z = t[2] + m[2,0]*x0 + m[2,1]*y0 + m[2,2]*z0

            if chain in list(chain_dict.keys()):
                chain_dict[chain] += line[0:30]+"%8.3f%8.3f%8.3f"%(x,y,z)+line[54:]
            else:
                chain_dict[chain] = line[0:30]+"%8.3f%8.3f%8.3f"%(x,y,z)+line[54:]

output_string = ''
for i in range(repeat):
    output_string += 'MODEL\n'
    for chain in chain_dict.keys():
        output_string += chain_dict[chain]
        output_string += 'TER \n'
    output_string += 'ENDMDL\n'
output_string += 'END'

output_file = open(output_filename,'w')
output_file.write(output_string)
output_file.close()