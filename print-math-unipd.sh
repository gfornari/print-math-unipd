#!/bin/bash

set -e

processPDF () {
    local FILEDIR=$(dirname "$1")
    local OUTPUT_DIR="$FILEDIR/print-ready"
    local FILENAME=$(basename "$1")

    # ${1::-4} removes the last 4 characters from the string $1
    local FILENAME_WO_EXT="${FILENAME::-4}"
    local OUTPUTFILEPATH="${FILEDIR}/${FILENAME_WO_EXT}-nup.pdf"
    local NEWFILEPATH="${OUTPUT_DIR}/${FILENAME_WO_EXT}-ready.pdf"

    # outputs a new pdf with the given nup scheme
    pdfjam --quiet --outfile "$FILEDIR" --nup $2 --suffix 'nup' --landscape "$1" && \

    mkdir -p $OUTPUT_DIR && \

    # rotates the even pages by 180 degrees
    pdftk A=$OUTPUTFILEPATH shuffle Aodd Aevensouth output $NEWFILEPATH && \

    rm $OUTPUTFILEPATH && \

    echo "Output PDF file written to ${NEWFILEPATH}"
}

# print help to the standard output
show_help () {
cat <<EOF
Usage: $(basename "$0") [OPTIONS] PDF_FILES

Create new PDFs (in the print-ready directory) with the given pages' scheme
and the even pages rotated by 180 degrees.

OPTIONS:
  -h, --help
    print this help and exit

  --nup
    set the scheme of the pages (e.g. 2x2, 3x2)

EXAMPLES:
Process all PDF files in the current path:
  $(basename "$0") *.pdf

Process all PDF files starting with "a" in the "docs" directory applying the
scheme 2x1:
  $(basename "$0") ./docs/a*.pdf --nup 2x1
EOF
}

# execute processPDF in parallel using the maximum number of cores
parallel_processPDF () {
    CORES_AMOUNT=$(grep -c ^processor /proc/cpuinfo)

    echo "Using $CORES_AMOUNT cores ..."

    export -f processPDF

    echo "$@" | xargs -n1 -P$CORES_AMOUNT bash -c 'processPDF "$@" '"$nup" _
}

# check for empty arguments
if [ -z "$1" ]; then
    show_help
    exit 0
fi

# evaluate params
params="$(getopt -o h -l help,nup: --name "$0" -- "$@")"
eval set -- "$params"

# default nup
nup="2x2"

# parse arguments
while [[ $# -gt 0 ]] ; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --nup)
            if [[ "$2" =~ ^[0-9]+x[0-9]+$ ]]; then
                nup="$2"
                shift
            fi
            ;;
        --)
            parallel_processPDF "${@:2}"
            exit 0
            ;;
    esac
    shift
done

