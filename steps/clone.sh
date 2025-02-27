#!/usr/bin/env bash
# The MIT License (MIT)
#
# Copyright (c) 2021-2025 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
set -e
set -o pipefail

start=$(date +%s%N)

jobs=${TARGET}/temp/jobs/clone-jobs.txt
rm -rf "${jobs}"
mkdir -p "$(dirname "${jobs}")"
touch "${jobs}"

repos="${TARGET}/temp/repositories.txt"
mkdir -p "$(dirname "${repos}")"
tail -n +2 "${TARGET}/repositories.csv" > "${repos}"
total=$(wc -l < "${repos}" | xargs)

"${LOCAL}/help/assert-tool.sh" git --version

declare -i repo=0
sh="$(dirname "$0")/clone-repo.sh"
while IFS=',' read -r r tag tail; do
    repo=$((repo+1))
    if [ -z "${tag}" ]; then tag='master'; fi
    if [ "${tag}" = '.' ]; then tag='master'; fi
    if [ -e "${TARGET}/github/${r}" ]; then
        echo "${r}: Git repo is already here (${tail})"
    else
        printf "%s %s %s %s %s\n" "${sh@Q}" "${r@Q}" "${tag@Q}" "${repo@Q}" "${total@Q}" >> "${jobs}"
    fi
done < "${repos}"

"${LOCAL}/help/parallel.sh" "${jobs}" 8
wait

echo "Cloned ${total} repositories in $(nproc) threads$("${LOCAL}/help/tdiff.sh" "${start}")"
