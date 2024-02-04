# This script is to create variants of the caseins to mimic phosphorilation, 
# e.g., replaching phosphoserine by aspartate(D) and phosphothreonine by glutamate(E).

#This objects were handwritten. Sequence obtained from Uniprot and phosphorilation sites from ProViz (http://proviz.ucd.ie/)
alpha_s1_bos_taurus = {
    'title' : '>sp|P02662|CASA1_BOVI Alpha-S1-casein OS=Bos taurus OX=9913 GN=CSN1S1 PE=1 SV=2',
    'seq' : 'MKLLILTCLVAVALARPKHPIKHQGLPQEVLNENLLRFFVAPFPEVFGKEKVNELSKDIGSESTEDQAMEDIKQMEAESISSSEEIVPNSVEQKHIQKEDVPSERYLGYLEQLLRLKKYKVPQLEIVPNSAEERLHSMKEGIHAQQKEPMIGVNQELAYFYPELFRQFYQLDAYPSGAWYYVPLGTQYTDAPSFSDIPNPIGSENSEKTTMPLW',    
    'S' : [ 56, 61, 63, 79, 81, 82, 83, 90, 130 ], 
    'T' : [ 64 ]
    }
    
alpha_s2_bos_taurus = {
    'title': '>sp|P02663|CASA2_BOVI Alpha-S2-casein OS=Bos taurus OX=9913 GN=CSN1S2 PE=1 SV=2',
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
    'title': '>sp|P47710|CASA1_HUMA Alpha-S1-casein OS=Homo sapiens OX=9606 GN=CSN1S1 PE=1 SV=1',
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


def chunkify(chunk_length,string):
    chunks = [string[i:i+chunk_length] for i in range(0, len(string), chunk_length)]
    return chunks

def mutate_site(siteId,replacementCharacter,original_sequence):
    mutated_sequence = original_sequence[:siteId-1]+replacementCharacter+original_sequence[siteId:]
    return mutated_sequence


caseins = [alpha_s1_bos_taurus,alpha_s2_bos_taurus,beta_bos_taurus,kappa_bos_taurus,alpha_s1_homo_sapiens,beta_homo_sapiens,kappa_homo_sapiens]

fileout = open('phosphomimic.fasta','w')
for casein in caseins:
    casein['mutated_seq'] = casein['seq']

    for site in casein['S']:
        casein['mutated_seq'] = mutate_site(site,'Z',casein['mutated_seq'])

    for site in casein['T']:
        casein['mutated_seq'] = mutate_site(site,'B',casein['mutated_seq'])

    fileout.write(casein['title']+'\n')
    for chunk in chunkify(60,casein['mutated_seq']):
        fileout.write(chunk+'\n')
fileout.close()
