USERNAME=$(cat $p_private/sonic_username)
SERVERIP=$(cat $p_private/sonic_ip)
DIRNAME=/home/people/$USERNAME/AlphaFoldJobs
COLABJOBS=$p_analysis/03_analog_peptides/01_blastp_results/02_endogenous/colab_fold_jobs_set2.txt

#This is to retrieve information from the cluster
for index in {10..10}
do
    JOBNAME=$(head -n $index $COLABJOBS | tail -1 | awk '{print $1}')
    [ ! -d predictions/$JOBNAME ] && scp -r $USERNAME@$SERVERIP:$DIRNAME/$JOBNAME predictions/$JOBNAME/

done
