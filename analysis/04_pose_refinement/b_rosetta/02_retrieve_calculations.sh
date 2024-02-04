USERNAME=$(cat $p_private/chpc_username)
SERVERIP=$(cat $p_private/chpc_ip)
DIRNAME=/home/$USERNAME/lustre/runsRosetta/
ROSETTAJOBS=$p_analysis/03_analog_peptides/02_structure_predictions/01_pdb_peptides/rosetta_jobs.dat

for index in {1..41}
do
    COLABFOLDJOBNAME=$(head -n $index $ROSETTAJOBS | tail -1 | awk '{print $1}')
    RANK=$(head -n $index $ROSETTAJOBS | tail -1 | awk '{print $2}')
    ROSETTAJOBNAME=${COLABFOLDJOBNAME}_r${RANK}
    scp -r $USERNAME@$SERVERIP:$DIRNAME/$ROSETTAJOBNAME results/.

    if [ -f results/$ROSETTAJOBNAME/docked/prepacked_0100.pdb ]
    then
        #Fix wrong naming
        cd results/$ROSETTAJOBNAME/docked
        for i in {0001..0100}
        do
            mv prepacked_$i.pdb lowres_$i.pdb
        done
        cd ../../..
    else
        echo "Error in $index $ROSETTAJOBNAME"
        exit
    fi

done


