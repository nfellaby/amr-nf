#!/usr/bin/env nextflow
// nextflow.enable.dsl=2

// TODO: add include to read in subworkflows


process checkPath {    
    script:
    """
    echo "Current PATH: \$PATH" >temp.txt
    """
}

workflow {
    // handle input parameters

    // Run subworkflows
}