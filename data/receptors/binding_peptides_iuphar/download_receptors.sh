cd receptor-pages 

[ -f GHSR.html ] || wget -O GHSR.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=246
[ -f M1R.html ] || wget -O M1R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=13
[ -f M2R.html ] || wget -O M2R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=14
[ -f M3R.html ] || wget -O M3R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=15
[ -f M4R.html ] || wget -O M4R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=16
[ -f M5R.html ] || wget -O M5R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=17
[ -f CCK1R.html ] || wget -O CCK1R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=76
[ -f CCK2R.html ] || wget -O CCK2R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=77
[ -f CB1R.html ] || wget -O CB1R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=56
[ -f CB2R.html ] || wget -O CB2R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=57
[ -f OTR.html ] || wget -O OTR.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=369
[ -f DOPR.html ] || wget -O DOPR.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=317
[ -f KOPR.html ] || wget -O KOPR.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=318
[ -f MOPR.html ] || wget -O MOPR.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=319
[ -f NOPR.html ] || wget -O NOPR.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=320
[ -f Y1R.html ] || wget -O Y1R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=305
[ -f Y2R.html ] || wget -O Y2R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=306
[ -f Y4R.html ] || wget -O Y4R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=307
[ -f NK1R.html ] || wget -O NK1R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=360
[ -f GCGR.html ] || wget -O GCGR.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=251
[ -f GLP1R.html ] || wget -O GLP1R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=249
[ -f GLP2R.html ] || wget -O GLP2R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=250
[ -f GIPR.html ] || wget -O GIPR.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=248
[ -f CRF1R.html ] || wget -O CRF1R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=212
[ -f CRF2R.html ] || wget -O CRF2R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=213
[ -f VIP1R.html ] || wget -O VIP1R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=371
[ -f VIP2R.html ] || wget -O VIP2R.html	https://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=372

cd ..

python3 get_sequences.py GHSR
python3 get_sequences.py M1R
python3 get_sequences.py M2R
python3 get_sequences.py M3R
python3 get_sequences.py M4R
python3 get_sequences.py M5R
python3 get_sequences.py CCK1R
python3 get_sequences.py CCK2R
python3 get_sequences.py CB1R
python3 get_sequences.py CB2R
python3 get_sequences.py OTR
python3 get_sequences.py DOPR
python3 get_sequences.py KOPR
python3 get_sequences.py MOPR
python3 get_sequences.py NOPR
python3 get_sequences.py Y1R
python3 get_sequences.py Y2R
python3 get_sequences.py Y4R
python3 get_sequences.py NK1R
python3 get_sequences.py GCGR
python3 get_sequences.py GLP1R
python3 get_sequences.py GLP2R
python3 get_sequences.py GIPR
python3 get_sequences.py CRF1R
python3 get_sequences.py CRF2R
python3 get_sequences.py VIP1R
python3 get_sequences.py VIP2R

