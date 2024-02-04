import json
import random
import subprocess


def get_accession_number(target_id, target_species):
    # Build the file path for the target
    file_path = f'targets_accessions/{target_id}_{target_species}.json'

    # Load the JSON file
    with open(file_path, 'r') as f:
        data = json.load(f)

    # Find the entry with the "database" property set to "UniProtKB"
    for entry in data:
        if entry['database'] == 'UniProtKB':
            # Return the value of the "accession" property
            return entry['accession']

    # If no entry is found, return error
    exit('Error. No UniProtKB entry found.')


# Load nonbinders
with open('interactions/accepted_nonbinders.txt', 'r') as f:
    accepted_nonligands = [i.strip() for i in f.readlines()]

known_sequences = []
final_nonligands = []
for ligand_id in accepted_nonligands:
    ligand_path = f'ligands/iuphar/{ligand_id}.json'

    with open(ligand_path, 'r') as f:
        ligand = json.load(f)

    ligand_sequence = ligand['oneLetterSeq']
    if ligand_sequence in known_sequences:
        continue
    else:
        final_nonligands.append(('i'+ligand_id, ligand_sequence))
        known_sequences.append(ligand_sequence)


# Load other peptides
total_peptides = 413
while len(final_nonligands) < total_peptides:
    random_number = random.randint(1, 4096175)
    # number of peptides in peptidepedia fasta (but some are missing)

    try:
        output = subprocess.check_output(['grep', '-A', '1',
                                          f'>{random_number} ',
                                          'ligands/peptipedia/dump.fasta'])
    except subprocess.CalledProcessError:
        continue

    output_str = output.decode('utf-8').split('\n')[:-1]
    peptide_id = output_str[0][1:].strip()
    peptide_sequence = output_str[1]

    if peptide_sequence in known_sequences:
        continue

    if len(peptide_sequence) < 5:
        continue

    if len(peptide_sequence) >= 50:
        continue

    if 'X' in list(peptide_sequence):
        continue

    final_nonligands.append(('p'+peptide_id, peptide_sequence))
    print(len(final_nonligands))

# Load the targets
with open('interactions/accepted_targets.txt', 'r') as f:
    accepted_targets = [i.replace(' ', '_').strip() for i in f.readlines()]

final_targets = []
for gpcr_target in accepted_targets:
    # Get the target ID and species
    target_id = gpcr_target.split('_')[0]
    target_species = gpcr_target.split('_')[1]

    accession_number = get_accession_number(target_id, target_species)
    fasta_path = f'targets_fasta/{accession_number}.fasta'

    with open(fasta_path, 'r') as f:
        sequences = f.read().splitlines()[1:]
        gpcr_sequence = ''.join(sequences)
    final_targets.append((gpcr_target, accession_number, gpcr_sequence))

# Loop over targets
output = open('nonGPCR.csv', 'w')
output.write('peptide_id,protein_id,protein_uniprot,protein_seq,peptide_seq\n')
for ligand_id, ligand_sequence in final_nonligands:
    selected_integers = random.sample(list(range(len(final_targets))), 3)
    for i in selected_integers:
        target_name, accession_number, gpcr_sequence = final_targets[i]
        output.write(f'{ligand_id},{target_name},{accession_number},{gpcr_sequence},{ligand_sequence}\n')
output.close()
