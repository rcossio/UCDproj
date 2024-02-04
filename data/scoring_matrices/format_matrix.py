# this script read matrices and prepare the desired display for them

import sys

def readMatrix(filename):
    """ Reads the table from a given file and returns comments, residues and dictionary of entries """
    comments = ''
    content = []
    with open(filename) as file:
        # Ignore comment lines
        for line in file:
            if line.startswith("#"):
                comments += line
                continue

            if line.strip().split() == '':
                continue

            content.append(line.strip().split())

    matrixDict = {}
    residues = content[0]
    for row in content[1:]:
        row_residue = row[0]
        values = row[1:]
        for (i,value) in enumerate(values):
            column_residue = residues[i]
            matrixDict[row_residue+'-'+column_residue] = value

    return comments,residues,matrixDict


filename=sys.argv[1]
print(filename)
comments,headers,matrix= readMatrix(filename)

output = comments
desiredOrder = 'C	G	P	A	T	S	D	N	E	Q	H	K	R	Y	F	W	L	M	I	V'.split()
output += ','+','.join(desiredOrder)+'\n'
for i in desiredOrder:
    output += i+','
    line = []
    for j in desiredOrder:
        line.append(matrix[i+'-'+j])
    output += ','.join(line)
    output += '\n'

fileout = open(filename+'.csv','w')
fileout.write(output)
fileout.close()

