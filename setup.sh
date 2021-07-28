#!/bin/bash

sources=sources
branch=compulab

do_nothing() {
	# Nothing to patch; source does not exist
	echo ${FUNCNAME[0]}
}

do_pass() {
	# Already patched and in the correct branch
	echo ${FUNCNAME[0]}
}

do_patch() {
	echo ${FUNCNAME[0]}
	git -C ${S} checkout ${branch} || \
		( git -C ${S} checkout -b ${branch} && git -C ${S} am $(pwd)/${P}/*.patch )
}

for f in patches/*; do
	dir=${sources}/$(basename ${f})
	[[ -d ${dir} ]] && key=$(git -C ${dir} branch | awk '(/^*/)&&($0=$2)') || key=nothing
	[[ ${key} != ${branch} ]] && key=patch || key=pass
	command=do_${key}
	command -v ${command} &>/dev/null && P=${f} S=${dir} ${command}
done
