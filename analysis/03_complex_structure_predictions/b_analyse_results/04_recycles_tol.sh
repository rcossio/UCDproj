# This script gets the tol from the recycles and makes a gnuplot script to plot them
colabjobs=$p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/colab_fold_jobs_set1.txt

for index in {1..1}
do

    jobname=$(head -n $index $colabjobs | tail -1 | awk '{print $1}')
    receptor=$(head -n $index $colabjobs | tail -1 | awk '{print $2}')
    
    echo "#$jobname $receptor"

    outdir=predictions/$jobname

    [ ! -d $outdir/recycles_tol ] && mkdir $outdir/recycles_tol

    [ -f $outdir/recycles_tol/recycles_tol.gnu ] && rm $outdir/recycles_tol/recycles_tol.gnu 
    echo "set grid" >> $outdir/recycles_tol/recycles_tol.gnu
    echo "set yrange [0:10]" >> $outdir/recycles_tol/recycles_tol.gnu


    for model in {1..5}
    do
        grep "model_${model}" $outdir/log.txt | grep "recycle=" | grep -v "recycle=0"| awk '{print $8}' | sed 's/tol=//g' | cat -n > $outdir/recycles_tol/model_${model}.dat
        echo "p \"$outdir/recycles_tol/model_${model}.dat\" w lp" >> $outdir/recycles_tol/recycles_tol.gnu
        echo "pause -1" >> $outdir/recycles_tol/recycles_tol.gnu
    done

    echo "gnuplot $outdir/recycles_tol/recycles_tol.gnu"    

done
