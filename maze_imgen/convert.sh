#!/bin/bash
NETPBM_DIR="/home/abderrahim/netpbm/bin"
if [[ -z "$1" || -z "$2" ]]; then 
	echo "Usage: \`convert.sh <in_pbm_file> <out_png_file>\`"
else
	$NETPBM_DIR/pnmtopng "$1" > "$2"
	printf "Converted pbm (%s) to png (%s)\n" "$1" "$2"
fi
