import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('GPCR.csv')

num_unique_peptides_by_id = len(df['peptide_id'].unique())
num_unique_peptides_by_seq = len(df['peptide_seq'].unique())
num_unique_proteins_by_id = len(df['protein_id'].unique())
num_unique_proteins_by_seq = len(df['protein_seq'].unique())


print(f' Peptides by id: {num_unique_peptides_by_id}')
print(f' Peptides by seq: {num_unique_peptides_by_seq}')
print(f' Proteins by id: {num_unique_proteins_by_id}')
print(f' Proteins by seq: {num_unique_proteins_by_seq}')
print(f' Interactions: {len(df)}')

# make a peptide length distribution
unique_peptides = df['peptide_seq'].unique()
unique_peptide_lengths = [len(seq) for seq in unique_peptides]

plt.hist(unique_peptide_lengths, bins=49, range=(0, 50))
plt.title('Distribution of Peptide Sequence Lengths')
plt.xlabel('Peptide Sequence Length')
plt.ylabel('Frequency')
plt.savefig('analysis/peptides_distribution_length.png')
plt.close()

# make a protein length distribution
unique_proteins = df['protein_seq'].unique()
unique_protein_lengths = [len(seq) for seq in unique_proteins]

plt.hist(unique_protein_lengths, bins=35, range=(200, 650))
plt.title('Distribution of Protein Sequence Lengths')
plt.xlabel('Protein Sequence Length')
plt.ylabel('Frequency')
plt.savefig('analysis/proteins_distribution_length.png')
plt.close()
