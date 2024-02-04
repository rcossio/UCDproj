USERNAME=$(cat $p_private/chpc_username)
SERVERIP=$(cat $p_private/chpc_ip)
DIRNAME=/home/$USERNAME/lustre/runsRosetta/
ROSETTAJOBS=$p_analysis/03_analog_peptides/02_structure_predictions/01_pdb_peptides/rosetta_jobs.dat

#1..3 ya estan
for index in {5..41}
do
    COLABFOLDJOBNAME=$(head -n $index $ROSETTAJOBS | tail -1 | awk '{print $1}')
    RANK=$(head -n $index $ROSETTAJOBS | tail -1 | awk '{print $2}')
    ROSETTAJOBNAME=${COLABFOLDJOBNAME}_r${RANK}
    INPUTPDB="$p_analysis/03_analog_peptides/02_structure_predictions/01_pdb_peptides/predictions/$COLABFOLDJOBNAME/relaxed/rank_00${RANK}_model_*_seed_000.pdb"

    sed -e "s/JOBNAME/$ROSETTAJOBNAME/g" script_templates/run_qsub_template.sh > run_${ROSETTAJOBNAME}.sh
    scp -q run_${ROSETTAJOBNAME}.sh $USERNAME@$SERVERIP:$DIRNAME/
    scp -q $INPUTPDB $USERNAME@$SERVERIP:$DIRNAME/inputs/$ROSETTAJOBNAME.pdb
    echo "qsub run_${ROSETTAJOBNAME}.sh"
    rm run_${ROSETTAJOBNAME}.sh

done


