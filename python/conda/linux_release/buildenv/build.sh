#!/bin/sh

set -e

BRANCH=master
URL=https://github.com/astra-toolbox/astra-toolbox

echo "Cloning from ${URL}"
echo "        branch: ${BRANCH}"

cd /root
git clone --depth 1 --branch ${BRANCH} ${URL}

[ $# -eq 0 ] || perl -pi -e "s/^(\s*version:\s*)[0-9a-z+\.']+$/\${1}'$1'/" astra-toolbox/python/conda/libastra/meta.yaml astra-toolbox/python/conda/astra-toolbox/meta.yaml
[ $# -eq 0 ] || perl -pi -e "s/^(\s*number:\s*)[0-9]+$/\${1}$2/" astra-toolbox/python/conda/libastra/meta.yaml astra-toolbox/python/conda/astra-toolbox/meta.yaml
[ $# -eq 0 ] || perl -pi -e "s/^(\s*-\s*libastra\s*==\s*)[0-9a-z+\.]+$/\${1}$1/" astra-toolbox/python/conda/astra-toolbox/meta.yaml


conda-build -m astra-toolbox/python/conda/libastra/linux_build_config.yaml astra-toolbox/python/conda/libastra

for i in 27 36 37 38; do
  conda-build -m astra-toolbox/python/conda/astra-toolbox/conda_build_config_py$i.yaml astra-toolbox/python/conda/astra-toolbox
done

cp /root/miniconda3/conda-bld/linux-64/*astra* /out
