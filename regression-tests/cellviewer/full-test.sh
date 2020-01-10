#!/bin/sh
die() { echo "FATAL ERROR: $@">&2; exit 1; }

echo "Testing cellviewer (pushing to website)"
npm install --prefix cellviewer || die "npm failed"

rm -rf ./cellviewer/src/output/
mkdir ./cellviewer/src/output/

python3 "./main.py" \
    --start 0 \
    --finish 20 \
    --debug "./debug" \
    --input "./input/frame%03d.png" \
    --output "./cellviewer/src/output" \
    --config "./config.json" \
    --initial "./cells.0.csv" \
    --temp 10 \
    --endtemp 0.01 || die "main.py failed"

python3 "./cellviewer/radialtree.py" \
    "./cellviewer/src/output" || die "radialtree failed"

npm run --prefix cellviewer deploy || die "2nd npm failed"

echo "Done testing cellviewer (pushed to website)"
