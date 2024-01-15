#!/usr/bin/bash

reqs_arr=("4ti2" "clang" "coinor-cbc" "coinor-libcbc-dev" "graphviz" "libfile-slurp-perl" "libgraphviz-dev" "libigraph-dev" "libisl-dev" "libjson-perl" "libmongodb-perl" "libnauty-dev" "libperl-dev" "libpolymake-dev" "libsvg-perl" "libtbb-dev" "libterm-readkey-perl" "libterm-readline-gnu-perl" "libxml-libxslt-perl" "libxml-writer-perl" "libxml2-dev" "lrslib" "pari-gp2c" "pdf2svg" "polymake" "python3-texttable" "r-base-dev" "r-cran-lattice")

# Set the error array.
err_arr=()

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

# *********************************
# Function installation of packages
# *********************************
pkg_install() {
    msgstr1="ERROR"
    txtstr="Return code:"
    msgstr0="SUCCESS"
    # Run an loop over the array.
    for pkg in "${reqs_arr[@]}"
    do
        header "${pkg}"
        apt-get install -y "${pkg}"
        retval=$?
        if [ ${retval} -eq 0 ]; then
            echo -e "\e[42m${txtstr} ${retval}: ${msgstr0}\e[49m"
        else
            echo -e "\e[41m${txtstr} ${retval}: ${msgstr1}\e[49m"
            err_arr+=("${pkg}")
        fi
        echo -e "\r"
    done
}

# ***********************************
# Function print failed installations
# ***********************************
print_missing() {
    echo -e "Failed installation:"
    echo -e "--------------------\n"
    if (( ${#err_arr[@]} == 0 )); then
        echo -e "NONE"
    else
        for pkg in "${err_arr[@]}"
        do
            echo -e "${pkg}"
        done
    fi
}

# Run the main function.
pkg_install
print_missing

