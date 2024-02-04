USERNAME=$(cat $p_private/sonic_username)
SERVERIP=$(cat $p_private/sonic_ip)
DIRNAME=/home/people/$USERNAME/AlphaFoldJobs
COLABJOBS=$p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/colab_fold_jobs_set2.txt

for index in {10..10}
do
    JOBNAME=$(head -n $index $COLABJOBS | tail -1 | awk '{print $1}')
    RECEPTOR=$(head -n $index $COLABJOBS | tail -1 | awk '{print $2}')
    SEQUENCE=$(head -n $index $COLABJOBS | tail -1 | awk '{print $3}')

    sed -e "s/JOBNAME/$JOBNAME/g;s/SEQUENCE/$SEQUENCE/g" script_templates/run_sbatch_template.sh > run_${JOBNAME}.sh
    scp run_${JOBNAME}.sh $USERNAME@$SERVERIP:$DIRNAME/.
    #scp run_colabfold_v1.5.1.py $USERNAME@$SERVERIP:$DIRNAME/.
    echo "sbatch run_${JOBNAME}.sh"
    rm run_${JOBNAME}.sh

done


