#!/usr/bin/bash
# What we need:
# - input file
# - group size. By a group we mean the number SHEETS that will be folded and stitched together. Usually 4.
# - output file name

IN=$1   # input file
GS=$2   # group size, usually 16
OUT=$3  # output file

TEMPDIR=tmp_$(date +"%s")
PAGES=$TEMPDIR/pages
SCALED=$TEMPDIR/pages-scaled
PAIRS=$TEMPDIR/pairs
STACKS=$TEMPDIR/stacks
ROTATED=$TEMPDIR/rotated

echo "Temp dir is $TEMPDIR"
if [ -d $TEMPDIR ] || [ -f $OUT ]; then
	echo "Fuck off"
	exit 1
fi

#if [ ! $(($GS % 4)) -eq 0 ]; then
#	echo "Group size not divisible by 4 makes no sense"
#fi

mkdir $TEMPDIR
mkdir $TEMPDIR/pages
mkdir $TEMPDIR/pages
mkdir $TEMPDIR/pages
mkdir $TEMPDIR/pages
mkdir $TEMPDIR/pages
mkdir $TEMPDIR/pages
mkdir $TEMPDIR/pages

# Check that

# Split document into individual pages


# Scale individual pages to half of US letter


# Pair pages which appear on same side of same sheet, in correct order


# Stack paired pages into single-page pdfs


# Rotate every other pair by 180 deg. for duplex printing


# Unite all stacked pairs into one print-ready document
#pdfunite rotated/* result.pdf
