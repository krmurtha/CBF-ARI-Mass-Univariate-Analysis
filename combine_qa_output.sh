#!/usr/bin/env bash

###################################################################
#  ⊗⊗ ⊗⊗⊗⊗ ⊗⊗⊗⊗⊗⊗⊗⊗⊗ ⊗⊗⊗⊗⊗⊗⊗⊗⊗⊗⊗⊗⊗ ⊗⊗⊗⊗⊗⊗⊗⊗⊗⊗⊗⊗⊗ ⊗⊗⊗⊗⊗⊗⊗⊗ ⊗⊗⊗⊗ ⊗⊗  #
###################################################################

###################################################################
# Combine all text file output
###################################################################

###################################################################
# Usage function
###################################################################
Usage(){
  echo ""; echo ""; echo ""
  echo "Usage: `basename $0` -p </xcpEngine/Output/Path/> -f <fileExampleName.suffix> -o <outputFileName>"
  echo ""
  echo "Compulsory arguments:"
  echo "  -p : Output xcpEngine Directory"
  echo "       This is also the out_super from the engine's design .dsn file"
  echo "  -f : File name example"
  echo "       this will be fed to the bash find command"
  echo "       Do not use any subject specific information in this field"
  echo "  -o : Output file name"
  echo "       this will be written in the provided output xcpEngine directory"
  exit 2
}

###################################################################
# Parse arguments
###################################################################
while getopts "p:f:o:h" OPTION ; do
  case ${OPTION} in
    p)
      outDir=${OPTARG}
      ;;
    f)
      fileSkeloton=${OPTARG}
      ;;
    o)
      outputFileName=${OPTARG}
      ;;
    h)
      Usage
      ;;
    *)
      Usage
      ;;
    esac
done

###################################################################
# Ensure that all compulsory arguments have been defined
###################################################################
[[ -z ${outDir} ]] && Usage
[[ -z ${fileSkeloton} ]] && Usage
[[ -z ${outputFileName} ]] && Usage

###################################################################
# Now run through each file that we find and append it to the output file
###################################################################
outFile="${outDir}/${outputFileName}"
i=0
for filename in `find ${outDir} -name "*${fileSkeloton}" -type f` ; do
  if [ "${filename}" != "${outFile}" ] ; then
    if [[ ${i} -eq 0 ]] ; then
      head -1 ${filename} > ${outFile} ;
    fi
    tail -n +2 ${filename} >> ${outFile}
    i=$(( ${i} + 1 )) ;
  fi
done
