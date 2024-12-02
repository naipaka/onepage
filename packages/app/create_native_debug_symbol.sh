#!/bin/sh

INPUT_DIR="build/app/intermediates/flutter/release"
OUTPUT_DIR="build/app/outputs/bundle/release/obj"

mkdir -p $OUTPUT_DIR

cp -a $INPUT_DIR/arm64-v8a $OUTPUT_DIR
cp -a $INPUT_DIR/x86_64 $OUTPUT_DIR
cp -a $INPUT_DIR/armeabi-v7a $OUTPUT_DIR

cd $OUTPUT_DIR

rm -f .DS_Store

zip -r ../symbols.zip .
