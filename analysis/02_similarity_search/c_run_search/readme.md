* Updated 14 feb 2023

In this folder we used AB-Blast to find peptides alike the agonists of the receptors.

Set1:
We used Blosum80 modified for phosphomimics and filtered the results
by e-value of 2.15 and the length to a minimum according to the query:
4-6   -> 3
7-8   -> 4
9-10  -> 5
11-12 -> 6
13-14 -> 7
15-*  -> 8

Set2:
We used Blosum80 modified, and only filtered peptides with less than 3 residues. The idea is to merge sets 1 and 2.

Set 3:
We used EDSSMat90 modifies, and filteres peptides with less than 3 residues. This set is independent, 
but it is interesting to see which set (1/2 or 3) gives more positive results.

You will find:

- history.sh: useful commands that were runned
- run_abblast.sh: the script to write each program 
- filter_abblast.py: script to filter after getting the alignment results 
- 0x_alignments_setx/: folder with the ab-blast results, filtered and unfiltered. Set x.
- all/selected_results.dat: The file that contains evalues, coverages and other information relevant of the alignments
- colab_fold_jobs.txt: A list of the names and sequences required to go to the next step, colabfold

