#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process SCAGAIRE{
    tag "${climb_id}"
    container 'community.wave.seqera.io/library/scagaire:0.0.4--d340715dde589279'
    publishDir "${params.outdir}/scagaire", mode: 'copy'

    input:
    tuple val(climb_id), path(kraken_assignments), path(kraken_report),  path(abricate_out), val(species)

    // output:
    // path "\$prefix_scagaire_summary.tsv"


    script:
    """
    echo ${species}

    """
}

    // prefix=\$(echo "${species}" | sed 's/ /_/g')
    // scagaire \
    //     -n card \
    //     -t abricate \
    //     ${species} \
    //     ${abricate} \
    //     -s \$prefix_scagaire_summary.tsv -o \$prefix_scagaire_summary.tsv