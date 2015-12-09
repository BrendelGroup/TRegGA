#!/usr/bin/env bash

for module in numpy matplotlib Bio; do
    echo -n "[TRegGA] Python module $module ... "
    python -c "import $module" > /dev/null 2>&1
    returnstatus=$?
    if [ $returnstatus == "0" ]; then
        echo OK
    else
        echo 'NOT INSTALLED!'
    fi
done

for program in AlignGraph Eval-AlignGraph art act dnaplotter bowtie bowtie2 \
               bwa entret fastqc GapFiller.pl gth gt ngsutils samtools \
               SOAPdenovo-63mer SOAPdenovo-127mer fastq-dump Rscript; do
    echo -n "[TRegGA] Third-party program $program ... "
    which $program > /dev/null 2>&1
    returnstatus=$?
    if [ $returnstatus == "0" ]; then
        echo OK
    else
        echo 'NOT INSTALLED!'
    fi
done
