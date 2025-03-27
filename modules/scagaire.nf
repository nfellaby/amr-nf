#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process SCAGAIRE{
    tag "${climb_id}"
    container 'community.wave.seqera.io/library/scagaire_pip_pkg-resources:89273e7b562d4859'
    publishDir "${params.outdir}/scagaire", mode: 'copy'

    input:
    tuple val(climb_id), path(kraken_assignments), path(kraken_report),  path(abricate_out), val(species)

    // output:
    // path "\$prefix_scagaire_summary.tsv"


    script:
    """
    echo ${species}
    prefix=\$(echo "${species}" | sed 's/ /_/g')
   
    scagaire \
        -n card \
        -t abricate \
        ${species} \
        ${abricate_out} \
        -s \${prefix}_scagaire_summary.tsv -o \${prefix}_scagaire_summary.tsv
    """
}

    
    // scagaire \
    //     -n card \
    //     -t abricate \
    //     ${species} \
    //     ${abricate} \
    //     -s \$prefix_scagaire_summary.tsv -o \$prefix_scagaire_summary.tsv