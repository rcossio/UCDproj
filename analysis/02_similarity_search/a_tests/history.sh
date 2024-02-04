# OLD: Used to run original blast
#bash run_blast.sh alignments/muscarinic_output.fasta M1R
bash run_blast.sh alignments/opioids_output.fasta DOPR KOPR MOPR NOPR
bash run_blast.sh alignments/npy_output.fasta Y1R  Y2R  Y4R
#bash run_blast.sh alignments/cck_output.fasta CCK1R CCK2R  
bash run_blast.sh alignments/nkr_output.fasta NK1R  
bash run_blast.sh alignments/crf_output.fasta CRF1R CRF2R 
bash run_blast.sh alignments/vip_output.fasta VIP1R VIP2R    
bash run_blast.sh alignments/oxy_output.fasta OTR           
bash run_blast.sh alignments/glc_output.fasta GCGR GIPR GLP1R GLP2R
bash run_blast.sh alignments/ghrelin_output.fasta GHSR 

# OLD: Used to run Smith Waterman
bash run_smithwater.sh alignments/npy_sw_output.fasta Y1R  Y2R  Y4R

# NOT OLD but yet unused, it was to create a list of extender binders
cat ../../all_binding_peptides/binders/*fasta > tmp.all_binders.fasta
blastp -query tmp.all_binders.fasta -subject ../../../caseins_sequence/all_caseins.fasta -word_size 2 -matrix BLOSUM62 -evalue 20000 -gapopen 13 -gapextend 1 -comp_based_stats 0 -ungapped -sorthits 4 | grep -A 1 -E "Query|Sbjct|Length|Score" > tmp.output.txt
# END OLD PART
