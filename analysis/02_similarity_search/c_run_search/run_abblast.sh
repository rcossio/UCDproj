matrix_name=$1
filter_evalue=$2
output_file=$3

{
for receptor in "${@:4}"
do
	echo ""
    echo ">>----------------------------------------------"	
	echo ">> Blasting receptor ${receptor}"
	echo ">>----------------------------------------------"
	
	query=$p_data/receptors/03_pdb_peptides/${receptor}/${receptor}_lig.fasta
	
	export ABBLASTDB=$p_analysis/02_casein/phosphorilation_sites/
	subjects=phosphomimic.fasta

	matrix=$p_analysis/03_analog_peptides/01_blastp_results/01_custom_scoring/modified_matrices/${matrix_name}_custom

	table=yes
	evalue=100

	if [ ! "$table" == "yes" ]
	then
		ab-blastp $subjects $query echofilter evalues stats sort_by_highscore span postsw V=10000 W=1 matrix=$matrix E=$evalue Q=33 R=3 
	else
		echo "# qid       sid                     E       njo bitS    S   len nid n+  nmm %ident %pos     qga qgl sga sgl qfr qst qen sfr sst sen cov qlen"
		ab-blastp $subjects $query evalues sort_by_highscore span postsw V=10000 W=1 matrix=$matrix E=$evalue Q=33 R=3 mformat=2 O=tmp.${receptor}.out > /dev/null
		python3 filter_abblast.py tmp.${receptor}.out $query $ABBLASTDB/$subjects $matrix $receptor $filter_evalue 
		rm tmp.${receptor}.out
	fi

done
echo ">> END"
} > $output_file
grep -v "#" $output_file > $(echo $output_file | sed -e "s/.fasta/_filtered.fasta/g")
