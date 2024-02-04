import sys
import json

ligand_id = sys.argv[1]

ligand_path = f'ligands/iuphar/{ligand_id}.json'

with open(ligand_path, 'r') as f:
    ligand = json.load(f)

# Check if the "oneLetterSeq" property is not empty
# and does not contain "X","-", or "("
ligand_sequence = ligand['oneLetterSeq']
post_mod = ligand['postTranslationalModifications'].lower()
chem_mod = ligand['chemicalModifications'].lower()

if (ligand_sequence is None):
    print('Invalid: none')
    exit()

if ligand_sequence == "":
    print('Invalid: empty')
    exit()

if 'X' in list(ligand_sequence):
    print('Invalid: X')
    exit()

if 'Z' in list(ligand_sequence):
    print('Invalid: Z')
    exit()

if 'B' in list(ligand_sequence):
    print('Invalid: B')
    exit()

if 'J' in list(ligand_sequence):
    print('Invalid: J')
    exit()

if '-' in list(ligand_sequence):
    print('Invalid: -')
    exit()

if '2' in list(ligand_sequence):
    print('Invalid: -')
    exit()

if '(' in list(ligand_sequence):
    print('Invalid: ()')
    exit()

if len(ligand_sequence) < 5:
    print('Invalid: <5')
    exit()

if len(ligand_sequence) >= 50:
    print('Invalid: >50')
    exit()

# '\u03B2' is beta
words_to_remove = ['cycle', 'cyclic', 'bridge', 'disulphide', 'disulfide',
                   'diuslphide', 'carboxylation', 'myr-gly', 'cholesterol',
                   'covalently', 'covalently', 'sulfated', 'branched', 'label',
                   'd-isoform', 'd-isomers', 'd isomer', 'd-', 'd amino acid',
                   'pyroglutamate', 'p-amino-phenylalanine', 'norleucine',
                   'dota', 'fluor', 'butyloxycarbonyl', 'butoxycarbonyl',
                   'rhodamine', 'isopropyl-ureido', 'pyrrolidine carboxylic',
                   'pyrrolidone carboxylic', 'iodin', 'radio', 'conjugated',
                   'nicotinoyl', 'palmitoylated', 'palmitate', 'octanoylated',
                   'octanoyl', 'decanoyl', 'lauroyl', 'myristoyl', 'stearoyl',
                   'sarcosine', 'dpegylated', 'furoyl', 'bond between',
                   'n-linked glycosylation', 'naphthalenyl', 'butyl', 'bromin',
                   'phospho', 'tert-leu', 'benzyl', 'palmitoyl', 'pentenyl',
                   'succinyl', 'benzoyl', 'deamino-cysteine',
                   'pwt1 chemical core', '\u03B2',
                   'replaced with pmp', 'pmp--tyr', '<sup>125</sup>i', 'beta']

for word in words_to_remove:
    if word in post_mod:
        print(f'Invalid: {word}')
        exit()

    if word in chem_mod:
        print(f'Invalid: {word}')
        exit()


with open('interactions/GPCR_ligands.txt', 'r') as f:
    gpcr_interactions = [i.strip() for i in f.readlines()]

with open('interactions/all_ligands.txt', 'r') as f:
    all_interactions = [i.strip() for i in f.readlines()]

if (ligand_id in gpcr_interactions):
    print('B')
    exit()
elif (ligand_id in all_interactions) and not (ligand_id in gpcr_interactions):
    print('NB')
    exit()
else:
    raise Exception('Ligand has to be in a set!')
