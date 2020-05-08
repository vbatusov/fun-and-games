#!/usr/bin/bash


# TODO
# Must insert two blank pages in the beginning and two at the end. For binding purposes.



# What we need:
# - input file
# - group size. By a group we mean the number SHEETS that will be folded and stitched together. Usually 4.
# - output file name

IN=$1   # input file
GS=$2   # group size, usually 4 
OUT=$3  # output file

TEMPDIR=tmp_$(date +"%s")

echo "This script depends on Coherent PDF <http://community.coherentpdf.com/>, pdfseparate, and pdfunite."
# If can't create temp dir or group size is not a number, or cpdf not available,
# then you know what you should do
if [ -d $TEMPDIR ] || [ ! -z "${GS//[0-9]}" ] || [ ! -x "$(command -v cpdf)" ]; then
	echo "Fuck off"
	exit 1
fi

let PPG=$GS*4  # source pages per group

echo "Temp dir is $TEMPDIR, $PPG pages per group."

# make all other temp directories
PAGES=$TEMPDIR/pages
SCALED=$TEMPDIR/pages-scaled
PAIRS=$TEMPDIR/pairs
STACKS=$TEMPDIR/stacks
ROTATED=$TEMPDIR/rotated

mkdir $TEMPDIR
mkdir $PAGES
mkdir $SCALED
mkdir $PAIRS
mkdir $STACKS
mkdir $ROTATED


# Split document into individual pages
echo "Separating into individual pages..."
pdfseparate $IN $PAGES/%05d.pdf

# Get number of source pages and calculate number of whole groups
let NP=$(ls $PAGES | wc -l)
let NG=$((NP / PPG))
echo "Source contains $NP pages, so there will be $NG whole groups."
# Screw the remainder for now TODO

# Scale individual pages to half of US letter
echo "Scaling each page to half of US letter..."
for filename in $PAGES/*pdf; do
	cpdf -scale-to-fit "139.7mm 215.9mm" $filename -o $SCALED/$(basename "$filename")
done

# Pair pages which appear on same side of same sheet, in correct order
# For each group, create a correct order and glue pairs together
echo "Pairing pages in correct order..."
for ((i=0; i<$NG; i++)); do
	# pages in current group: (i*$PPG)+1 .. (i*$PPG)+$PPG
	# each group will results in $GS printed sheets
	# each sheet has four pages == two sides
	# Example of order:
	# 16 &  1
	# 2  & 15
	# 14 &  3
	#  4 & 13
	# 12 &  5 
	# 6  & 11
	# 10 &  7
	# 8  &  9
	echo " "	
	# $j counts pages to middle of current group starting from 1
	for ((j=1; j<=$((PPG/2)); j++)); do
		first=`printf %05d $(((i + 1)*PPG - j + 1))`
		last=`printf %05d $((i*PPG + j))`
		pairname=`printf %05d $i`-`printf %05d $j`.pdf

		if [ $(($j % 2)) -eq 1 ]; then
			echo "  $first $last"
			pdfunite $SCALED/$first.pdf $SCALED/$last.pdf $PAIRS/$pairname
		else
			echo "  $last $first"
			pdfunite $SCALED/$last.pdf $SCALED/$first.pdf $PAIRS/$pairname
		fi
	done
done


# Stack paired pages into single-page pdfs
echo "Stacking paired pages into single-page PDFs..."
for filename in $PAIRS/*pdf; do
	#echo $filename
	cpdf -twoup-stack $filename -o $STACKS/$(basename $filename)
done


# Rotate every other pair by 180 deg. for duplex printing
echo "Rotating every other stacked pair by 180 degrees..."
let i=0 # Alternation flag
for filename in $STACKS/*pdf; do
	if [[ $i -eq 1 ]]; then
		cp $filename $ROTATED
	else
		cpdf -rotate-contents 180 $filename -o $ROTATED/$(basename $filename)
	fi

	let i=1-$i
done

# Unite all stacked pairs into one print-ready document
echo "Uniting everything into the end result..."
pdfunite $ROTATED/* $OUT

# Clean-up
echo "Cleaning up..."
rm -rf $TEMPDIR

echo "Done. The result is in $OUT."


