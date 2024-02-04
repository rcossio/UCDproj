#Modifies casein residues
python3 phosphomimic.py

#Erase database
rm phosphomimic.fasta.xp*

#Creates database
xdformat -p phosphomimic.fasta

