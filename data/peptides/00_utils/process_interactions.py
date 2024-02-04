import json
import sys

name = sys.argv[1]
input_filename = f'interactions/{name}.json'
with open(input_filename) as json_file:
    interactions_list = json.load(json_file)

# Ligand output
ligand_list = []
output_string = ''
for interaction in interactions_list:
    ligandId = interaction['ligandId']
    if (ligandId != 0) and ligandId not in ligand_list:
        ligand_list.append(ligandId)
        output_string += f'{ligandId}\n'

output = open(f'01_interactions/{name}_ligands.txt', 'w')
output.write(output_string)
output.close()


if len(sys.argv) > 2:
    stop_flag = sys.argv[2] == 'no-targets'
else:
    stop_flag = False

if stop_flag:
    exit(0)

# Target output
target_list = []
output_string = ''
for interaction in interactions_list:
    targetId = interaction['targetId']
    targetSpecies = interaction['targetSpecies'].replace(' ', '%20')
    if (targetId == 0):
        continue
    if (targetId, targetSpecies) not in target_list:
        target_list.append((targetId, targetSpecies))
        output_string += f'{targetId} {targetSpecies}\n'

output = open(f'01_interactions/{name}_targets.txt', 'w')
output.write(output_string)
output.close()
