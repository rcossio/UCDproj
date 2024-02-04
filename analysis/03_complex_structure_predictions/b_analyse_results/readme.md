* Updated feb 15 2023

Here you will find the Colabfold runs from the file 03_similarity_search/c_make_search/colab_fold_jobs.txt
You will find:

- 01_creat_colabfold_job.sh : reads the above mentioned file, creates the job and sends it to the sonic cluster. It sends run_colabfold.py
- 02_retrieve_calculations.sh: simply retreives calculations from sonic
- 03...05.sh: different way of processing results. each script creates its own erasable file. It uses transform_pdb.py, TMAlign and AmberTools
- 04_clean_space.sh: it erases fast-produced files (i.e., the ones created while procesing, not during the alphafold run)
- templates/: folder with scripts to be reused for each calculation
- predictions/: folder with the results, heavy folder (.gitignored)
- view_all_vmd.sh: simply to view all vmd states, possibly erase afterwards
- cite.bibtex: papers to cite

There is no history.sh file but the process is edit 01, 02, 03, while editing script to send calculations by chunks.
This is not a light folded to re-run, it requires computational time (including gpus), you should "take care" of the data.
Note 04 should NOT be run normally, it is just in case these calculations become obsolete and redundant data can be removed.
