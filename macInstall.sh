#!/bin/bash
################################################################################
#     PROJECT: RedBlackTree
#    FILENAME: macInstall.sh
#         IDE: AppCode
#      AUTHOR: Galen Rhodes
#        DATE: 3/14/2018 9:39 AM
# DESCRIPTION: Bash Script
#
# Copyright (c) 2018 Galen Rhodes. All rights reserved.
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#################################################################################

PDIR=$(dirname $(readlink -f "$0"))
PROJECT=`find "${PDIR}" -name "*.xcodeproj" -exec basename -s .xcodeproj {} \;`
DSTROOT="${PDIR}/Release"
LIB_INSTALL_PATH="lib"
PUBLIC_HEADERS_FOLDER_PATH="include"
FRAMEWORK_INSTALL_PATH="Frameworks"


echo "     Project Directory: \"${PDIR}\""
echo "          Project Name: \"${PROJECT}\""
echo "               DSTROOT: \"${DSTROOT}\""
echo "  Library Install Path: \"${DSTROOT}/${LIB_INSTALL_PATH}\""
echo "  Headers Install Path: \"${DSTROOT}/${PUBLIC_HEADERS_FOLDER_PATH}\""
echo "Framework Install Path: \"${DSTROOT}/${FRAMEWORK_INSTALL_PATH}\""

rm -fr "${DSTROOT}"
mkdir -p "${DSTROOT}/${LIB_INSTALL_PATH}"
mkdir -p "${DSTROOT}/${FRAMEWORK_INSTALL_PATH}"

xcodebuild -project "${PROJECT}.xcodeproj" -target "${PROJECT}" -configuration Release \
    clean build install DSTROOT="${DSTROOT}/" INSTALL_PATH="/${LIB_INSTALL_PATH}/dynamic" \
    PUBLIC_HEADERS_FOLDER_PATH="/${PUBLIC_HEADERS_FOLDER_PATH}" SKIP_INSTALL=No \
    > "${DSTROOT}/${PROJECT}Dynamic.log"

xcodebuild -project "${PROJECT}.xcodeproj" -target "${PROJECT}Static" -configuration Release \
    clean build install DSTROOT="${DSTROOT}/" INSTALL_PATH="/${LIB_INSTALL_PATH}/static" \
    PUBLIC_HEADERS_FOLDER_PATH="/${PUBLIC_HEADERS_FOLDER_PATH}" SKIP_INSTALL=No \
    > "${DSTROOT}/${PROJECT}Static.log"

xcodebuild -project "${PROJECT}.xcodeproj" -target "${PROJECT}Framework" -configuration Release \
    clean build install DSTROOT="${DSTROOT}/" INSTALL_PATH="/${FRAMEWORK_INSTALL_PATH}" SKIP_INSTALL=No \
    > "${DSTROOT}/${PROJECT}Framework.log"

res="$?"
exit "${res}"
