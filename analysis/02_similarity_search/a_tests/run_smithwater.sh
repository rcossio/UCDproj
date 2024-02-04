#Families: 
#mucarinic: M1R 
#opioids: 	DOPR KOPR MOPR NOPR
#npy: 		Y1R  Y2R  Y4R
#CCK: 		CCK1R CCK2R
#NKR: 		NK1R
#CRF: 		CRF1R CRF2R
#VIP: 		VIP1R VIP2R
#oxytocin: 	OTR
#glucagon: 	GCGR GIPR GLP1R GLP2R
#ghrelin: 	GHSR

output_file=$1

{
for receptor in "${@:2}"
do
	echo ""
        echo "----------------------------------------------"	
	echo "Blasting receptor ${receptor}"
	echo "----------------------------------------------"

	query=$p_data/receptors/pdb_peptides/${receptor}/${receptor}_lig.fasta
	subjects=$p_analysis/02_casein_analysis/phosphorilation_sites/tmp.fasta

	matrix=EBLOSUM62 #$p_data/scoring_matrices/EDSSMat50  #$p_analysis/03_analog_peptides/blastp_results/custom_scoring/BLOSUM62_modified
	table=no
	evalue=100

	if [ ! "$table" == "yes" ]
	then
		water -asequence $query  -bsequence $subjects -datafile $matrix -gapopen 11 -gapextend 2
	else
		ab-blastp $subjects $query W=2 matrix=$matrix E=$evalue Q=12 R=2 mformat=2
		#python3 filter.py tmp.${receptor}.out
		#rm tmp.${receptor}.out
	fi

done
} > $output_file
