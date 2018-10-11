#!/bin/bash

fsdir=$1
subject=$2
dwi=$3

mkdir -p $fsdir/$subject/dti
for each in $(dirname $dwi)/*; do
    #link into expected location, remove trailing "s" from bval/bvec filenames
    ln -sf $each $fsdir/$subject/dti/$(echo $(basename $each) | \
        sed -e 's/\/dwi\./\/dti\./' -e 's/s$//')
done

ModelSubCorticalStruct_first.sh -fs $fsdir -subj $subject
PrepareSurfaceConnectome_MSMT.sh -fs $fsdir -subj $subject
for sname in $(ls $fsdir/$subject/ | grep -E '(Left|Right)'); do
    RegisterSubCortSurface.sh -fs $fsdir -subj $subject -sname $sname
done

getSurfaceConnectome_MSMT.sh  -fs $fsdir -subj $subject   
SubsampleSurfaceConnectome_MSMT.sh  -fs $fsdir -subj $subject
