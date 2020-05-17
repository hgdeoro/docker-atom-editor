FROM ubuntu:20.10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    export LANG=en_US.utf8 && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        fakeroot \
        gconf2 \
        gconf-service \
        git \
        gvfs-bin \
        libasound2 \
        libcap2 \
        libgconf-2-4 \
        libgcrypt20 \
        libgtk2.0-0 \
        libgtk-3-0 \
        libnotify4 \
        libnss3 \
        libx11-xcb1 \
        libxkbfile1 \
        libxss1 \
        libxtst6 \
        libgl1-mesa-glx \
        libgl1-mesa-dri \
        policykit-1 \
        python \
        xdg-utils \
        jq && \
    rm -rf /var/lib/apt/lists/*

ENV LANG en_US.utf8

ARG ATOM_VERSION

# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c#gistcomment-2574561
RUN if [ -n "${ATOM_VERSION}" ] ; then \
        curl -L https://github.com/atom/atom/releases/download/${ATOM_VERSION}/atom-amd64.deb > /tmp/atom.deb && \
        dpkg -i /tmp/atom.deb && \
        rm /tmp/atom.deb \
    ; else \
        curl -L https://api.github.com/repos/atom/atom/releases/latest | \
            jq -r '.assets[] | select(.name == "atom-amd64.deb").browser_download_url' > download_url.txt && \
        curl -L $(cat download_url.txt) > /tmp/atom.deb && \
        dpkg -i /tmp/atom.deb && \
        rm download_url.txt /tmp/atom.deb \
    ; fi

ARG ATOM_USER_NAME
ARG ATOM_USER_ID
ARG ATOM_GROUP_NAME
ARG ATOM_GROUP_ID

# FIXME: this works, but is not very elegant :/
RUN id -un ${ATOM_USER_ID} && userdel $(id -un ${ATOM_USER_ID}) || true
RUN id -gn ${ATOM_GROUP_ID} && groupdel $(id -gn ${ATOM_GROUP_ID}) || true
RUN test -d /home/${ATOM_USER_NAME} && rm -rf /home/${ATOM_USER_NAME} || true
RUN groupadd \
        --gid ${ATOM_GROUP_ID} \
        ${ATOM_GROUP_NAME} && \
    useradd \
        --create-home \
        --home-dir /home/${ATOM_USER_NAME} \
        --uid ${ATOM_USER_ID} \
        --gid ${ATOM_GROUP_ID} \
        ${ATOM_USER_NAME}

CMD ["/usr/bin/atom","-f"]

USER ${ATOM_USER_NAME}
