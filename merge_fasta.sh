#!/bin/zsh

# param1: genome assembly dir
# param2: the merged consensus fasta files dir
 
cd ${1}

cat *.consensus.fasta > ${2}/consensus_genomes.fasta



