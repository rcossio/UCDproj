import json
import sys

# Load the JSON data from file
with open(sys.argv[1]) as f:
    data = json.load(f)

# Search for the entry with the UniProtKB database
for entry in data:
    if entry['database'] == 'UniProtKB':
        # Retrieve the accession and print it
        print(entry['accession'])
        break  # Stop searching after the first match
