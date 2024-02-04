

# Download all peptidic interactions with GPCR present in IUPHAR database
URL="https://www.guidetopharmacology.org/services/interactions"
QUERY="ligandType=Peptide&targetType=GPCR"
curl -X GET "$URL?$QUERY" > 01_interactions/GPCR.json

# Obtain a list of ligands and targets
python3 00_utils/process_interactions.py GPCR

# Download targets UniprotKB accession number from IUPHAR, 
# It is called accepted targets because there are no unkown residues and no empty sequences
# and unique uniprot sequences, and sequence less than 650 residues
[ -f 01_interactions/accepted_targets.txt ] && rm 01_interactions/accepted_targets.txt
n=1
while read line; do
  read -r targetId species <<< "$line"
  echo "$n $targetId-$species"
  ((n++))

  URL="https://www.guidetopharmacology.org/services/targets/$targetId/databaseLinks"
  QUERY="species=$species"
  OUTPUT=02_targets_accessions/${targetId}_${species}.json
  curl -s -X GET "$URL?$QUERY" > $OUTPUT
  
  # Erase the ones without accession number and those with multiple accession numbers
  [ $(wc -l < "$OUTPUT") -eq 0 ] && rm "$OUTPUT" && continue
  [ $(grep '"database" : "UniProtKB",' $OUTPUT |wc -l) -ne 1 ] && rm "$OUTPUT" && continue

  # Download the fasta file
  accession=$(python3 00_utils/get_accession.py $OUTPUT)
  fasta=03_targets_fasta/$accession.fasta
  curl -s -X GET "https://rest.uniprot.org/uniprotkb/$accession.fasta" > $fasta
  
  # Make a list of accepted targets
  [ -f $fasta ] && [ $(python3 00_utils/accept_target.py $targetId $species $accession) -eq 1 ] && echo "$targetId $species" >> 01_interactions/accepted_targets.txt

done < 01_interactions/GPCR_targets.txt


# We download all peptidic interactions in IUPHAR database
URL="https://www.guidetopharmacology.org/services/interactions"
QUERY="ligandType=Peptide"
curl -X GET "$URL?$QUERY" > 01_interactions/all.json

# Obtain a list of ligands
python3 process_interactions.py all no-targets

# We download the list of ligands from IUPHAR
# It is called accepted targets because there are no unkown/wierd residues and no empty sequences
# and size from 5 to 49
[ -f 01_interactions/accepted_binders.txt ] && rm 01_interactions/accepted_binders.txt
[ -f 01_interactions/accepted_nonbinders.txt ] && rm 01_interactions/accepted_nonbinders.txt
while read ligandId; do
  URL="https://www.guidetopharmacology.org/services/ligands/$ligandId/structure"
  OUTPUT="04_ligands_iuphar/$ligandId.json"
  [ ! -f $OUTPUT ] && curl -X GET "$URL" > $OUTPUT

  # Filtering out the ones without sequence information
  [ $(wc -l < "$OUTPUT") -eq 0 ] && rm "$OUTPUT"

  # Make a list of accepted ligands
  # I should have simply nested and ifs...
  if [ -f $OUTPUT ] 
  then
    flag="$(python3 00_utils/accept_ligand.py $ligandId)"
    if [ "$flag" == "B" ]
    then
      echo "$ligandId" >> 01_interactions/accepted_binders.txt
    elif [ "$flag" == "NB" ]
    then
      echo "$ligandId" >> 01_interactions/accepted_nonbinders.txt
    fi
  fi

done < 01_interactions/all_ligands.txt


# Process all the data to obtain a list of ligands, targets and their sequences
python3 00_utils/organise_GPCR_data.py

# Analyse the data to get distributions of lenght and number of targets/peptides
python3 00_utils/analise_GPCR_dataset.py > info_GPCR_dataset.txt

# Process all the data to obtain a list of ligands and targets and their sequences
python3 00_utils/organise_nonGPCR_data.py  # Warning: this step includes random sampling. Re runnning it will cause the data to change



