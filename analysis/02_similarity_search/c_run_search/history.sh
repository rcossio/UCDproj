
# We skip CCKR because we have no PDBs with standard peptides
#bash run_abblast.sh 01_alignments_set1/cck_ab_output.fasta CCK1R CCK2R  

mkdir alignments/
bash run_abblast.sh BLOSUM80 2.4 alignments/muscarinic_output.fasta M1R
bash run_abblast.sh BLOSUM80 2.4 alignments/opioids_output.fasta DOPR KOPR MOPR NOPR
bash run_abblast.sh BLOSUM80 2.4 alignments/npy_output.fasta Y1R  Y2R  Y4R
bash run_abblast.sh BLOSUM80 2.4 alignments/nkr_output.fasta NK1R  
bash run_abblast.sh BLOSUM80 2.4 alignments/crf_output.fasta CRF1R CRF2R 
bash run_abblast.sh BLOSUM80 2.4 alignments/vip_output.fasta VIP1R VIP2R   
bash run_abblast.sh BLOSUM80 2.4 alignments/oxy_output.fasta OTR           
bash run_abblast.sh BLOSUM80 2.4 alignments/glc_output.fasta GCGR GIPR GLP1R GLP2R
bash run_abblast.sh BLOSUM80 2.4 alignments/ghrelin_output.fasta GHSR 

#Extract some information to a simpler file, from all the results
echo "# evalue %pos coverage querylength bitsocre alignlen %ident" > all_results.dat
cat alignments/*_output.fasta| grep 'sp'| awk '{print $3,$12,$23,$24,$5,$7,$11}' | sort -nk 1 >> all_results.dat

#Extract some information to a simpler file, from the selected results
echo "# evalue %pos coverage querylength bitsocre alignlen %ident" > selected_results.dat
cat alignments/*_output.fasta| grep -v '#'| grep 'sp'| awk '{print $3,$12,$23,$24,$5,$7,$11}' | sort -nk 1 >> selected_results.dat

#Prepares the input for the next stage
grep --no-filename 'iii' alignments/*_output_filtered.fasta | awk '!seen[$4]++' | awk '{print substr($0,6)}' > colab_fold_jobs.txt


# General run:
bash 01_run_peptide_search.sh X setX BLOSUM45 1.0

# Initial distribution of peptides
for folder in DOPR KOPR MOPR NOPR; do grep -v ">" $p_data/receptors/03_pdb_peptides/$folder/*lig.fasta; done | wc -l
for folder in Y1R  Y2R  Y4R; do grep -v ">" $p_data/receptors/03_pdb_peptides/$folder/*lig.fasta; done | wc -l
for folder in NK1R; do grep -v ">" $p_data/receptors/03_pdb_peptides/$folder/*lig.fasta; done | wc -l  
for folder in CRF1R CRF2R; do grep -v ">" $p_data/receptors/03_pdb_peptides/$folder/*lig.fasta; done | wc -l 
for folder in VIP1R VIP2R; do grep -v ">" $p_data/receptors/03_pdb_peptides/$folder/*lig.fasta; done | wc -l   
for folder in OTR; do grep -v ">" $p_data/receptors/03_pdb_peptides/$folder/*lig.fasta; done | wc -l           
for folder in GCGR GIPR GLP1R GLP2R; do grep -v ">" $p_data/receptors/03_pdb_peptides/$folder/*lig.fasta; done | wc -l
for folder in GHSR; do grep -v ">" $p_data/receptors/03_pdb_peptides/$folder/*lig.fasta; done | wc -l 
for folder in M1R; do grep -v ">" $p_data/receptors/03_pdb_peptides/$folder/*lig.fasta; done | wc -l 


#Final distribution of peptides
bash 01_run_peptide_search.sh X setX BLOSUM80 2.4
bash 01_run_peptide_search.sh X setX EDSSMat90 2.4

grep -E "DOPR|KOPR|MOPR|NOPR" colab_fold_jobs_setX.txt | wc -l
grep -E "Y1R|Y2R|Y4R" colab_fold_jobs_setX.txt | wc -l
grep -E "NK1R" colab_fold_jobs_setX.txt | wc -l
grep -E "CRF1R|CRF2R" colab_fold_jobs_setX.txt | wc -l
grep -E "VIP1R|VIP2R" colab_fold_jobs_setX.txt | wc -l
grep -E "OTR" colab_fold_jobs_setX.txt | wc -l
grep -E "GCGR|GIPR|GLP1R|GLP2R" colab_fold_jobs_setX.txt | wc -l
grep -E "GHSR" colab_fold_jobs_setX.txt | wc -l
grep -E "M1R" colab_fold_jobs_setX.txt | wc -l