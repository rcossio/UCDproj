rm tmp.dat

cd results
for folder in $(ls -d *)
do
    echo $folder
    cd $folder/docked
    for i in {0001..0100}
    do
        score=$(grep reweighted_sc lowres_$i.pdb | head -1 | awk '{print $2}')
        rmsd=$(grep rmsCA lowres_$i.pdb | head -1 | awk '{print $2}')
        echo "$rmsd $score $folder $i" >> ../../../tmp.dat
    done
    cd ../..
done