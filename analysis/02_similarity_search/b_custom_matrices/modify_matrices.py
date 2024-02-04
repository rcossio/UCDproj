# this script read matrices and modify them to align caseins
# Z = serine(S) or aspartate(D)
# B = threonine(T) or glutamate (E)

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
            matrixDict[row_residue+'-'+column_residue] = int(value)

    return comments,residues,matrixDict

filename=sys.argv[1]
file_output=sys.argv[2]
print(filename)
comments,residues,matrix= readMatrix(filename)


#score(Z,*) will be max{ score(S,*) ; score(D,*) }
for res in residues:
    score = max ( matrix['S-'+res], matrix['D-'+res] )
    matrix['Z-'+res] = score
    matrix[res+'-Z'] = score

#score(B,*) will be max{ score(T,*) ; score(E,*) }
for res in residues:
    score = max ( matrix['T-'+res], matrix['E-'+res] )
    matrix['B-'+res] = score
    matrix[res+'-B'] = score

output = comments
output += '  '+' '.join('%3s' % t for t in residues)+'\n'

for res_i in residues:
    output += res_i
    for res_j in residues:
        output += ' %3i' %matrix[res_i+'-'+res_j]
    output += '\n'

fileout = open(file_output,'w')
fileout.write(output)
fileout.close()

