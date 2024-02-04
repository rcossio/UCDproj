#!/bin/bash -l
#SBATCH --job-name=JOBNAME
#SBATCH --output=%x.out
#SBATCH --error=%x.err

# speficity number of nodes 
#SBATCH -N 1

# specify the gpu queue
#SBATCH --partition=gpu

# Request 2 gpus
#SBATCH --gres=gpu:1

# specify number of tasks/cores per node required
#SBATCH --ntasks-per-node=8

# specify the walltime e.g 3 hour
#SBATCH -t 03:00:00

# run from current directory
cd $SLURM_SUBMIT_DIR

module load cuda/11.2
python run_colabfold_v1.5.1.py JOBNAME SEQUENCE


# running inside the job directory, after colabfold
cd JOBNAME/

rm -r JOBNAME_env
rm -r JOBNAME_
rm cite.bibtex
rm JOBNAME.csv
rm JOBNAME.done.txt

mkdir images/
mv *.png images/.
for file in $(ls images/JOBNAME*)
do 
    mv $file $(echo $file| sed 's/JOBNAME_//;s/alphafold2_multimer_v3_//' )
done

mkdir json/
mv *.json json/.
for file in $(ls json/JOBNAME*)
do 
    mv $file $(echo $file| sed 's/JOBNAME_//' )
done

mkdir unrelaxed/
mv JOBNAME_unrelaxed*pdb unrelaxed/.
for file in $(ls unrelaxed/JOBNAME*)
do 
    mv $file $(echo $file| sed 's/JOBNAME_unrelaxed_//;s/alphafold2_multimer_v3_//' )
done

mkdir relaxed/
mv JOBNAME_relaxed*pdb relaxed/.
for file in $(ls relaxed/JOBNAME*)
do 
    mv $file $(echo $file| sed 's/JOBNAME_relaxed_//;s/alphafold2_multimer_v3_//' )
done

mv JOBNAME.a3m msa.a3m

mv ../JOBNAME.out stdout.log
mv ../JOBNAME.err stderr.log
