
set=set3
alignment_set_folder=03_alignments_set3
colabjobs=$p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/colab_fold_jobs_${set}.txt

for index in {1..36}
do
    jobname=$(head -n $index $colabjobs | tail -1 | awk '{print $1}')
    receptor=$(head -n $index $colabjobs | tail -1 | awk '{print $2}')
    echo "#$jobname $receptor"

    pdbcode=$(echo $jobname | awk '{print tolower($0)}' | awk '{print substr($0,0,4)}')
    chains=$(bash map_pdb_to_chains.sh $pdbcode)
    IFS=, read -r chain1 chain2 <<< $chains

    outdir=predictions/$jobname
    [ ! -d $outdir/ligand_rmsd ] && mkdir $outdir/ligand_rmsd

    # Get alignments
    grep -h -B 5 "${jobname}.*${receptor}" $p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/$alignment_set_folder/*ab_output_filtered.fasta | head -3
    grep -h -B 5 "${jobname}.*${receptor}" $p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/$alignment_set_folder/*ab_output_filtered.fasta | head -1 > tmp_alignment.txt
    region=$(cat tmp_alignment.txt | awk '{print $2","$4}')
    sequence=$(cat tmp_alignment.txt | awk '{print $3}')
    rm tmp_alignment.txt

    grep -E "MODEL|ENDMDL| CA " $outdir/models_merging/$pdbcode.pdb | grep -E "MODEL|ENDMDL| $chain2 "  > $outdir/ligand_rmsd/endogenous_ligand.pdb
    grep -E "MODEL|ENDMDL| CA " $outdir/models_merging/models.pdb | grep -E "MODEL|ENDMDL| P " > $outdir/ligand_rmsd/analog_ligand_rank_${rank}.pdb
    python3 calc_ligand_rmsd.py -n $jobname -p $pdbcode -s $sequence -r $region -a $outdir/ligand_rmsd/analog_ligand_rank_${rank}.pdb -e $outdir/ligand_rmsd/endogenous_ligand.pdb -o $outdir/ligand_rmsd/rmsd.dat

    [ -f $outdir/ligand_rmsd/ptm.dat ] && rm $outdir/ligand_rmsd/ptm.dat
    for rank in {1..5}
    do
        #This is the format:
        #2023-02-08 20:10:48,712 rank_001_alphafold2_multimer_v3_model_2_seed_000 pLDDT=67.4 pTM=0.579 ipTM=0.449
        grep "rank_00$rank" $outdir/log.txt | awk -F' |=' '{print $5,$7,$9}' >> $outdir/ligand_rmsd/ptm.dat
    done

    paste -d' ' $outdir/ligand_rmsd/rmsd.dat $outdir/ligand_rmsd/ptm.dat > $outdir/ligand_rmsd/all.dat

done
