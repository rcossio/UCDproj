# This scripts appends all the unrelaxed structures from the recycles to a file (in reverse order),
# then aligns the pdb reference to them and prepares a visualization state
colabjobs=$p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/colab_fold_jobs_set3.txt

for index in {10..10}
do

    jobname=$(head -n $index $colabjobs | tail -1 | awk '{print $1}')
    receptor=$(head -n $index $colabjobs | tail -1 | awk '{print $2}')
    
    echo "#$jobname $receptor"

    pdbcode=$(echo $jobname | awk '{print tolower($0)}' | awk '{print substr($0,0,4)}')

    chains=$(bash map_pdb_to_chains.sh $pdbcode)

    outdir=predictions/$jobname

    [ ! -d $outdir/recycles_merging ] && mkdir $outdir/recycles_merging

    for rank in {1..5}
    do
        pdbfilename=rank_${rank}.pdb 

        [ -f $outdir/recycles_merging/tmp_$pdbfilename ] && rm $outdir/recycles_merging/tmp_$pdbfilename
        for recycle in {20..1}
        do 
            if [ -f $outdir/unrelaxed/rank_00${rank}_model*seed_000.r${recycle}.pdb ]
            then
                head -n -1 $outdir/unrelaxed/rank_00${rank}_model*seed_000.r${recycle}.pdb >> $outdir/recycles_merging/tmp_$pdbfilename
            fi
        done 

        #Renaming chains 
        sed -i "s/ A / R /g" $outdir/recycles_merging/tmp_$pdbfilename
        sed -i "s/ B / P /g" $outdir/recycles_merging/tmp_$pdbfilename
        
        # Align trajectory
        cat > cpptraj.in <<EOF
        parm $outdir/recycles_merging/tmp_$pdbfilename
        trajin $outdir/recycles_merging/tmp_$pdbfilename parm $outdir/recycles_merging/tmp_$pdbfilename
        rmsd @CA first out tmp.dat
        trajout $outdir/recycles_merging/$pdbfilename pdb
        go
        quit
EOF
        cpptraj cpptraj.in 1>/dev/null
        rm $outdir/recycles_merging/tmp_$pdbfilename
        rm tmp.dat 
        rm cpptraj.in

        #superimpose real PDB
        IFS=, read -r chain1 chain2 <<< $chains
        grep "ATOM" $p_data/receptors/03_pdb_peptides/$receptor/$pdbcode.pdb | grep " $chain1 " > tmp.pdb
        TMalign tmp.pdb $outdir/recycles_merging/$pdbfilename -m tmp_matrix.txt > $outdir/recycles_merging/tmalign_rank_${rank}.log
        rm tmp.pdb
        
        python3 transform_pdb.py -i $p_data/receptors/03_pdb_peptides/$receptor/$pdbcode.pdb -c $chains -o $outdir/recycles_merging/${pdbcode}_rank_${rank}.pdb -m tmp_matrix.txt -r 20
        #Old usage: python3 transform_pdb.py $p_data/receptors/03_pdb_peptides/$receptor/$pdbcode.pdb $chains $outdir/recycles_merging/${pdbcode}_rank_${rank}.pdb tmp_matrix.txt 20
        rm tmp_matrix.txt

        # Write visualizer
        sed -e "s/REFPDBFILENAME/predictions\/$jobname\/recycles_merging\/${pdbcode}_rank_${rank}.pdb/g;s/PDBFILENAME/predictions\/$jobname\/recycles_merging\/$pdbfilename/g;s/CH1/$chain1/g;s/CH2/$chain2/g;" script_templates/template_backbones.vmd > $outdir/recycles_merging/view_rank_${rank}.vmd

        echo "vmd -e $outdir/recycles_merging/view_rank_${rank}.vmd"

    done

done
