# Simply modifies all matrices to allow for phosphorilation
mkdir modified_matrices/
python3 modify_matrices.py $p_data/scoring_matrices/BLOSUM45 modified_matrices/BLOSUM45_custom
python3 modify_matrices.py $p_data/scoring_matrices/BLOSUM50 modified_matrices/BLOSUM50_custom
python3 modify_matrices.py $p_data/scoring_matrices/BLOSUM62 modified_matrices/BLOSUM62_custom
python3 modify_matrices.py $p_data/scoring_matrices/BLOSUM80 modified_matrices/BLOSUM80_custom
python3 modify_matrices.py $p_data/scoring_matrices/BLOSUM90 modified_matrices/BLOSUM90_custom
python3 modify_matrices.py $p_data/scoring_matrices/EDSSMat50 modified_matrices/EDSSMat50_custom
python3 modify_matrices.py $p_data/scoring_matrices/EDSSMat60 modified_matrices/EDSSMat60_custom
python3 modify_matrices.py $p_data/scoring_matrices/EDSSMat62 modified_matrices/EDSSMat62_custom
python3 modify_matrices.py $p_data/scoring_matrices/EDSSMat70 modified_matrices/EDSSMat70_custom
python3 modify_matrices.py $p_data/scoring_matrices/EDSSMat75 modified_matrices/EDSSMat75_custom
python3 modify_matrices.py $p_data/scoring_matrices/EDSSMat80 modified_matrices/EDSSMat80_custom
python3 modify_matrices.py $p_data/scoring_matrices/EDSSMat90 modified_matrices/EDSSMat90_custom
python3 modify_matrices.py $p_data/scoring_matrices/PAM30 modified_matrices/PAM30_custom
python3 modify_matrices.py $p_data/scoring_matrices/PAM70 modified_matrices/PAM70_custom
python3 modify_matrices.py $p_data/scoring_matrices/PAM250 modified_matrices/PAM250_custom
python3 modify_matrices.py $p_data/scoring_matrices/DUNMat modified_matrices/DUNMat_custom
python3 modify_matrices.py $p_data/scoring_matrices/Disorder40 modified_matrices/Disorder40_custom
python3 modify_matrices.py $p_data/scoring_matrices/Disorder85 modified_matrices/Disorder85_custom