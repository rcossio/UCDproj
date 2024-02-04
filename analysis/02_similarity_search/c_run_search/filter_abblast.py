import sys
import os


def score(res1, res2, matrix_filename):
    content = []
    with open(matrix_filename) as file:
        for line in file:
            if line.startswith("#"):
                continue   # Ignore comment lines

            if line.strip().split() == '':
                continue

            content.append(line.strip().split())

    matrixDict = {}
    residues = content[0]
    for row in content[1:]:
        row_residue = row[0]
        values = row[1:]
        for (i, value) in enumerate(values):
            column_residue = residues[i]
            matrixDict[row_residue+'-'+column_residue] = int(value)

    return matrixDict[res1+'-'+res2]


def compare(str1, str2, matrix):
    # this will fail when there are gaps, it is an accepted bug
    if len(str1) != len(str2):
        return '***comparison error (possibly due to gaps)***'
    result = ''
    for j in range(len(str1)):
        if str1[j] == str2[j]:
            result += '|'
        elif score(str1[j], str2[j], matrix) > 0.0:
            result += '+'
        else:
            result += ' '
    return result


def sequence_mimic(sprint, qprint, matrix):
    # this will fail when there are gaps, it is an accepted bug
    if len(sprint) != len(qprint):
        return '***comparison error (possibly due to gaps)***'
    result = ''
    for j in range(len(sprint)):
        if sprint[j] == 'Z':
            if score('S', qprint[j], matrix) >= score('D', qprint[j], matrix):
                result += 'S'
            else:
                result += 'D'
        elif sprint[j] == 'B':
            if score('T', qprint[j], matrix) >= score('E', qprint[j], matrix):
                result += 'T'
            else:
                result += 'E'
        else:
            result += sprint[j]
    return result


def alignment_overestimation(str1, str2):
    if len(str1) != len(str2):
        return '***comparison error***'
    for j in range(len(str1)):
        if str1[j] == str2[j]:
            if str1[j] == 'W':
                return True
            if str1[j] == 'C':
                return True
    return False


def get_seq_from_fasta(name, filename):
    # Warning: fasta should not have empty lines
    line_found = False
    lastline = open(filename).readlines()[-1].strip()
    seq = ''
    for line in open(filename):
        if line_found:
            if line.strip().startswith('>'):
                return seq
            else:
                seq += line.strip()
                if line == lastline:
                    return seq
        if line.strip('>').strip().startswith(name):
            line_found = True
    return '***error***'


def asterisk_on_phospho(mystr):
    return ''.join(['*' if x in ['Z', 'B'] else ' ' for x in list(str(mystr))])


filename_in = sys.argv[1]
matrix = sys.argv[4]
result_list = [line.split() for line in open(filename_in)]

accepted_seqs = []
accepted_seqs_list = []
evalue_list = []
for result in result_list:
    seq_id = result[1]+'-'+result[20]+'-'+result[21]
    evalue = float(result[2])

    # If sequence is repeated keep the one with lowest evalue
    if seq_id in accepted_seqs:
        seq_index = accepted_seqs.index(seq_id)
        prev_evalue = float(accepted_seqs_list[seq_index][2])
        # keep previous
        if prev_evalue <= evalue:
            pass
        # keep new
        else:
            accepted_seqs_list[seq_index] = result
            evalue_list[seq_index] = evalue
        continue

    accepted_seqs.append(seq_id)
    accepted_seqs_list.append(result)
    evalue_list.append(evalue)


len_seqs = len(accepted_seqs)
if len_seqs == 0:
    print('\n*** No hits found***\n')
else:
    for dummy_counter in range(len_seqs):
        accept_alignment = True
        min_value = min(evalue_list)
        i = evalue_list.index(min_value)

        query_name = accepted_seqs_list[i][0]
        query_filename = sys.argv[2]
        query_seq = get_seq_from_fasta(query_name, query_filename)
        qlen = len(query_seq)

        sbjct_name = accepted_seqs_list[i][1]
        sbjct_filename = sys.argv[3]
        sbjct_seq = get_seq_from_fasta(sbjct_name, sbjct_filename)

        alignment_length = int(accepted_seqs_list[i][6])
        coverage = 100*float(alignment_length)/float(len(query_seq))
        positive_count = accepted_seqs_list[i][8]
        positive_coverage = 100*float(positive_count)/float(len(query_seq))
        percentage_positives = float(accepted_seqs_list[i][11])
        percentage_identities = float(accepted_seqs_list[i][10])

        qstart = int(accepted_seqs_list[i][17])-1
        qend = int(accepted_seqs_list[i][18])
        qprint = query_seq[qstart:qend]

        sstart = int(accepted_seqs_list[i][20])-1
        send = int(accepted_seqs_list[i][21])
        sseq = sbjct_seq[sstart:send]
        sprint = sequence_mimic(sseq, qprint, matrix)

        evalue = float(accepted_seqs_list[i][2])
        bitscore = float(accepted_seqs_list[i][4])
        average_bitscore = bitscore/alignment_length

        def rename_casein(mystr):
            if mystr == 'CASA1_HUMA':
                return 'CASA1_Hs'
            elif mystr == 'CASB_HUMAN':
                return 'CASB_Hs'
            elif mystr == 'CASK_HUMAN':
                return 'CASK_Hs'
            elif mystr == 'CASA1_BOVI':
                return 'CASA1_Bt'
            elif mystr == 'CASA2_BOVI':
                return 'CASA2_Bt'
            elif mystr == 'CASB_BOVIN':
                return 'CASB_Bt'
            elif mystr == 'CASK_BOVIN':
                return 'CASK_Bt'
            else:
                return '***error***'

        colabfold_name = f'{query_name[0:4]}_{ rename_casein( sbjct_name.split("|")[-1] ) }_{sstart+1}_{send}'
        receptor_name = sys.argv[5]
        receptor_filename = f'{os.environ["p_data"]}/receptors/02_sequence/{receptor_name}.fasta'

        # 'sp' is a wildcard to hack get_seq_from_fasta() to get the first and only sequence from the fasta
        # Should I be hacking a function that I wrote myself? Probably not
        receptor_sequence = get_seq_from_fasta('sp', receptor_filename)

        if alignment_length < 3:
            accept_alignment = False

        filter_evalue = float(sys.argv[6])
        if evalue > filter_evalue:
            accept_alignment = False

        if accept_alignment:
            pre_string = ''
        else:
            pre_string = '#'

        print(pre_string+'\t'.join(accepted_seqs_list[i])+'\t%2i\t%2i'%(coverage,qlen))
        print(pre_string+f'|\t{qstart+1}\t{qprint}\t{qend}')
        print(pre_string+'|\t\t'+compare(qprint, sprint, matrix))
        print(pre_string+f'|\t{sstart+1}\t{sprint}\t{send}')
        print(pre_string+f'|\t{asterisk_on_phospho(sstart+1)}\t{asterisk_on_phospho(sseq)}\t{asterisk_on_phospho(send)}')
        print(pre_string+'|')
        print(pre_string+f'iii\t {colabfold_name}\t{receptor_name}\t{receptor_sequence}:{sprint}')

        # if alignment_overestimation(seq_a,seq_b):
        #    print('\t*alignment overestimation (W or C)*')

        evalue_list[i] = 1000.0
