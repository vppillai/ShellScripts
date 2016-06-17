#!/bin/sh

##Script to generate makefiles for all MPLABX projects and compile them.
## results (memoryfile.xml) will be copied to the parent dir structure in the output folder. 

PATH_B=$PATH


##Generate make files

PROJECTS=( $(find . -name *.X | xargs -l ) )
count=1;
for project in ${PROJECTS[@]}
do  
	echo $count / ${#PROJECTS[@]}
	'/cygdrive/c/Program Files (x86)/Microchip/MPLABX/v3.35.03/mplab_ide/bin/prjMakefilesGenerator.bat' $project; 
	((count+=1));
done


##Make the projects
makeFiles=( $(find . -name Makefile | xargs -l dirname) )
count=1;
export PATH='/cygdrive/c/Program Files (x86)/Microchip/MPLABX/v3.35.03/gnuBins/GnuWin32/bin'
for i in ${makeFiles[@]}
do
	echo $count / ${#makeFiles[@]}
	echo $i
	make -j16 -C $i all
	((count+=1));
done


###copy the results
export PATH=$PATH_B
mFILES=( $(find . -name memoryfile.xml | xargs -l ) )
for file in ${mFILES[@]}
do  
	mkdir -p output/$(dirname $file);
	cp $file output/$file;
done
	
