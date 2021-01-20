FROM bjodah/bjodahimg20dev:2.1.1

ENV PATH=/usr/local/cargo/bin:$PATH CARGO_HOME=/usr/local/cargo RUSTUP_HOME=/usr/local/rustup

# RUN \
#         cd /tmp && \
#         curl -LOs http://hera.physchem.kth.se/~repo/10adbf0507a7d1c01b68c79c37ee19c484807cfd3ef1aeaf53f47cf52ea26eea/jdt-language-server-0.64.0-202010270209.tar.gz && \
#         mkdir -p /opt/jdt && cd /opt/jdt && tar xzf /tmp/jdt-language-server-0.64.0-202010270209.tar.gz && \
#         rm /tmp/jdt-language-server-0.64.0-202010270209.tar.gz

# https://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz && \
# ENV CLASSPATH=/opt/jdt/plugins/*

RUN \
    mkdir /opt/bjodah-dotfiles && \
    curl -Ls https://github.com/bjodah/dotfiles/archive/master.tar.gz | tar xz -C /opt/bjodah-dotfiles --strip-components=1 && \
    rm -f ~/.emacs.d && \
    ln -s /opt/bjodah-dotfiles/defaults/.emacs.d ~/.emacs.d && \
    emacs -nw --batch --eval "(progn \
(load \"~/.emacs.d/init.el\") \
(require 'jedi)\
(jedi:install-server)\
(require 'lsp-javascript)\
(let ((client (gethash 'ts-ls lsp-clients)))\
  (lsp--install-server-internal client nil)\
  (while (lsp--client-download-in-progress? client)\
    (sit-for 1)))\
(require 'lsp-bash)\
(let ((client (gethash 'bash-ls lsp-clients)))\
  (lsp--install-server-internal client nil)\
  (while (lsp--client-download-in-progress? client)\
    (sit-for 1)))\
(let ((client (gethash 'jdtls lsp-clients)))\
  (lsp--install-server-internal client nil)\
  (while (lsp--client-download-in-progress? client)\
    (sit-for 1)))\
)"


# (require 'lsp-mode)\
# (require 'typescript-mode)\
# (let ((client (gethash 'ts-ls lsp-clients)))\
#   (lsp--install-server-internal client nil)\
#   (while (lsp--client-download-in-progress? client)\
#     (sit-for 1)))\


    #emacs -nw --batch --eval "(progn (load \"~/.emacs.d/init.el\") (lsp--install-server-internal (gethash 'jdtls lsp-clients) nil))"

# RUN \
#     cat ~/.emacs.d/init.el && \
#     emacs -nw --batch --eval '(load "~/.emacs.d/init.el")'

# RUN \
#     emacs -nw --batch -l ~/.emacs.d/init.el --eval "(progn (require 'lsp-java) (lsp--install-server-internal (gethash 'jdtls lsp-clients) nil))"

#    emacs -nw --batch --eval '(load "~/.emacs.d/init.el")'
#    sed -i "s@(eval-when-compile (require 'use-package))@(require 'use-package)@g" ~/.emacs.d/init.el && \

RUN \
    chmod 666 -R /opt/bjodah-dotfiles && \
    find /opt/bjodah-dotfiles -type d | xargs chmod 777 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip

