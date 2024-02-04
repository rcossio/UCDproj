id=$1
set=$2
matrix=$3
evalue=$4


mkdir ${id}_alignments_${set}/
bash run_abblast.sh $matrix $evalue ${id}_alignments_${set}/opioids_output.fasta DOPR KOPR MOPR NOPR
bash run_abblast.sh $matrix $evalue ${id}_alignments_${set}/npy_output.fasta Y1R  Y2R  Y4R
bash run_abblast.sh $matrix $evalue ${id}_alignments_${set}/nkr_output.fasta NK1R  
bash run_abblast.sh $matrix $evalue ${id}_alignments_${set}/crf_output.fasta CRF1R CRF2R 
bash run_abblast.sh $matrix $evalue ${id}_alignments_${set}/vip_output.fasta VIP1R VIP2R   
bash run_abblast.sh $matrix $evalue ${id}_alignments_${set}/oxy_output.fasta OTR           
bash run_abblast.sh $matrix $evalue ${id}_alignments_${set}/glc_output.fasta GCGR GIPR GLP1R GLP2R
bash run_abblast.sh $matrix $evalue ${id}_alignments_${set}/ghrelin_output.fasta GHSR
bash run_abblast.sh $matrix $evalue ${id}_alignments_${set}/muscarinic_output.fasta M1R 

#Extract some information to a simpler file, from all the results
echo "# evalue %pos coverage querylength bitsocre alignlen %ident" > all_results_${set}.dat
cat ${id}_alignments_${set}/*_ab_output.fasta| grep 'sp'| awk '{print $3,$12,$23,$24,$5,$7,$11}' | sort -nk 1 >> all_results_${set}.dat

#Extract some information to a simpler file, from the selected results
echo "# evalue %pos coverage querylength bitsocre alignlen %ident" > selected_results_${set}.dat
cat ${id}_alignments_${set}/*_ab_output.fasta| grep -v '#'| grep 'sp'| awk '{print $3,$12,$23,$24,$5,$7,$11}' | sort -nk 1 >> selected_results_${set}.dat

#Prepares the input for the next stage
grep --no-filename 'iii' ${id}_alignments_${set}/*_ab_output_filtered.fasta | awk '!seen[$4]++' | awk '{print substr($0,6)}' > colab_fold_jobs_${set}.txt