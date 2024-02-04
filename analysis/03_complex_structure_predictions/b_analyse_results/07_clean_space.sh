
colabjobs=$p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/colab_fold_jobs_set3.txt

for index in {1..36}
do

    jobname=$(head -n $index $colabjobs | tail -1 | awk '{print $1}')
    receptor=$(head -n $index $colabjobs | tail -1 | awk '{print $2}')
    
    echo "$jobname $receptor"

    outdir=predictions/$jobname
    [ -d $outdir/recycles_merging ] && rm -r  $outdir/recycles_merging
    [ -d $outdir/recycles_tol ] && rm -r $outdir/recycles_tol
    #[ -d $outdir/models_merging ] && rm -r $outdir/models_merging

    #erase old unused folders
    [ -d $outdir/aligned ] && rm -r $outdir/aligned
    [ -d $outdir/recycles ] && rm -r $outdir/recycles
    [ -d $outdir/merged_recycles ] && rm -r $outdir/merged_recycles
    [ -d $outdir/vmd ] && rm -r $outdir/vmd
    [ -d $outdir/tmalign ] && rm -r $outdir/tmalign
    [ -d $outdir/merged_models ] && rm -r $outdir/merged_models



done
