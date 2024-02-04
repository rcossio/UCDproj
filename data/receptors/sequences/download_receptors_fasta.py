import os
import time

rec_list = [('GHSR'	,'Q92847'),	
('M1R'	,'P11229'),
('M2R'	,'P08172'),
('M3R'	,'P20309'),
('M4R'	,'P08173'),
('M5R'	,'P08912'),
('CCK1R','P32238'),
('CCK2R','P32239'),
('CB1R'	,'P21554'),
('CB2R'	,'P34972'),
('OTR'	,'P30559'),
('DOPR'	,'P41143'),
('KOPR'	,'P41145'),
('MOPR'	,'P35372'),
('NOPR'	,'P41146'),
('Y1R'	,'P25929'),
('Y2R'	,'P49146'),
('Y4R'	,'P50391'),
('Y5R'	,'Q15761'),
('Y6R'	,'Q99463'),
('NK1R'	,'P25103'),
('NK2R'	,'P21452'),
('NK3R'	,'P29371'),
('BB2R'	,'P30550'),
('GCGR'	,'P47871'),
('GLP1R','P43220'),
('GLP2R','O95838'),
('GIPR'	,'P48546'),
('CRF1R','P34998'),
('CRF2R','Q13324'),
('VIP2R','P41587'),
('VIP1R','P32241')]

for (name,seqId) in rec_list:
    print (name,'---',seqId)
    os.system(f'wget -O {name}.fasta https://rest.uniprot.org/uniprotkb/{seqId}.fasta')	
    time.sleep(3)