#!/bin/zsh


# download SARS-CoV-2 datasets
nextclade dataset get --name 'sars-cov-2' --output-dir ${1}

# running nextclade
nextclade run --input-dataset ${1} --output-all=${2} ${3}





