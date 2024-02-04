#!/bin/bash

#pdbcode="$1"
pdbcode=$(echo $1 | awk '{print tolower($0)}')


case $pdbcode in
    6pb0)
        receptor=CRF1R
        ;;
    6p9x)
        receptor=CRF1R
        ;;
    7ts0)
        receptor=CRF2R
        ;;
    7f9z)
        receptor=GHSR
        ;;
    7s1m)
        receptor=GLP1R
        ;;
    7lll)
        receptor=GLP1R
        ;;
    7x9c)
        receptor=Y4R
        ;;
    8e3y)
        receptor=VIP1R
        ;;
    6b3j)
        receptor=GLP1R
        ;;
    7d68)
        receptor=GLP2R
        ;;
    7rmg)
        receptor=NK1R
        ;;
    7rmi)
        receptor=NK1R
        ;;
    7ryc)
        receptor=OTR
        ;;
    7vgx)
        receptor=Y1R
        ;;
    7vqx)
        receptor=VIP2R
        ;;
    7x9b)
        receptor=Y2R
        ;;
    8f7s)
        receptor=DOPR
        ;;
    8f7w)
        receptor=KOPR
        ;;
    8f7q)
        receptor=MOPR
        ;;
    8f7r)
        receptor=MOPR
        ;;
    8e3z)
        receptor=VIP1R
        ;;
    *)
        receptor=none
        ;;
esac

echo $receptor