#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2021-2024 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e
set -o pipefail

if [ -z "${LOCAL}" ]; then
  LOCAL=$(dirname "$0")/..
fi

"${LOCAL}/help/assert-tool.sh" javac --version

if pmd pmd --version >/dev/null 2>&1; then
  pmd pmd --version
  echo "PMD is already installed"
  exit
fi

if [ ! -e /usr/local ]; then
  echo "The directory /usr/local must exist"
  exit 1
fi

pmd_version=6.55.0
cd /usr/local
echo "Installing PMD ${pmd_version}"
wget --quiet https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.55.0/pmd-bin-${pmd_version}.zip
echo "Unpacking PMD ${pmd_version}"
unzip -qq pmd-bin-${pmd_version}.zip
echo "unzipped PMD ${pmd_version}"
rm pmd-bin-${pmd_version}.zip
echo "Deleting PMD ${pmd_version}"
mv pmd-bin-${pmd_version} pmd
echo "PMD installed into /usr/local/pmd"
ln -s /usr/local/pmd/bin/run.sh /usr/local/bin/pmd
echo "PMD installed into /usr/local/bin/pmd"
