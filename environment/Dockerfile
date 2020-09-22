FROM ubuntu:focal-20200916
MAINTAINER Björn Dahlgren <bjodah@DELETEMEgmail.com>
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

# localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \

RUN apt-get update && \
    apt-get --quiet --assume-yes --no-install-recommends install locales && \
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    locale-gen en_US.UTF-8 && \
    echo "path-exclude /usr/share/doc/*" >/etc/dpkg/dpkg.cfg.d/01_nodoc && \
    echo "path-include /usr/share/doc/*/copyright" >>/etc/dpkg/dpkg.cfg.d/01_nodoc && \
    apt-get dist-upgrade -y \
    && \
    apt-get --assume-yes --no-install-recommends install wget curl rsync ssh gnupg2 time sudo expect parallel zip unzip git \
    libc-dev dpkg-dev make gfortran-10 gcc-10 g++-10 gcc-10-multilib g++-10-multilib libc6-dev-i386 mingw-w64 \
    wkhtmltopdf python2-dev \
    python3-dev python3-pip python3-setuptools python3-wheel \
    gdb valgrind scons libtool automake cmake flex bison binutils-dev libgoogle-perftools-dev lcov tree ninja-build cppcheck \
    libreadline6-dev libyaml-dev libicu-dev zlib1g-dev libbz2-dev liblzma-dev lzma lzma-dev zstd libzstd-dev libncurses5-dev \
    libsqlite3-dev libzmq3-dev libssl-dev libgdbm-dev tk-dev libxslt1-dev libxml2-dev libgit2-dev \
    liblapack-dev libopenmpi-dev libgmp-dev libmpfr-dev libgsl-dev coinor-libipopt-dev \
    petsc-dev trilinos-dev libsuitesparse-dev doxygen pandoc phantomjs wine-stable \
    libjpeg-dev libpng-dev libfreetype6-dev libfontconfig1 fonts-dejavu fonts-humor-sans imagemagick inkscape ffmpeg \
    xorg-dev xutils-dev libxrender1 freeglut3-dev libglfw3-dev libgl1-mesa-dev graphviz libgraphviz-dev \
    libsdl2-dev libsdl2-ttf-dev libsdl2-net-dev libsdl2-mixer-dev libsdl2-image-dev libsdl2-gfx-dev \
    texlive-latex-recommended texlive-science texlive-fonts-recommended \
    texlive-fonts-extra texlive-latex-extra texlive-lang-european lmodern texlive-bibtex-extra \
    texlive-xetex biber dot2tex dvipng latexmk rr gcovr tmux libjson-c-dev libwebsockets-dev hunspell less texinfo \
    libmagick++-dev libgif-dev libgnutls28-dev libacl1-dev gnuplot ripgrep \
    && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add - && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip

RUN \
    echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main" >>/etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main" >>/etc/apt/sources.list && \
    apt-get update && \
    apt-get --assume-yes --no-install-recommends install \
        clang-11 libllvm11 lldb-11 llvm-11 llvm-11-dev llvm-11-runtime clang-format-11 clang-tidy-11 libomp-11-dev && \
    python3 -m pip install libclang && python3 -c "from clang.cindex import TypeKind" && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip

RUN python3 -m pip install --upgrade-strategy=eager --upgrade pip setuptools wheel && \
    python3 -m pip install setuptools wheel virtualenv future appdirs pybind11 cython pycparser pycparser-fake-libc \
            flake8 pytest pytest-pep8 pytest-cov pytest-flakes pytest-flake8 pytest-xdist pytest-docstyle mypy black isort \
            numpy numpydoc scipy statsmodels sympy pandas matplotlib mpld3 jupyter ipython ipykernel \
            scikit-optimize joblib toolz param quantities pylatex bokeh mogli xarray periodictable ase numericalunits \
            tqdm pyparsing ipywidgets pulp holoviews[recommended] cclib scikit-image git-archive-all wurlitzer \
            sphinx sphinx_rtd_theme argh rstcheck check-manifest setuptools_scm mako bottle CherryPy Nikola[extras] nbsphinx \
            networkx pygraphviz plotly nbconvert asv trepan3k pudb epc python-language-server[all] jedi-language-server termplotlib && \
    python3 -m pip install --no-use-pep517 sqlalchemy && \
    python3 -m ipykernel install && \
    python3 -m jupyter nbextension enable --py widgetsnbextension && \
    echo "backend: Agg" > /etc/matplotlibrc && \
    mkdir -p /root/.config/matplotlib/ && cp /etc/matplotlibrc /root/.config/matplotlib/ && \
    python3 -c "import matplotlib.pyplot as plt" && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip

COPY scripts/*.* /opt/
RUN CC=gcc-10 /opt/get_sundials.sh 5.3.0 /opt/sundials-5.3.0-klu-lapack -DLAPACK_ENABLE=ON -DKLU_ENABLE=ON -DKLU_INCLUDE_DIR=/usr/include/suitesparse -DKLU_LIBRARY_DIR=/usr/lib/x86_64-linux-gnu -DSUNDIALS_INDEX_SIZE=32 && \
    CC=gcc-10 /opt/get_sundials.sh 5.3.0 /opt/sundials-5.3.0-noklu-nolapack-extended-int64 -DLAPACK_ENABLE=OFF -DKLU_ENABLE=OFF -DSUNDIALS_PRECISION:STRING="extended" -DSUNDIALS_INDEX_SIZE=64 && \
    /opt/get_sundials.sh 5.3.0 /opt/sundials-5.3.0-noklu-nolapack-single-int32 -DLAPACK_ENABLE=OFF -DKLU_ENABLE=OFF -DSUNDIALS_PRECISION:STRING="single" -DSUNDIALS_INDEX_SIZE=32 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip

RUN cd /tmp && curl -Ls https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.bz2 | tar xj  && \
    cp /opt/boost174-rational-gh41.patch . && patch -p1 <boost174-rational-gh41.patch && cd boost_1_74_0 && echo "using gcc : 10.0 : /usr/bin/g++-10 ; " >> tools/build/src/user-config.jam && CC=gcc-10 CXX=g++-10 ./bootstrap.sh --with-toolset=gcc --with-python=python3 --prefix=/opt/boost_1_74_p || cat bootstrap.log && ./b2 install && \
    rm -rf /tmp/*
