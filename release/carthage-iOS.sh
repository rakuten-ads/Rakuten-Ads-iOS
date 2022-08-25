#!/bin/sh

#  carthage-iOS.sh
#  RUNA
#
#  Created by Wu Wei on 2019/01/15.
#  Copyright © 2018 LOB. All rights reserved.

echo
echo "===[$0] START==="
set -eo pipefail

eval "$(/opt/homebrew/bin/brew shellenv)"

SDK_PRODUCT_NAME=$1
if [ ! $SDK_PRODUCT_NAME ]; then
	echo "must give a product name"
	exit 1
fi

if [ ! $SDK_OUTPUT_DIR ]; then
	SDK_OUTPUT_DIR=${PROJECT_DIR}/build/${CONFIGURATION}
fi

if [ "$1" != "archive" ]; then
	echo "clean"
	SDK_BUILD_DIR=${PROJECT_DIR}/Carthage/Build
	rm -rf ${SDK_BUILD_DIR}

	if [ "$1" == "clean" ]; then
		exit
	fi

	echo "carthage build for ${SDK_PRODUCT_NAME} $SDK_VERSION_STRING in configuration $CONFIGURATION"
	carthage build --use-xcframeworks --configuration $CONFIGURATION --platform iOS --no-skip-current --project-directory ${PROJECT_DIR}

fi

SDK_BUILD_FILE=$SDK_PRODUCT_NAME.xcframework
SDK_OUTPUT_FILE=${SDK_OUTPUT_DIR}/${SDK_PRODUCT_NAME}_iOS_${SDK_VERSION_STRING}.xcframework.zip
SDK_OUTPUT_FILE_DSYM=${SDK_OUTPUT_DIR}/${SDK_PRODUCT_NAME}_iOS_${SDK_VERSION_STRING}+dsym.zip

if [ ! -d $SDK_OUTPUT_DIR ]; then
	mkdir $SDK_OUTPUT_DIR
fi

cd $SDK_BUILD_DIR
if [ -d $SDK_BUILD_FILE ]; then
	# zip sdk+dsym
	zip -r $SDK_OUTPUT_FILE_DSYM $SDK_BUILD_FILE -x ".DS_Store"

	# zip sdk
	find . -name "*.dSYM" -exec rm -r -- {} +
	find . -name "*.bcsymbolmap" -exec rm -- {} +
	find . -name ".DS_Store" -exec rm -r -- {} +
	find . -empty -type d -delete
	zip -r $SDK_OUTPUT_FILE $SDK_BUILD_FILE -x ".DS_Store"
fi
open $SDK_OUTPUT_DIR

echo "===[$0] END==="
