#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process READ_ANALYSIS{
    tag "${climb_id}"
    container 'community.wave.seqera.io/library/pip_pandas:40d2e76c16c136f0'
    publishDir "${params.outdir}/abricate", mode: 'copy'

    // 1. Extract Read IDs from Abricate output file
    input:
    tuple val(climb_id), path(kraken_assignments), path(kraken_report),  path(abricate_out)

    output:
    tuple val(climb_id), path(kraken_report)
    
    script:
    """
    echo $climb_id
    tail -n +2 ${abricate_out} | cut -f2 | sort | uniq > unique_amr_reads.txt
    while read i; do \
        grep -P "\$i\t" ${kraken_assignments} | \
        cut -f 2-3 >>read_taxid_assignment.tsv; \
    done< unique_amr_reads.txt
    
    retrieve_taxon.py \
        -t read_taxid_assignment.tsv \
        -j ${kraken_report} \
        -a ${abricate_out} \
        -o abricate_taxa_out.tsv
    """
}

// retrieve_taxon.py -t read_taxid_assignment.tsv -j ${kraken_report} -o reads_kraken_info.tsv

// , path("reads_kraken_info.tsv")

// retrieve_taxon.py -t read_taxid_assignment.tsv -j ${kraken_report} -o reads_kraken_info.tsv