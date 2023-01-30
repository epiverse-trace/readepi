#!/bin/zsh

mamba activate pangolin

# argument1: input fasta file (query)
# argument2: output files dir
pangolin ${1} --outdir ${2}

mamba deactivate




