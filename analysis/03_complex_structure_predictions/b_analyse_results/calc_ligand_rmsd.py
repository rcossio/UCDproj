
import argparse
import numpy as np 

def map3to1(residue_string):
    residue_string = residue_string.strip().upper()
    if len(residue_string) != 3:
        exit(f'***error***: residue does not have 3 letters: {residue_string}')
    if   residue_string in ['ALA','DAL']:
        return 'A'
    elif residue_string in ['ARG','DAR']:
        return 'R'
    elif residue_string in ['ASN','DAS']:
        return 'N'
    elif residue_string in ['ASP','DAS']:
        return 'D'
    elif residue_string in ['CYS','DCY']:
        return 'C'
    elif residue_string in ['GLU','DGL']:
        return 'E'
    elif residue_string in ['GLN','DGL']:
        return 'Q'
    elif residue_string in ['GLY','DGL']:
        return 'G'
    elif residue_string in ['HIS','DHI']:
        return 'H'
    elif residue_string in ['ILE','DIL']:
        return 'I'
    elif residue_string in ['LEU','DLE']:
        return 'L'
    elif residue_string in ['LYS','DLY']:
        return 'K'
    elif residue_string in ['MET','DME']:
        return 'M'
    elif residue_string in ['PHE','DPN']:
        return 'F'
    elif residue_string in ['PRO','DPR']:
        return 'P'
    elif residue_string in ['SER','DSE']:
        return 'S'
    elif residue_string in ['THR','DTH']:
        return 'T'
    elif residue_string in ['TRP','DTR']:
        return 'W'
    elif residue_string in ['TYR','DTY','TYC']:
        return 'Y'
    elif residue_string in ['VAL','DVA']:
        return 'V'
    else:
        exit(f"***error***: Unknown residue {residue_string}")        


parser = argparse.ArgumentParser()
parser.add_argument('-a', '--analog', help='analog ligandPDB file')
parser.add_argument('-e', '--endogenous', help='endogenous ligand PDB file')
parser.add_argument('-r', '--region', help='region of homology in format start,end. Example -r 12,17')
parser.add_argument('-s', '--sequence', help='sequence of homology as a string. Example -s ASDFG')
parser.add_argument('-p', '--pdb', help='endogenous PDB code')
parser.add_argument('-n', '--name', help='jobname or title')
parser.add_argument('-o', '--output', help='output file name')



args = parser.parse_args()

name = args.name
output = args.output

analog_filename = args.analog
endo_filename = args.endogenous
pdb_code = args.pdb

start,end = [int(i) for i in args.region.split(',')]
region = range(start,end+1)
endo_sequence = list(args.sequence)
offset = start-1
indexed_endo_sequence= list(zip(region,endo_sequence))

id_offset_correction = 0
if pdb_code.upper() == '7RMI':
    id_offset_correction = -5    #In the alignment is 1 but in pdb is 6
if pdb_code.upper() == '8F7W':
    id_offset_correction = -207     #In the alignment is 4 but in pdb is 211

analog_list = []
with open(analog_filename) as f:
    for line in f:
        if line.startswith("MODEL"):
            d = {}
            key=1
        elif line.startswith("ENDMDL"):
            analog_list.append(d)
        else:
            coords = [float(value) for value in line[30:54].split()]
            d[key] = coords
            key += 1

#print(analog_list[0])

endo_coords = {}
with open(endo_filename) as f:
    for line in f:
        if line.startswith("MODEL"):
            pass
        elif line.startswith("ENDMDL"):
            break
        else:
            index = int(line[23:26])+id_offset_correction  
            residue = map3to1(line[17:20])
            if (index,residue) in indexed_endo_sequence:
                coords = [float(value) for value in line[30:54].split()]
                endo_coords[index-offset] = coords

if len(endo_coords)  != (end-start+1):
    print(f"#Found {len(endo_coords)} of {end-start+1} residues in template")
    pass
else:
    print(f"#Found {len(endo_coords)} of {end-start+1} residues in template")
    pass
#print(endo_coords) 

file_out = open(output,'w')
model = 0
for analog_coords in analog_list:
    atom_count = 0
    square_displacements = 0

    rmsd = 1000.0  #just in case no common residues to compare in the next loop
    for residue in analog_coords.keys():
        if residue in endo_coords.keys():
            x1,y1,z1 = analog_coords[residue]
            x2,y2,z2 = endo_coords[residue]
            square_displacements += (x1-x2)**2+(y1-y2)**2+(z1-z2)**2
            atom_count +=1
    if atom_count != 0:
        rmsd = np.sqrt(square_displacements/float(atom_count))
    model += 1
    file_out.write('%-22s %2i %8.3f %2i  \n'%(name,model,rmsd,atom_count)) 
file_out.close()