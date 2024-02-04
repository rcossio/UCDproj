import sys

def compare(str1,str2):
    if len(str1) != len(str2):
        return '***comparison error***'
    result = ''
    for j in range(len(str1)):
        if str1[j] == str2[j]:
            result += '|'
        else:
            result += ' '
    return result

def alignment_overestimation(str1,str2):
    if len(str1) != len(str2):
        return '***comparison error***'
    for j in range(len(str1)):
        if str1[j] == str2[j]:
            if str1[j] == 'W':
                return True
            if str1[j] == 'C':
                return True
    return False



def check_phosphorilation(seq_name,start,end):
    alpha_s1_bos_taurus = {
        'title' : '>sp|P02662|CASA1_BOVIN Alpha-S1-casein OS=Bos taurus OX=9913 GN=CSN1S1 PE=1 SV=2',
        'seq' : 'MKLLILTCLVAVALARPKHPIKHQGLPQEVLNENLLRFFVAPFPEVFGKEKVNELSKDIGSESTEDQAMEDIKQMEAESISSSEEIVPNSVEQKHIQKEDVPSERYLGYLEQLLRLKKYKVPQLEIVPNSAEERLHSMKEGIHAQQKEPMIGVNQELAYFYPELFRQFYQLDAYPSGAWYYVPLGTQYTDAPSFSDIPNPIGSENSEKTTMPLW',    
        'S' : [ 56, 61, 63, 79, 81, 82, 83, 90, 130 ], 
        'T' : [ 64 ]
        }
    alpha_s2_bos_taurus = {
        'title': '>sp|P02663|CASA2_BOVIN Alpha-S2-casein OS=Bos taurus OX=9913 GN=CSN1S2 PE=1 SV=2',
        'seq': 'MKFFIFTCLLAVALAKNTMEHVSSSEESIISQETYKQEKNMAINPSKENLCSTFCKEVVRNANEEEYSIGSSSEESAEVATEEVKITVDDKHYQKALNEINQFYQKFPQYLQYLYQGPIVLNPWDQVKRNAVPITPTLNREQLSTSEENSKKTVDMESTEVFTKKTKLTEEEKNRLNFLKKISQRYQKFALPQYLKTVYQHQKAMKPWIQPKTKVIPYVRYL',
        'S' : [ 23, 24, 25, 28, 31, 46, 71, 72, 73, 76, 144, 146, 150, 158 ],
        'T' : [ 81, 145, 153, 159, 163, 169 ]
        }

    beta_bos_taurus = {
        'title': '>sp|P02666|CASB_BOVIN Beta-casein OS=Bos taurus OX=9913 GN=CSN2 PE=1 SV=2',
        'seq': 'MKVLILACLVALALARELEELNVPGEIVESLSSSEESITRINKKIEKFQSEEQQQTEDELQDKIHPFAQTQSLVYPFPGPIPNSLPQNIPPLTQTPVVVPPFLQPEVMGVSKVKEAMAPKHKEMPFPKYPVEPFTESQSLTLTDVENLHLPLPLLQSWMHQPHQPLPPTVMFPPQSVLSLSQSKVLPVPQKAVPYPQRDMPIQAFLLYQEPVLGPVRGPFPIIV',
        'S': [ 30, 32, 33, 34, 37, 50, 72, 139, 157 ],
        'T': [ 56 ]
        }

    kappa_bos_taurus = {
        'title': '>sp|P02668|CASK_BOVIN Kappa-casein OS=Bos taurus OX=9913 GN=CSN3 PE=1 SV=1',
        'seq': 'MMKSFFLVVTILALTLPFLGAQEQNQEQPIRCEKDERFFSDKIAKYIPIQYVLSRYPSYGLNYYQQKPVALINNQFLPYPYYAKPAAVRSPAQILQWQVLSNTVPAKSCQAQPTTMARHPHPHLSFMAIPPKKNQDKTEIPTINTIASGEPTSTPTTEAVESTVATLEDSPEVIESPPEINTVQVTSTAV',
        'S': [ ],
        'T': [ ]
        }

    alpha_s1_homo_sapiens = {
        'title': '>sp|P47710|CASA1_HUMAN Alpha-S1-casein OS=Homo sapiens OX=9606 GN=CSN1S1 PE=1 SV=1',
        'seq': 'MRLLILTCLVAVALARPKLPLRYPERLQNPSESSEPIPLESREEYMNGMNRQRNILREKQTDEIKDTRNESTQNCVVAEPEKMESSISSSSEEMSLSKCAEQFCRLNEYNQLQLQAAHAQEQIRRMNENSHVQVPFQQLNQLAAYPYAVWYYPQIMQYVPFPPFSDISNPTAHENYEKNNVMLQW',
        'S': [ 31, 33, 41, 71, 85, 86, 88, 89, 90, 91 ],
        'T': []
        }

    beta_homo_sapiens = {
        'title': '>sp|P05814|CASB_HUMAN Beta-casein OS=Homo sapiens OX=9606 GN=CSN2 PE=1 SV=4',
        'seq': 'MKVLILACLVALALARETIESLSSSEESITEYKQKVEKVKHEDQQQGEDEHQDKIYPSFQPQPLIYPFVEPIPYGFLPQNILPLAQPAVVLPVPQPEIMEVPKAKDTVYTKGRVMPVLKSPTIPFFDPQIPKLTDLENLHLPLPLLQPLMQQVPQPIPQTLALPPQPLWSVPQPKVLPIPQQVVPYPQRAVPVQALLLNQELLLNPTHQIYPVTQPLAPVHNPISV',
        'S': [ 21, 23, 24, 25, 120 ],
        'T': [ 18 ]
        }

    kappa_homo_sapiens = {
        'title': '>sp|P07498|CASK_HUMAN Kappa-casein OS=Homo sapiens OX=9606 GN=CSN3 PE=1 SV=3',
        'seq': 'MKSFLLVVNALALTLPFLAVEVQNQKQPACHENDERPFYQKTAPYVPMYYVPNSYPYYGTNLYQRRPAIAINNPYVPRTYYANPAVVRPHAQIPQRQYLPNSHPPTVVRRPNLHPSFIAIPPKKIQDKIIIPTINTIATVEPTPAPATEPTVDSVVTPEAFSESIITSTPETTTVAVTPPTA',
        'S': [ ],
        'T': [ ]
        }

    if seq_name == 'sp|P02662|CASA1_BOVIN':
        index_list = alpha_s1_bos_taurus['S'] + alpha_s1_bos_taurus['T']
    elif seq_name == 'sp|P02663|CASA2_BOVIN':
        index_list = alpha_s2_bos_taurus['S'] + alpha_s2_bos_taurus['T']
    elif seq_name == 'sp|P05814|CASB_BOVIN':
        index_list = beta_bos_taurus['S'] + beta_bos_taurus['T']
    elif seq_name == 'sp|P02668|CASK_BOVIN':
        index_list = kappa_bos_taurus['S'] + kappa_bos_taurus['T']
    elif seq_name == 'sp|P47710|CASA1_HUMAN':
        index_list = alpha_s1_homo_sapiens['S'] + alpha_s1_homo_sapiens['T']
    elif seq_name == 'sp|P05814|CASB_HUMAN':
        index_list = beta_homo_sapiens['S'] + beta_homo_sapiens['T']
    elif seq_name == 'sp|P07498|CASK_HUMAN':
        index_list = kappa_homo_sapiens['S'] + kappa_homo_sapiens['T']
    else:
        return '***error***'

    for index in index_list:
        if ((start <= index) and (index <= end)):
            return True

    return False

