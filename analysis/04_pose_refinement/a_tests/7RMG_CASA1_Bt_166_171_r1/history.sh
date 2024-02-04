# Merge models
cd top
rm all.pdb
for i in {1..10}
do 
    echo "MODEL" >> all.pdb
    grep -E "ATOM|TER" top_$i.pdb >> all.pdb
    echo "ENDMDL">> all.pdb
done
cd ..