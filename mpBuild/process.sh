#!/bin/sh


##Script to generate a report of memory usage for all memory.xml files.

cd uOpt
memFiles=( $(find . -name memoryfile.xml | xargs -l ) )
cd ..

for file in ${memFiles[@]}
do
	Pmem=( $(xmllint.exe --xpath "string(/project/executable/memory[1]/used)" uOpt/$file) )
	Dmem=( $(xmllint.exe --xpath "string(/project/executable/memory[2]/used)" uOpt/$file) )

	PmemO=( $(xmllint.exe --xpath "string(/project/executable/memory[1]/used)" opt/${file}) )
	DmemO=( $(xmllint.exe --xpath "string(/project/executable/memory[2]/used)" opt/${file}) )

	echo $(dirname $file) \| $Pmem \| $Dmem \| $PmemO \| $DmemO 
done
