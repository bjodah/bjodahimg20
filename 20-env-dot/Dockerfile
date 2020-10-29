FROM bjodah/bjodahimg20dev:2.1.0

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
(require 'lsp-javascript)\
(let ((client (gethash 'ts-ls lsp-clients)))\
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

RUN CC=clang-11 CXX=clang++-11 \
    CXXFLAGS="-std=c++17 $CXXFLAGS -stdlib=libc++ -I/opt/libcxx11-dbg/include -I/opt/libcxx11-dbg/include/c++/v1 -fno-omit-frame-pointer -fno-optimize-sibling-calls -Og -glldb -DHAVE_GCC_ABI_DEMANGLE=no" \
    LDFLAGS="$LDFLAGS -Wl,-rpath,/opt/libcxx11-dbg/lib -L/opt/libcxx11-dbg/lib -lc++abi" \
        /opt/get_symengine.sh 46090cfd20b92e73b6ddd8c203e3173b106adabb /opt/symengine-46090cf-msan Debug -DWITH_CPP14=ON -DWITH_COTIRE=OFF -DWITH_BFD=OFF -DWITH_SYMENGINE_RCP=ON -DINTEGER_CLASS=boostmp \
        -DBOOST_ROOT=/opt/boost_1_74_p

RUN \
        python3 -m pip install --use-feature=2020-resolver "pygments>=2.4.1" && \
        /opt/cpython-3.9-dbg/bin/python3 -m pip install --use-feature=2020-resolver "pygments>=2.4.1"
