#!/usr/bin/bash

# Create a string from a repeated char.
repeat() {
    for chr in {1..80}; do echo -n "$1"; done
}

# Create an empty string of given length.
spcstr() {
    for i in $(eval echo {1..$1}); do echo -n " "; done
}

# Print a header into the terminal window.
header() {
    pkg=$1
    txtstr="Installation of package:"
    pkglen=${#pkg}
    bline=$(repeat "*")
    spclen=$((80-25-pkglen))
    spcstr=$(spcstr ${spclen})
    echo -e "\e[44m${bline}\e[49m"
    echo -e "\e[44m${txtstr} ${pkg}${spcstr}\e[49m"
    echo -e "\e[44m${bline}\e[49m"
}

list=("beautifulsoup4" "cython" "furo" "hatch-vcs" "importlib-resources"
      "ipykernel" "meson-python" "fastjsonschema" "hatch-fancy-pypi-readme"
      "tinycss2" "rpy2" "setuptools-scm" "sphinx-basic-ng"
      "sphinxcontrib-websupport")

msgstr1="ERROR"
txtstr="Return code:"
msgstr0="SUCCESS"
# Run an loop over the array.
for pkg in "${list[@]}"
do
    header "${pkg}"
    pip3 install "${pkg}"
    retval=$?
    if [ ${retval} -eq 0 ]; then
        echo -e "\e[42m${txtstr} ${retval}: ${msgstr0}\e[49m"
    else
        echo -e "\e[41m${txtstr} ${retval}: ${msgstr1}\e[49m"
        err_arr+=("${pkg}")
    fi
    echo -e "\r"
done
