FROM bjodah/bjodahimg20dev:2.0.0

RUN \
    mkdir /opt/bjodah-dotfiles && \
    curl -Ls https://github.com/bjodah/dotfiles/archive/master.tar.gz | tar xz -C /opt/bjodah-dotfiles --strip-components=1 && \
    rm -f ~/.emacs.d && \
    ln -s /opt/bjodah-dotfiles/defaults/.emacs.d ~/.emacs.d && \
    emacs -nw --batch --eval '(load "~/.emacs.d/init.el")' && \
    chmod 666 -R /opt/bjodah-dotfiles && \
    find /opt/bjodah-dotfiles -type d | xargs chmod 777 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip

ENV PATH=/usr/local/cargo/bin:$PATH CARGO_HOME=/usr/local/cargo RUSTUP_HOME=/usr/local/rustup
