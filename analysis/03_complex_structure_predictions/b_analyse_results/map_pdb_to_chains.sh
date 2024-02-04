#!/bin/bash


#pdbcode="$1"
pdbcode=$(echo $1 | awk '{print tolower($0)}')

case $pdbcode in
    6pb0)
        chains=R,U
        ;;
    6p9x)
        chains=R,P
        ;;
    7ts0)
        chains=P,U
        ;;
    7f9z)
        chains=R,C
        ;;
    7s1m)
        chains=R,P
        ;;
    7lll)
        chains=R,P
        ;;
    7x9c)
        chains=R,P
        ;;
    8e3y)
        chains=R,P
        ;;    
    6b3j)
        chains=R,P
        ;;
    7d68)
        chains=R,P
        ;;
    7rmg)
        chains=R,S
        ;;
    7rmi)
        chains=R,S
        ;;
    7ryc)
        chains=O,L
        ;;
    7vgx)
        chains=R,L
        ;;
    7vqx)
        chains=R,L
        ;;
    7x9b)
        chains=R,P
        ;;
    8f7s)
        chains=R,P
        ;;
    8f7w)
        chains=R,P
        ;;
    8f7q)
        chains=R,P
        ;;
    8f7r)
        chains=R,P
        ;;
    8e3z)
        chains=R,P
        ;;
    *)
        chains=R,P
        ;;
esac

echo $chains