FROM ubuntu:focal
MAINTAINER Björn Dahlgren <bjodah@DELETEMEgmail.com>
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get update && \
    apt-get --quiet --assume-yes --no-install-recommends install locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    echo "path-exclude /usr/share/doc/*" >/etc/dpkg/dpkg.cfg.d/01_nodoc && \
    echo "path-include /usr/share/doc/*/copyright" >>/etc/dpkg/dpkg.cfg.d/01_nodoc && \
    apt-get upgrade -y \
    && \
    apt-get --assume-yes --no-install-recommends install wget curl rsync ssh gnupg2 time sudo expect parallel zip unzip git \
    build-essential gfortran-10 gcc-10 g++-10 gcc-10-multilib g++-10-multilib libc6-dev-i386 mingw-w64 \
    clang-10 libllvm10 lldb-10 llvm-10 llvm-10-dev llvm-10-runtime clang-format-10 clang-tidy-10 \
    python3-clang-10 libomp-10-dev \    
    python3-dev python3-pip python3-setuptools python3-wheel \
    gdb valgrind scons libtool automake cmake flex bison binutils-dev libgoogle-perftools-dev lcov tree ninja-build cppcheck \
    libreadline6-dev libyaml-dev libicu-dev zlib1g-dev libbz2-dev liblzma-dev lzma lzma-dev zstd libzstd-dev libncurses5-dev libsqlite3-dev libzmq3-dev \
    libssl-dev libgdbm-dev tk-dev libxslt1-dev libxml2-dev libgit2-dev emacs-nox \
    liblapack-dev libopenmpi-dev libgmp-dev libmpfr-dev libgsl-dev coinor-libipopt-dev \
    petsc-dev trilinos-dev libsuitesparse-dev doxygen pandoc phantomjs wine-stable \
    libjpeg-dev libpng-dev libfreetype6-dev libfontconfig1 fonts-dejavu fonts-humor-sans imagemagick inkscape ffmpeg \
    xorg-dev xutils-dev libxrender1 freeglut3-dev libglfw3-dev libgl1-mesa-dev graphviz libgraphviz-dev \
    libsdl2-dev libsdl2-ttf-dev libsdl2-net-dev libsdl2-mixer-dev libsdl2-image-dev libsdl2-gfx-dev \
    texlive-latex-recommended texlive-science texlive-fonts-recommended \
    texlive-fonts-extra texlive-latex-extra texlive-lang-european lmodern texlive-bibtex-extra \
    texlive-xetex biber dot2tex dvipng latexmk \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip
    
RUN python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install setuptools wheel virtualenv future appdirs pybind11 cython pycparser \
            flake8 pytest pytest-pep8 pytest-cov pytest-flakes pytest-flake8 pytest-xdist pytest-docstyle \
            numpy numpydoc scipy statsmodels "sympy>=1.4" pandas matplotlib mpld3 jupyter ipython ipykernel \
            scikit-optimize joblib toolz param quantities pylatex bokeh mogli xarray periodictable ase numericalunits \
            tqdm pyparsing ipywidgets pulp holoviews[recommended] cclib scikit-image git-archive-all wurlitzer \
            sphinx sphinx_rtd_theme argh rstcheck check-manifest setuptools_scm mako bottle sqlalchemy CherryPy Nikola[extras] nbsphinx \
            networkx pygraphviz plotly nbconvert https://github.com/airspeed-velocity/asv/archive/master.tar.gz && \
    python3 -m ipykernel install && \
    python3 -m jupyter nbextension enable --py widgetsnbextension && \
    echo "backend: Agg" > /etc/matplotlibrc && \
    mkdir -p /root/.config/matplotlib/ && cp /etc/matplotlibrc /root/.config/matplotlib/ && \
    python3 -c "import matplotlib.pyplot as plt" && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip

COPY scripts/*.* /opt/
RUN CC=gcc-10 /opt/get_sundials.sh 5.1.0 /opt/sundials-5.1.0-klu-lapack -DLAPACK_ENABLE=ON -DKLU_ENABLE=ON -DKLU_INCLUDE_DIR=/usr/include/suitesparse -DKLU_LIBRARY_DIR=/usr/lib/x86_64-linux-gnu -DSUNDIALS_INDEX_SIZE=32 && \
    CC=gcc-10 /opt/get_sundials.sh 5.1.0 /opt/sundials-5.1.0-noklu-nolapack-extended-int64 -DLAPACK_ENABLE=OFF -DKLU_ENABLE=OFF -DSUNDIALS_PRECISION:STRING="extended" -DSUNDIALS_INDEX_SIZE=64 && \
    /opt/get_sundials.sh 5.1.0 /opt/sundials-5.1.0-noklu-nolapack-single-int32 -DLAPACK_ENABLE=OFF -DKLU_ENABLE=OFF -DSUNDIALS_PRECISION:STRING="single" -DSUNDIALS_INDEX_SIZE=32 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip
RUN cd /tmp && curl -Ls https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2 | tar xj  && \
    cp /opt/boost172-rational-gh41.patch . && patch -p1 <boost172-rational-gh41.patch && cd boost_1_72_0 && echo "using gcc : 8.3 : /usr/bin/g++-10 ; " >> tools/build/src/user-config.jam && ./bootstrap.sh --with-python=python3 --prefix=/opt/boost_1_72_p && ./b2 install && \
    rm -rf /tmp/*


    # wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add - && \
    # echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main" | tee -a /etc/apt/sources.list && \
    # apt-get update && apt-get --quiet --assume-yes --no-install-recommends install \
    #     clang-11 libllvm11 lldb-11 llvm-11 llvm-11-dev llvm-11-runtime clang-format-11 \
    #     python-clang-11 libomp-11-dev && \

