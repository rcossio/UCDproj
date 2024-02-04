
# YOU CANT RUN THIS IF YOU DIDNT RUN 05_models_mergind.sh
# WE NEED THE STRUCTURES AKREADY ALIGNED

set=set1
alignment_set_folder=01_alignments_set1

colabjobs=$p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/colab_fold_jobs_${set}.txt

for index in {27..27}
do
    jobname=$(head -n $index $colabjobs | tail -1 | awk '{print $1}')
    receptor=$(head -n $index $colabjobs | tail -1 | awk '{print $2}')
    echo "#$jobname $receptor"

    pdbcode=$(echo $jobname | awk '{print tolower($0)}' | awk '{print substr($0,0,4)}')
    chains=$(bash map_pdb_to_chains.sh $pdbcode)
    IFS=, read -r chain1 chain2 <<< $chains

    outdir=predictions/$jobname
    [ ! -d $outdir/models_merging ] && mkdir $outdir/models_merging

    [ -f $outdir/models_merging/models.pdb ] && rm $outdir/models_merging/models.pdb
    [ -f $outdir/models_merging/$pdbcode.pdb ] && rm $outdir/models_merging/$pdbcode.pdb
    [ -f $outdir/models_merging/metrics.dat ] && rm $outdir/models_merging/metrics.dat

    # Get alignments
    grep -h -B 5 "${jobname}.*${receptor}" $p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/$alignment_set_folder/*ab_output_filtered.fasta | head -3 > $outdir/models_merging/abblast.fasta
    grep -h -B 5 "${jobname}.*${receptor}" $p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/$alignment_set_folder/*ab_output_filtered.fasta | head -3
    grep "ATOM" $p_data/receptors/03_pdb_peptides/$receptor/$pdbcode.pdb | grep " $chain1 " > tmp_tmalignref.pdb 

    for rank in {1..5}
    do
        sed -e "s/ A / R /g;s/ B / P /g" $outdir/relaxed/rank_00${rank}_model*seed_000.pdb | grep -v "      H" >> tmp_model.pdb
        
        #superimpose real PDB
        TMalign tmp_model.pdb tmp_tmalignref.pdb -m tmp_matrix.txt > $outdir/models_merging/tmalign_rank_${rank}.log
        RMSD=$(grep "RMSD=" $outdir/models_merging/tmalign_rank_${rank}.log | awk '{print $5}'| sed "s/,//g")
        aligned_length=$(grep "Aligned length=" $outdir/models_merging/tmalign_rank_${rank}.log | awk '{print $3}'| sed "s/,//g")
        python3 transform_pdb.py -i tmp_model.pdb -c R,P -o tmp_aligned.pdb -m tmp_matrix.txt -r 1
        #Older implementation: python3 transform_pdb.py tmp_model.pdb R,P tmp_aligned.pdb tmp_matrix.txt 1

        #This is to get requences from the ligand
        #grep -E "ATOM" $p_data/receptors/03_pdb_peptides/$receptor/$pdbcode.pdb | grep " $chain2 " | grep "CA" >> tmp_seq_a.pdb
        #grep -E "ATOM" tmp_aligned.pdb | grep " P " | grep "CA" >> tmp_seq_b.pdb

        rm tmp_model.pdb
        rm tmp_matrix.txt

        #We do this each time to visualizeit in vmd 
        echo "MODEL" >> $outdir/models_merging/$pdbcode.pdb
        grep -E "ATOM|HETATM" $p_data/receptors/03_pdb_peptides/$receptor/$pdbcode.pdb | grep -E " $chain1 | $chain2 " >> $outdir/models_merging/$pdbcode.pdb
        echo "ENDMDL" >> $outdir/models_merging/$pdbcode.pdb

        head -n -1 tmp_aligned.pdb >> $outdir/models_merging/models.pdb
        rm tmp_aligned.pdb

        #Save relevant features
        echo "$rank $aligned_length $RMSD" >> $outdir/models_merging/metrics.dat

    done

    rm tmp_tmalignref.pdb

    # Write visualizer
    sed -e "s/REFPDBFILENAME/predictions\/$jobname\/models_merging\/$pdbcode.pdb/g;s/PDBFILENAME/predictions\/$jobname\/models_merging\/models.pdb/g;s/CH1/$chain1/g;s/CH2/$chain2/g;" script_templates/template_backbones.vmd > $outdir/models_merging/view.vmd

    echo "vmd -e $outdir/models_merging/view.vmd"

done
