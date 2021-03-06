#!/usr/bin/env -S docker build --compress -t pvtmert/tmux:static -f

ARG BASE=debian:stable
FROM ${BASE} as build

RUN apt update
RUN apt install -y \
	automake bison build-essential clang \
	libevent-dev git pkg-config libncurses5-dev

ENV CC   clang
ENV DIR  repo
ENV REPO https://github.com/tmux/tmux.git

#VOLUME /data
WORKDIR /data

RUN git clone -q --progress --depth=1 "${REPO}" "${DIR}"
RUN (cd "${DIR}" && bash autogen.sh) && "${DIR}/configure" --enable-static
RUN make -C "." -j $(nproc)

FROM ${BASE}
COPY --from=build /data/tmux ./
ENTRYPOINT [ "./tmux" ]
CMD        [ ]
