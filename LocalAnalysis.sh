#! /bin/bash

tar xf logdata.tar
cp arcgistimes.txt logdata
cp weights.txt logdata
cp template.md logdata

echo "Begin local analysis."
bash analysis.sh
echo "Local analysis done."
