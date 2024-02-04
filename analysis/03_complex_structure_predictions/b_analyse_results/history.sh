#Get the output (pasted into a file of 05_model_merging) and convert it to a list of visualizations commands
grep -E "vmd|#" visualize_all.txt | sed "s/#/echo /" > view_all_vmd.sh

#Get all metric into one file, naming them
for file in $(ls -d predictions/*); do sed "s/^/$(basename $file) /" $file/models_merging/metrics.dat ; done > all_metrics.dat
#Other option, adding also receptor
for file in $(ls -d predictions/*); do pdbcode=$(echo $(basename $file) | awk '{print substr($0,0,4)}'); sed "s/^/$(bash map_pdb_to_receptor.sh $pdbcode) $(basename $file) /" $file/models_merging/metrics.dat ; done > all_metrics.dat
sort all_metrics.dat > tmp_metrics.dat
mv tmp_metrics.dat all_metrics.dat

#Watch RMSD
cat predictions/*/ligand_rmsd/all.dat | awk '$3 <= 4.5' | sort -nk3 > rosetta_jobs.dat

#watch RMSD differentiated by family
cat predictions/*/ligand_rmsd/all.dat | sort -nrk3 > all_ligand_rmsd.dat
rm tuned_all_ligand_rmsd.dat
while read line
do 
    receptor=$(bash map_pdb_to_receptor.sh $(echo $line | awk '{print substr($1,0,4)}'))
    family=$(bash map_receptor_to_family.sh $receptor)
    echo $family $receptor $line >> tuned_all_ligand_rmsd.dat
done < all_ligand_rmsd.dat
sed -i "s/CRFR /1 /" tuned_all_ligand_rmsd.dat 
sed -i "s/OPR /2 /" tuned_all_ligand_rmsd.dat 
sed -i "s/NPYR /3 /" tuned_all_ligand_rmsd.dat 
sed -i "s/NKR /4 /" tuned_all_ligand_rmsd.dat 
sed -i "s/VIPR /5 /" tuned_all_ligand_rmsd.dat 
sed -i "s/OTR /6 /" tuned_all_ligand_rmsd.dat 
sed -i "s/GCGR /7 /" tuned_all_ligand_rmsd.dat 
sed -i "s/GHSR /8 /" tuned_all_ligand_rmsd.dat 
sed -i "s/MR /9 /" tuned_all_ligand_rmsd.dat 
sort -nrk5 tuned_all_ligand_rmsd.dat > tmp_tuned_all_ligand_rmsd.dat
mv tmp_tuned_all_ligand_rmsd.dat tuned_all_ligand_rmsd.dat
