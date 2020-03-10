#!/bin/sh

#  carthage-iOS.sh
#  RUNA
#
#  Created by Wu Wei on 2019/01/15.
#  Copyright © 2018 LOB. All rights reserved.

echo
echo "===[$0] START==="
set -eo pipefail

SDK_PRODUCT_NAME=$1
if [ ! $SDK_PRODUCT_NAME ]; then
	echo "must give a product name"
	exit 1
fi

if [ ! $SDK_OUTPUT_DIR ]; then
	SDK_OUTPUT_DIR=${PROJECT_DIR}/build/${CONFIGURATION}
fi

SDK_VERSION_STRING=`agvtool what-marketing-version -terse1`

if [ "$1" != "archive" ]; then
	echo "clean"
	SDK_BUILD_DIR=${PROJECT_DIR}/Carthage/Build
	rm -rf ${SDK_BUILD_DIR}

	if [ "$1" == "clean" ]; then
		exit
	fi

	echo "carthage build for ${SDK_PRODUCT_NAME} $SDK_VERSION_STRING in configuration $CONFIGURATION"
	carthage build --configuration $CONFIGURATION --platform iOS --no-skip-current --project-directory ${PROJECT_DIR}

fi

SDK_NAME=${SDK_PRODUCT_NAME}_iOS_${SDK_VERSION_STRING}.framework.zip
SDK_OUTPUT=${SDK_OUTPUT_DIR}/$SDK_NAME
echo "carthage archive to $SDK_OUTPUT for ${SDK_PRODUCT_NAME}"
carthage archive --output $SDK_OUTPUT ${SDK_PRODUCT_NAME}
if test -f $SDK_OUTPUT; then
	echo "-----prune dSYM files -----"
	cd $SDK_OUTPUT_DIR
	unzip -o $SDK_NAME -d .
	find . -name *.dSYM -o -name *.bcsymbolmap | xargs rm -r
	rm $SDK_NAME
	zip -r $SDK_NAME ./Carthage -x .DS_Store
	rm -r ./Carthage
	open .
fi

cd $PROJECT_DIR
echo "===[$0] END==="
