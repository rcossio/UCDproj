#!/bin/bash
#PBS -P HEAL1524
#PBS -N JOBNAME
#PBS -l select=1:ncpus=24:mpiprocs=24
#PBS -l walltime=24:00:00
#PBS -q smp
#PBS -r n
#PBS -o JOBNAME.out
#PBS -e JOBNAME.err
#PBS

#Modules
module purge
module load chpc/openmpi/3.1.1/gcc-7.2.0

#General paths
ROSETTA=/home/rcossioprez/lustre/rosetta_bin_linux_2021.16.61629_bundle
FlexPepDocking=$ROSETTA/main/source/bin/FlexPepDocking.static.linuxgccrelease
extract_pdbs=$ROSETTA/main/source/bin/extract_pdbs.static.linuxgccrelease

ROSETTAMPI=/home/rcossioprez/lustre/rosetta_src_2021.16.61629_bundle
FlexPepDockingMPI=$ROSETTAMPI/main/source/bin/FlexPepDocking.mpi.linuxgccrelease
extract_pdbsMPI=$ROSETTAMPI/main/source/bin/extract_pdbs.mpi.linuxgccrelease

#Local paths
INPUTFOLDER=/home/rcossioprez/lustre/runsRosetta/inputs
cd /home/rcossioprez/lustre/runsRosetta/
mkdir JOBNAME
cd JOBNAME

#Prepack
echo "Stage 1: Prepack - $(date)" > timing.log
$FlexPepDocking -database $ROSETTA/main/database -s $INPUTFOLDER/JOBNAME.pdb -flexpep_prepack -ex1 -ex2aro
mv JOBNAME_0001.pdb prepacked.pdb

#Dock
echo "Stage 2: Dock LowRes- $(date)" >> timing.log
mpirun -np 24 $FlexPepDockingMPI -database $ROSETTAMPI/main/database   -in::file::s prepacked.pdb  -out:file:silent docked.silent -out:file:silent_struct_type binary -detect_disulf true -rebuild_disulf true  -lowres_preoptimize true -pep_refine -ex1 -ex2aro -use_input_sc -nstruct 100


#Extract
echo "Stage 3: Extract - $(date)" >> timing.log
mkdir docked
mpirun -np 24 $extract_pdbs -in:file:silent docked.silent -out:prefix ./docked/


echo "Stage 4: Done - $(date)" >> timing.log
mv ../JOBNAME.out stdout.log
mv ../JOBNAME.err stderr.log