RUN \
    export CC=clang-11 CXX=clang++-11 && \
    export LLVM_ORG_VER=11.0.0 && \
    export LLVM_MAJOR=$(echo $LLVM_ORG_VER | cut -f1 -d.) && \
    curl -Ls https://github.com/llvm/llvm-project/archive/llvmorg-${LLVM_ORG_VER}.tar.gz | tar xz -C /tmp && \
    mkdir /tmp/build_libcxx && \
    cd /tmp/build_libcxx && \
    cmake -DCMAKE_BUILD_TYPE=Debug -DLLVM_CONFIG_PATH=/usr/bin/llvm-config-$LLVM_MAJOR -DCMAKE_INSTALL_PREFIX=/opt/libcxx${LLVM_MAJOR}-dbg /tmp/llvm-project-llvmorg-${LLVM_ORG_VER}/libcxx && \
    cmake --build . && \
    cmake --build . --target install && \
    mkdir /tmp/build_libcxxabi &&  \
    cd /tmp/build_libcxxabi &&  \
    cmake -DCMAKE_BUILD_TYPE=Debug -DLLVM_CONFIG_PATH=/usr/bin/llvm-config-${LLVM_MAJOR} -DCMAKE_INSTALL_PREFIX=/opt/libcxx${LLVM_MAJOR}-dbg -DLIBCXXABI_LIBCXX_INCLUDES=/opt/libcxx${LLVM_MAJOR}-dbg/include/c++/v1 -DLIBCXXABI_LIBCXX_PATH=/tmp/llvm-project-llvmorg-${LLVM_ORG_VER}/libcxx  /tmp/llvm-project-llvmorg-${LLVM_ORG_VER}/libcxxabi &&  \
    cmake --build .  && \
    cmake --build . --target install && \
    cp /tmp/llvm-project-llvmorg-${LLVM_ORG_VER}/libcxxabi/include/* /opt/libcxx${LLVM_MAJOR}-dbg/include/ && \
    rm -r /tmp/build_* /tmp/llvm-project*

RUN \
    python3 -m pip install --use-feature=2020-resolver "pygments>=2.4.1" tqdm && \
    /opt/cpython-3.9-dbg/bin/python3 -m pip install --use-feature=2020-resolver "pygments>=2.4.1" tqdm

RUN CC=clang-11 CXX=clang++-11 \
    CMAKE_PREFIX_PATH="/opt/boost_1_74_p:$CMAKE_PREFIX_PATH" \
    CXXFLAGS="-std=c++17 $CXXFLAGS -stdlib=libc++ -I/opt/libcxx11-dbg/include -I/opt/libcxx11-dbg/include/c++/v1 -fno-omit-frame-pointer -fno-optimize-sibling-calls -Og -glldb -DHAVE_GCC_ABI_DEMANGLE=no" \
    LDFLAGS="$LDFLAGS -Wl,-rpath,/opt/libcxx11-dbg/lib -L/opt/libcxx11-dbg/lib -lc++abi" \
        /opt/get_symengine.sh 46090cfd20b92e73b6ddd8c203e3173b106adabb /opt/symengine-46090cf-libcxx Debug -DWITH_COTIRE=OFF -DWITH_BFD=OFF -DWITH_SYMENGINE_RCP=ON -DINTEGER_CLASS=boostmp

RUN \
    mkdir /src && \
    curl -Ls https://github.com/LLNL/sundials/releases/download/v5.4.0/sundials-5.4.0.tar.gz | tar xz -C /src && \
    cd /src/sundials-5.4.0 && \
    CC=gcc-10 cmake -S . -B /tmp/build-sund-5.4.0-dbg \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -DCMAKE_INSTALL_PREFIX:PATH="/opt/sundials-5.4.0-noklu-nolapack-dbg" \
        -DCMAKE_BUILD_TYPE:STRING="Debug" \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DBUILD_STATIC_LIBS:BOOL=OFF \
        -DEXAMPLES_ENABLE_C:BOOL=OFF \
        -DEXAMPLES_INSTALL:BOOL=OFF \
        -DOPENMP_ENABLE:BOOL=OFF \
        -DLAPACK_ENABLE=OFF \
        -DKLU_ENABLE=OFF \
        -DSUNDIALS_INDEX_SIZE=32 && \
    cmake --build /tmp/build-sund-5.4.0-dbg --target install -- -j 4


RUN \
        curl -Ls https://github.com/LLNL/sundials/releases/download/v5.6.1/sundials-5.6.1.tar.gz | tar xz -C /src && \
        cd /src/sundials-5.6.1 && \
        mkdir -p /build && \
        CC=gcc-10 cmake \
        -S . \
        -B /build/sund-5.6.1-dbg \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -DCMAKE_INSTALL_PREFIX:PATH="/opt/sundials-5.6.1-noklu-nolapack-dbg" \
        -DCMAKE_BUILD_TYPE:STRING="Debug" \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DBUILD_STATIC_LIBS:BOOL=OFF \
        -DEXAMPLES_ENABLE_C:BOOL=OFF \
        -DEXAMPLES_INSTALL:BOOL=OFF \
        -DOPENMP_ENABLE:BOOL=OFF \
        -DLAPACK_ENABLE=OFF \
        -DKLU_ENABLE=OFF \
        -DSUNDIALS_INDEX_SIZE=32 && \
        cmake --build /build/sund-5.6.1-dbg --target install -- -j 4 && \
        cp /build/sund-5.6.1-dbg/compile_commands.json /opt/sundials-5.6.1-dbg && \
        CC=gcc-10 cmake \
        -S . \
        -B /build/sund-5.6.1-klu-lapack \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -DCMAKE_INSTALL_PREFIX:PATH="/opt/sundials-5.6.1-klu-lapack" \
        -DCMAKE_BUILD_TYPE:STRING="Release" \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DBUILD_STATIC_LIBS:BOOL=OFF \
        -DEXAMPLES_ENABLE_C:BOOL=OFF \
        -DEXAMPLES_INSTALL:BOOL=OFF \
        -DOPENMP_ENABLE:BOOL=OFF \
        -DLAPACK_ENABLE=ON \
        -DKLU_ENABLE=ON \
        -DKLU_INCLUDE_DIR=/usr/include/suitesparse \
        -DKLU_LIBRARY_DIR=/usr/lib/x86_64-linux-gnu \
        -DSUNDIALS_INDEX_SIZE=32 && \
        cmake --build /build/sund-5.6.1-klu-lapack --target install -- -j 4 && \
        cp /build/sund-5.6.1-klu-lapack/compile_commands.json /opt/sundials-5.6.1-klu-lapack && \
        CC=gcc-10 cmake \
        -S . \
        -B /build/sund-5.6.1-noklu-nolapack-extended-int64 \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -DCMAKE_INSTALL_PREFIX:PATH="/opt/sundials-5.6.1-noklu-nolapack-extended-int64" \
        -DCMAKE_BUILD_TYPE:STRING="Release" \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DBUILD_STATIC_LIBS:BOOL=OFF \
        -DEXAMPLES_ENABLE_C:BOOL=OFF \
        -DEXAMPLES_INSTALL:BOOL=OFF \
        -DOPENMP_ENABLE:BOOL=OFF \
        -DLAPACK_ENABLE=OFF \
        -DKLU_ENABLE=OFF \
        -DSUNDIALS_PRECISION:STRING="extended" \
        -DSUNDIALS_INDEX_SIZE=64 && \
        cmake --build /build/sund-5.6.1-noklu-nolapack-extended-int64 --target install -- -j 4 && \
        cp /build/sund-5.6.1-noklu-nolapack-extended-int64/compile_commands.json /opt/sundials-5.6.1-noklu-nolapack-extended-int64 && \
        CC=gcc-10 cmake \
        -S . \
        -B /build/sund-5.6.1-noklu-nolapack-single-int32 \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -DCMAKE_INSTALL_PREFIX:PATH="/opt/sundials-5.6.1-noklu-nolapack-single-int32" \
        -DCMAKE_BUILD_TYPE:STRING="Release" \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DBUILD_STATIC_LIBS:BOOL=OFF \
        -DEXAMPLES_ENABLE_C:BOOL=OFF \
        -DEXAMPLES_INSTALL:BOOL=OFF \
        -DOPENMP_ENABLE:BOOL=OFF \
        -DLAPACK_ENABLE=OFF \
        -DKLU_ENABLE=OFF \
        -DSUNDIALS_PRECISION:STRING="single" \
        -DSUNDIALS_INDEX_SIZE=32 && \
        cmake --build /build/sund-5.6.1-noklu-nolapack-single-int32 --target install -- -j 4 && \
        cp /build/sund-5.6.1-noklu-nolapack-single-int32/compile_commands.json /opt/sundials-5.6.1-noklu-nolapack-single-int32 && \
        CC=clang-11 CFLAGS="-fsanitize=memory -fsanitize-memory-track-origins=2 -fno-omit-frame-pointer -fno-optimize-sibling-calls -O1" cmake \
        -S . \
        -B /build/sund-5.6.1-msan \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
        -DCMAKE_INSTALL_PREFIX:PATH="/opt/sundials-5.6.1-msan" \
        -DCMAKE_BUILD_TYPE:STRING="Debug" \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DBUILD_STATIC_LIBS:BOOL=OFF \
        -DEXAMPLES_ENABLE_C:BOOL=OFF \
        -DEXAMPLES_INSTALL:BOOL=OFF \
        -DOPENMP_ENABLE:BOOL=OFF \
        -DLAPACK_ENABLE=OFF \
        -DKLU_ENABLE=OFF \
        -DSUNDIALS_INDEX_SIZE=32 && \
        cmake --build /build/sund-5.6.1-msan --target install -- -j 4 && \
        cp /build/sund-5.6.1-msan/compile_commands.json /opt/sundials-5.6.1-msan && \
        rm -r /build/sund-*

RUN \
        wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB && \
        apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB && \
        rm GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB && \
        echo "deb https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list && \
        apt-get update && \
        apt-get -y install intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic intel-oneapi-compiler-fortran && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
        curl -Ls https://github.com/ispc/ispc/releases/download/v1.15.0/ispc-v1.15.0-linux.tar.gz | tar xz -C /opt && \
        /opt/ispc-v1.15.0-linux/bin/ispc --version

# RUN \
#         curl -Ls https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh >/tmp/miniconda3.sh && \
#         bash /tmp/miniconda3.sh -b -p /opt/miniconda3 && rm /tmp/miniconda3.sh && \
#         /opt/miniconda3/bin/conda create -n cling && \
#         bash -c "source /opt/miniconda3/bin/activate cling && /opt/miniconda3/bin/conda install xeus-cling -c conda-forge"
