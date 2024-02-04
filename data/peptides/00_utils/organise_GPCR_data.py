import json


def get_accession_number(target_id, target_species):
    file_path = f'targets_accessions/{target_id}_{target_species}.json'
    with open(file_path, 'r') as f:
        data = json.load(f)

    for entry in data:
        if entry['database'] == 'UniProtKB':
            return entry['accession']

    exit('Error. No UniProtKB entry found.')


# Load the interactions from the JSON file
with open('interactions/GPCR.json', 'r') as f:
    interactions = json.load(f)

with open('interactions/accepted_binders.txt', 'r') as f:
    accepted_ligands = [i.strip() for i in f.readlines()]

with open('interactions/accepted_targets.txt', 'r') as f:
    accepted_targets = [i.replace(' ', '_').strip() for i in f.readlines()]

# Loop over the interactions
output = open('GPCR.csv', 'w')
output.write('peptide_id,protein_id,protein_uniprot,protein_seq,peptide_seq,affinity,affinityParameter\n')
for interaction in interactions:
    target_id = interaction['targetId']
    target_species = interaction['targetSpecies']
    if not (f'{target_id}_{target_species}' in accepted_targets):
        continue

    ligand_id = interaction['ligandId']
    if not (str(ligand_id) in accepted_ligands):
        continue

    affinityParameter = interaction['affinityParameter']
    affinity = interaction['affinity'].strip()
    if affinity == '':
        affinity = 'N/A'
    else:
        try:
            affinity = float(interaction['affinity'])
        except ValueError:
            af1, af2 = map(float, interaction['affinity'].split('-'))
            affinity = (af1 + af2) / 2

    accession_number = get_accession_number(target_id, target_species)
    fasta_path = f'targets_fasta/{accession_number}.fasta'

    with open(fasta_path, 'r') as f:
        sequences = f.read().splitlines()[1:]
        receptor_sequence = ''.join(sequences)

    # Get the ligand ID and check if the file exists
    ligand_path = f'ligands/iuphar/{ligand_id}.json'
    with open(ligand_path, 'r') as f:
        ligand = json.load(f)

    ligand_sequence = ligand['oneLetterSeq']

    output.write(f'{ligand_id},{target_id}_{target_species},{accession_number},{receptor_sequence},{ligand_sequence},{affinity},{affinityParameter}\n')


output.close()