filename_in = sys.argv[1]

result_list = [ line.split() for line in open(filename_in)]

accepted_seqs = []
accepted_seqs_list = []
evalue_list = []
for result in result_list:
    coverage = int(result[11])
    if coverage < 30:
        continue
    seq_id = result[1]+'-'+result[16]
    if seq_id in accepted_seqs:
        continue
    evalue = float(result[10])
    accepted_seqs.append(seq_id)
    accepted_seqs_list.append(result)
    evalue_list.append(evalue)

len_seqs = len(accepted_seqs)
if len_seqs == 0:
    print ('\n*** No hits found***\n')
else:
    for dummy_counter in range(len_seqs):
        min_value = min(evalue_list)
        i = evalue_list.index(min_value)
        print('\t'.join(accepted_seqs_list[i][0:12]))
        print('\t'+'\t'.join(accepted_seqs_list[i][12:15]))
        seq_a = accepted_seqs_list[i][13]
        seq_b = accepted_seqs_list[i][16]
        print('\t\t'+compare(seq_a,seq_b) )
        print('\t'+'\t'.join(accepted_seqs_list[i][15:]))
        if alignment_overestimation(seq_a,seq_b):
            print('\t*alignment overestimation (W or C)*')
        seq_name = accepted_seqs_list[i][1]
        start = int(accepted_seqs_list[i][15])
        end = int(accepted_seqs_list[i][17])
        if check_phosphorilation(seq_name,start,end):
            print('\t*possible phosphorilation*')
        print('')
        evalue_list[i] = 1000.0