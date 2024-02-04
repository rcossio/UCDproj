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
        echo "#----------------------------------------------"	
	echo "# Blasting receptor ${receptor}"
	echo "#----------------------------------------------"	
	query=$p_data/receptors/03_pdb_peptides/${receptor}/${receptor}_lig.fasta
	subjects=$p_analysis/02_casein_analysis/phosphorilation_sites/phosphomimic.fasta
	matrix=BLOSUM62
	table=no
	evalue=100

	if [ ! "$table" == "yes" ]
	then
		blastp -query $query -subject $subjects -word_size 2 -matrix $matrix -evalue $evalue -gapopen 11 -gapextend 2 -outfmt 0 
	else
		blastp -out tmp.${receptor}.out -query $query -subject $subjects -word_size 2 -matrix $matrix -evalue $evalue -gapopen 13 -gapextend 1 -comp_based_stats 0 -outfmt '6 delim=  qacc sacc qlen slen length nident positive gaps bitscore score evalue qcovhsp qstart qseq qend  sstart sseq send'
		python3 filter_blast.py tmp.${receptor}.out
		rm tmp.${receptor}.out
	fi

done
} > $output_file

# For BLASTP
#	qseqid means Query Seq-id
#   	       qgi means Query GI
#   	      qacc means Query accesion
#   	   qaccver means Query accesion.version
#   	      qlen means Query sequence length
#   	    sseqid means Subject Seq-id
#   	 sallseqid means All subject Seq-id(s), separated by a ';'
#   	       sgi means Subject GI
#   	    sallgi means All subject GIs
#   	      sacc means Subject accession
#   	   saccver means Subject accession.version
#   	   sallacc means All subject accessions
#   	      slen means Subject sequence length
#   	    qstart means Start of alignment in query
#   	      qend means End of alignment in query
#   	    sstart means Start of alignment in subject
#   	      send means End of alignment in subject
#   	      qseq means Aligned part of query sequence
#   	      sseq means Aligned part of subject sequence
#   	    evalue means Expect value
#   	  bitscore means Bit score
#   	     score means Raw score
#   	    length means Alignment length
#   	    pident means Percentage of identical matches
#   	    nident means Number of identical matches
#   	  mismatch means Number of mismatches
#   	  positive means Number of positive-scoring matches
#   	   gapopen means Number of gap openings
#   	      gaps means Total number of gaps
#   	      ppos means Percentage of positive-scoring matches
#   	    frames means Query and subject frames separated by a '/'
#   	    qframe means Query frame
#   	    sframe means Subject frame
#   	      btop means Blast traceback operations (BTOP)
#   	    staxid means Subject Taxonomy ID
#   	  ssciname means Subject Scientific Name
#   	  scomname means Subject Common Name
#   	sblastname means Subject Blast Name
#   	 sskingdom means Subject Super Kingdom
#   	   staxids means unique Subject Taxonomy ID(s), separated by a ';' (in numerical order)
#   	 sscinames means unique Subject Scientific Name(s), separated by a ';'
#   	 scomnames means unique Subject Common Name(s), separated by a ';'
#   	sblastnames means unique Subject Blast Name(s), separated by a ';'  (in alphabetical order)
#   	sskingdoms means unique Subject Super Kingdom(s), separated by a ';'  (in alphabetical order)
#   	    stitle means Subject Title
#   	salltitles means All Subject Title(s), separated by a '<>'
#   	   sstrand means Subject Strand
#   	     qcovs means Query Coverage Per Subject
#   	   qcovhsp means Query Coverage Per HSP