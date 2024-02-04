#para analizar los pdbs resultantes
for i in {01..24};do echo -n "$i "; grep "reweighted_sc" rank_001_model_2_seed_000_0001_00$i.pdb| awk '{printf $2" "}'; grep "silent_score" rank_001_model_2_seed_000_0001_00$i.pdb| awk '{print $2}';done > values.dat

#para mergear los pdbs obtenidos
rm all.pdb; for i in {01..24}; do echo MODEL >> all.pdb; grep -E "ATOM|TER" rank_001_model_2_seed_000_0001_00$i.pdb >> all.pdb; echo ENDMDL >> all.pdb;done