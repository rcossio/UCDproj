import sys

accession_number = sys.argv[3]

# Remove protein with huge extracellular domains
fasta_path = f'targets_fasta/{accession_number}.fasta'
with open(fasta_path, 'r') as f:
    seq_lines = f.read().splitlines()[1:]
    receptor_sequence = ''.join(seq_lines)
    if len(receptor_sequence) > 650:
        print(0)
    elif 'X' in receptor_sequence:
        print(0)
    else:
        print(1)
