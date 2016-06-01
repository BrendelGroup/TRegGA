### Checklist for running TRegGA
- [ ] Install TRegGA: git clone https://github.com/huangc/TRegGA
- [ ] Install the required softwares as described in `INSTALL.md`
- [ ] Optional: setup the required modules to run in HPS environment such as Mason with `xloadmodules`
- [ ] Check for any missing softwares with `check-prereqs.sh` 
- [ ] Configure `TRegGA.config` for software locations that needs to be included into makefiles
- [ ] Configure `TRegGA.source` for program locations that needs to be included into shell environment
- [ ] Install the requqired reference and datasets with `setup.sh`
- [ ] Check for any missing dataset with `check-data.sh`
- [ ] Optional: link reads and assemblies from other TRegGA repository to here with `xlink`
- [ ] Setup `TRegGA.sample` as explained below
- [ ] Run TRegGA as explained in `VIGNETTE.txt`
- [ ] Alternatively, use `TRegGA-Example.run` to generate `runTRegGA*`, then submit `runTRegGA*`.  

### Use case of TRegGA
* Assembly of the SWEET13 locus using reads from cultivar Zhengshan97 against the rice Japonica Nipponbare reference genome.
* [SWEET13](http://plants.ensembl.org/Oryza_sativa/Gene/Summary?g=OS12G0476200;r=12:17302127-17305326;t=OS12T0476200-01) (Xa25/xa25, Os12N3) Bidirectional sugar transporter. Gene ID in Oryza sativa Japonica: OS12G0476200, chromosome 12: 17,302,127-17,305,326 reverse strand.
* We recommed adding 10 Kb to the borders of the interested region as the final target to increase the specificity of the reference-guided assembly.
* We use chr12:17,292,001-17,315,000 as the target region for the following TRegGA example. The final makefile command looks like this:
```
make CHECKONLY=no NUMPROC=30 CULTIVAR='\"Zhengshan97\"' SYNONYM=ZHENGSHAN97 TARGET=OsjSWEET13 REFERENCE=OsjCHR12 FROM=17292001 TO=17315000 -f Makefile_TRegGA-orig >& err_ZHENGSHAN97-on-OsjSWEET13
```
### Things to know about TRegGA arguments
* The CULTIVAR argument must be in quotes (allowing spaces), such as `"KOTO OURA S 5"`. In order for the quotes to be taken up by the TRegGA makefile properly, it is necessary to protect it as `'\"KOTO OURA S 5\"'`.
* The CULTIVAR can be the cultivar VARNAME such as `"KOTO OURA S 5"`, as appeared in `reads/rice_line_metadata_20140521.tsv`, or less confusingly the cultivar UNIQUE_ID such as `"IRIS 313-10712"`.
* The VARNAME and UNIQUE_ID to be parsed may be different from what you would find from literatures or online resources in terms of its format, such as `"IRIS 313-10712"` could be presented as `"IRIS_313-10712"`. The difference may cause name parsing problem. Users are strongly advised to check/convert to the acceptable cultivar name prior to running TRegGA by validating it against this table `reads/rice_line_metadata_20140521.tsv`, or against the [IRRI Rice SNP-Seek Database](http://oryzasnp.org/iric-portal/_variety.zul) 
* The SYNONYM argument should be one word, with no space, hyphen or dot, such as `KOTOOURAS5`. Word with underscore is acceptable, such as `KOTO_OURA_S_5`. 
* The TARGET argument should uniquely identify the target specified by REFERENCE, FROM - TO range.
* If you want to change the range later, then use a different label or remove the existing TARGET.* files in subdirectory targets.

### TRegGA setup
```
TRegGA_DIR=$(pwd)
SRCDIR=/usr/local/src/NGS-DIR
#SRCDIR=/N/dc2/projects/brendelgroup/TRegGA/src
```
##### Update TRegGA_DIR in `TRegGA.config`
* TRegGA_DIR inside `TRegGA.config` should NOT be set using `$(pwd)` method, as `TRegGA.config` is to be included in different makefiles located in different directories.
```
sed -e "s|YOUR_WORK_DIR|${TRegGA_DIR}|g" TRegGA.config.gnomic > TRegGA.config
sed -i "s|YOUR_SRC_DIR|${SRCDIR}|g" TRegGA.config
```
##### Update TRegGA_DIR in `TRegGA.source`
```
sed -e "s|YOUR_WORK_DIR|${TRegGA_DIR}|g" TRegGA.source.gnomic > TRegGA.source
sed -i "s|YOUR_SRC_DIR|${SRCDIR}|g" TRegGA.source
```
##### Link to other TRegGA repository with `xlink`
```
REPO=/home/huangcy/MYWORK/TRegGA
# REPO=/N/dc2/projects/brendelgroup/TRegGA/prj
# REPO=/N/dc2/scratch/vbrendel/TRegGA
sed -e "s|YOUR_REPO_DIR|${REPO}|g" xlink-orig > xlink
tcsh xlink
```
##### Setup `TRegGA.sample`
* `TRegGA.sample` is a list of samples formatted as `CULTIVAR|SYNONYM`, one sample per row, such as:
```
echo "Biniapan|BINIAPAN
IRIS 313-10712|KOTOOURA
IRIS 313-11755|A2_257
CX140|NIPPONBARE
IRIS 313-11356|CR441" > TRegGA.sample
```

### Use `TRegGA-Example.run` to generate `runTRegGA`
* `TRegGA-Example.run` takes a list of samples in `TRegGA.sample`, and then generate subscripts `runTRegGA*`, for TRegGA job submitting.
* `TRegGA-Example.run` generate qsub version of `runTRegGA*` that is suitable for HPS TORQUE environment, such as `mason.indiana.edu`
* Modify `runTRegGA*` into shell version for Linux shell environment, such as `gnomic.soic.indiana.edu`    

##### Generate qsub version of runTRegGA
```
sh TRegGA-Example.run
```
##### Generate shell version of runTRegGA
```
len=`awk 'END { print NR }' TRegGA.sample`
for ((k=1; k<=$len; k++))
do
head -$k TRegGA.sample | tail -1 > rec
SYNONYM=`cut -d "|" -f2 rec`
grep -v "^#PBS" runTRegGA_${SYNONYM}-on-* > tmp
grep -v "^module" tmp > runTRegGA_${SYNONYM}-on-*
done
```
### Submit runTRegGA
```
len=`awk 'END { print NR }' TRegGA.sample`
for ((k=1; k<=$len; k++))
do
head -$k TRegGA.sample | tail -1 > rec
SYNONYM=`cut -d "|" -f2 rec`
# choose qsub or shell version to run
qsub runTRegGA_${SYNONYM}-on-*
# sh runTRegGA_${SYNONYM}-on-* &
done
```

