#!/usr/bin/bash

echo "Usage: babby-chart.sh <month_number (no leading zeroes!!!)> <min_weight(grams)> <max_weight(grams)>"
echo "You supplied:"
echo "  month: $1"
echo "  starting weight: $2"
echo "  maximum weight: $3"
echo "Pray these are numbers!"

this_month=`printf %02d $1`
next_month=`printf %02d $(($1+1))`
echo "  this month: $this_month, next month: $next_month"
echo "Mind you, this script will break in December, but I don't think we will stop recording weight by then."

gnuplot <<EOF
set xdata time
set timefmt "%Y-%m-%d"
set format x "%b %d"
set xrange ["2019-$this_month-07":"2019-$next_month-06"]
set yrange ["$2":"$3"]
set grid ytics lt 1 lw 0.2 lc rgb "#333333"
set grid xtics lt 1 lw 0.2 lc rgb "#333333"
set xtics "2019-04-07",86400 rotate
set ytics 25
set terminal pdf font "Helvetica, 8" size 11,8.5
set output "babby-chart-$this_month-$2-$3.pdf"
set nokey
plot 0
EOF
