#!/usr/bin/bash

# Set the package array.
reqs_arr=("bc" "beautifulsoup4" "binutils" "bzip2" "ca-certificates" "cliquer"
          "cmake" "curl" "cython" "ecl" "eclib-tools" "fflas-ffpack" "furo"
          "g++" "gcc" "gengetopt" "gfan" "gfortran" "glpk-utils" "gmp-ecm"
          "hatch-vcs" "importlib-resources" "ipykernel" "lcalc"
          "libatomic-ops-dev" "libboost-dev" "libbraiding-dev" "libbrial-dev"
          "libbrial-groebner-dev" "libbz2-dev" "libcdd-dev" "libcdd-tools"
          "libcliquer-dev" "libcurl4-openssl-dev" "libec-dev" "libecm-dev"
          "libffi-dev" "libflint-arb-dev" "libflint-dev" "libfplll-dev"
          "libfreetype-dev" "libgc-dev" "libgd-dev" "libgf2x-dev" "libgiac-dev"
          "libgivaro-dev" "libglpk-dev" "libgmp-dev" "libgsl-dev"
          "libhomfly-dev" "libiml-dev" "liblfunction-dev" "liblinbox-dev"
          "liblrcalc-dev" "liblzma-dev" "libm4ri-dev" "libm4rie-dev"
          "libmpc-dev" "libmpfi-dev" "libmpfr-dev" "libncurses5-dev"
          "libntl-dev" "libopenblas-dev" "libpari-dev" "libplanarity-dev"
          "libppl-dev" "libprimesieve-dev" "libpython3-dev" "libqhull-dev"
          "libreadline-dev" "librw-dev" "libsingular4-dev" "libsqlite3-dev"
          "libssl-dev" "libsuitesparse-dev" "libsymmetrica2-dev" "libz-dev"
          "libzmq3-dev" "m4" "make" "maxima" "maxima-sage" "meson"
          "meson-python" "nauty" "ninja-build" "openssl" "palp" "pari-doc"
          "pari-elldata" "pari-galdata" "pari-galpol" "pari-gp2c"
          "pari-seadata" "patch" "patchelf" "perl" "pkg-config" "planarity"
          "ppl-dev" "python-fastjsonschema" "python-hatch-fancy-pypi-readme"
          "python-tinycss2" "python3" "python3-babel" "python3-bleach"
          "python3-certifi" "python3-cvxopt" "python3-cycler"
          "python3-dateutil" "python3-decorator" "python3-distutils"
          "python3-gmpy2" "python3-idna" "python3-importlib-metadata"
          "python3-ipython" "python3-jinja2" "python3-jsonschema"
          "python3-matplotlib" "python3-mpmath" "python3-networkx"
          "python3-numpy" "python3-packaging" "python3-pandocfilters"
          "python3-pickleshare" "python3-pillow" "python3-pip"
          "python3-pkgconfig" "python3-pluggy" "python3-py" "python3-pygments"
          "python3-requests" "python3-scipy" "python3-setuptools"
          "python3-six" "python3-sympy" "python3-typing-extensions"
          "python3-tz" "python3-tzlocal" "python3-urllib3" "python3-venv"
          "python3-webencodings" "python3-wheel" "rpy2" "setuptools-scm"
          "singular" "singular-doc" "sphinx" "sphinx-basic-ng"
          "sphinxcontrib-websupport" "sqlite3" "sympow" "tachyon" "tar"
          "texinfo" "tox" "xcas" "xz-utils")

# Set the error array.
err_arr=()

# ************************************
# Create a string from a repeated char
# ************************************
repchr() {
    for chr in {1..80}
    do
        echo -n "$1"
    done
}

# **************************************
# Create an empty string of given length
# **************************************
spcstr() {
    for i in $(eval echo {1..$1})
    do
        echo -n " "
    done
}

# ***************************************
# Print a header into the terminal window
# ***************************************
header() {
    pkg=$1
    txtstr="Installation of package:"
    pkglen=${#pkg}
    bline=$(repchr "*")
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
