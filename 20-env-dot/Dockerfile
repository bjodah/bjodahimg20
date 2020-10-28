FROM bjodah/bjodahimg20dev:2.0.0

ENV PATH=/usr/local/cargo/bin:$PATH CARGO_HOME=/usr/local/cargo RUSTUP_HOME=/usr/local/rustup

RUN \
    apt-get update && apt-get -y install --no-install-recommends libtool-bin && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
        cd /tmp && \
        curl -LOs http://hera.physchem.kth.se/~repo/10adbf0507a7d1c01b68c79c37ee19c484807cfd3ef1aeaf53f47cf52ea26eea/jdt-language-server-0.64.0-202010270209.tar.gz && \
        mkdir -p /opt/jdt && cd /opt/jdt && tar xzf /tmp/jdt-language-server-0.64.0-202010270209.tar.gz && \
        rm /tmp/jdt-language-server-0.64.0-202010270209.tar.gz
# https://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz && \

ENV CLASSPATH=/opt/jdt/plugins/*

RUN \
    mkdir /opt/bjodah-dotfiles && \
    curl -Ls https://github.com/bjodah/dotfiles/archive/master.tar.gz | tar xz -C /opt/bjodah-dotfiles --strip-components=1 && \
    rm -f ~/.emacs.d && \
    ln -s /opt/bjodah-dotfiles/defaults/.emacs.d ~/.emacs.d && \
    emacs -nw --batch --eval "(progn \
(load \"~/.emacs.d/init.el\") \
(let ((client (gethash 'jdtls lsp-clients)))\
  (lsp--install-server-internal client nil)\
  (while (lsp--client-download-in-progress? client)\
    (sit-for 1))))"
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

