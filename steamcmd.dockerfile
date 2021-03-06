#!/usr/bin/env -S docker -D build --compress -t pvtmert/steamcmd -f

ARG OS_RELEASE=stable
FROM debian:${OS_RELEASE}

ARG OS_RELEASE
RUN echo "deb http://deb.debian.org/debian ${OS_RELEASE} non-free" \
	| tee -a /etc/apt/sources.list.d/non-free.list

RUN dpkg --add-architecture i386

RUN apt update
RUN yes 2 \
	| apt install -y \
		curl steamcmd

ENV PATH "/usr/games:$PATH"
ENV GAME "/home"

RUN steamcmd \
	+login anonymous \
	+force_install_dir "${GAME}" \
	+quit

ONBUILD RUN test -z "${APPID}" || steamcmd \
	+login anonymous \
	+force_install_dir "${GAME}" \
	+app_update "${APPID}" \
	+quit
