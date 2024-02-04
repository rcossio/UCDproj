#import time
import os
import sys

table_limits_agonist =  [ '<table id="agonists"', '</table>' ]
table_limits_antagonist =   [ '<table id="antagonists"', '</table>' ]
tbody_limits =  [ '<tbody', '</tbody>' ]
tr_limits = [ '<tr class="info"', '</tr>' ]
td_limits_first_col =   [ '<td style="border-style: solid dotted none solid;" rowspan="1">', '</td>' ]
link_limits =   [ '<a  href="', '">' ]
sequence_limits =   [ 'Peptide Sequence', '</table>' ]
notes_limits =  [ 'Modification', '</table>' ]
td_limits =  [ '<td style="text-align:left;" >', '</td>' ]

link_basestring= 'https://www.guidetopharmacology.org/GRAC/LigandDisplayForward?tab=structure&ligandId='
name_limit = '">'
radioactive_marker = '<img src="images/rad.gif" alt="Ligand is radioactive"/>'
human_marker = '<a style="color:black;" title="Human">Hs</a>'
peptide_marker = '<img src="images/peptide_cartoon.png" alt="Peptide"/>'

ligands_without_sequence = [ '9193', '1101', '9044', '8865', '9760' ]
ligands_with_lact_bridge = ['925', '10335','2103','2276']
ligands_heavily_modified = ['1696','2244','2218']
known_ligand_exceptions = ligands_without_sequence + ligands_with_lact_bridge + ligands_heavily_modified


class CustomString(str):
    '''Creating a class to add a method to strings'''
    def flanked_by(self,flanking_strings):
        return CustomString(self.split(flanking_strings[0])[1].split(flanking_strings[1])[0])
    
    def nested_flanks(self,first_flank_pair,second_flank_pair):
        return self.flanked_by(first_flank_pair).flanked_by(second_flank_pair)

def ReadFile(filename,read_option):
    return CustomString(open(filename,read_option).read())

receptor_pages_folder = 'receptor_pages/'
filename = sys.argv[1]+'.html'

html_string = ReadFile(receptor_pages_folder+'/'+filename,'r')

agonist_tbody_string = html_string.nested_flanks(table_limits_agonist,tbody_limits)
agonist_table_rows = [ CustomString(row.split(tr_limits[1])[0]) for row in agonist_tbody_string.split(tr_limits[0]) ][1:]

try:
    antagonist_tbody_string = html_string.nested_flanks(table_limits_antagonist,tbody_limits)
    antagonist_table_rows = [ CustomString(row.split(tr_limits[1])[0]) for row in antagonist_tbody_string.split(tr_limits[0]) ][1:]
except IndexError:
    print('***IndexError at line 42-43***')
    antagonist_table_rows = []

print(f'Initial agonist quantity:{len(agonist_table_rows)}')
print(f'Initial antagonist quantity:{len(antagonist_table_rows)}')

table_rows = agonist_table_rows + antagonist_table_rows
print(f'Total initial quantity: {len(table_rows)}')

fileout = open('peptide_sequences/'+filename.replace('html','fasta'),'w')
added_ligands = []
for row in table_rows:
    if radioactive_marker in row:
        continue
    if not human_marker in row:
        continue
    if peptide_marker in row:
            cleaned_row = row.flanked_by(td_limits_first_col)
            name = ''.join(cleaned_row.split(name_limit)[1].replace('</a>',' ').split())
            ligand_id = cleaned_row.flanked_by(link_limits).split('ligandId=')[1]
            link = link_basestring + ligand_id
            print(name,ligand_id)
            os.system(f'[ -f ligands/tmp.{ligand_id}.html ] || wget -O ligands/tmp.{ligand_id}.html "{link}" ')
            ligand_string = ReadFile(f'ligands/tmp.{ligand_id}.html','r')
            if ligand_id in known_ligand_exceptions:
                print('Skipping ligand with known issues...')
                continue
            sequence = ligand_string.nested_flanks(sequence_limits,td_limits).strip()
            try:
                notes = ligand_string.nested_flanks(notes_limits,td_limits).strip()
            except IndexError:
                notes = ''
            if not ligand_id in added_ligands:
                fileout.write(f'>{name} | {notes} \n')
                fileout.write(sequence+'\n')
                added_ligands.append(ligand_id)
                #time.sleep(1)
fileout.close()
