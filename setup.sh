#!/usr/bin/env bash
set -ex

cd reference/rice_indica/
./xgetseq
cd -

cd reference/rice_japonica/
./xgetseq
cd -

cd targets/
./xentret
cd -

cd reads/
gunzip -f -k seq_file_mapping_to_SRA.txt.gz
cd -
