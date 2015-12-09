#!/usr/bin/env bash

cd reference/rice_indica/

shasum -c checksums.sha
cd -

cd reference/rice_japonica/
shasum -c checksums.sha
cd -

cd targets/
shasum -c checksums.sha
cd -
