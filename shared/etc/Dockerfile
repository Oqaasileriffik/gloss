FROM amd64/ubuntu:jammy as base
ENV LANG=C.UTF-8 \
	LC_ALL=C.UTF-8 \
	DEBIAN_FRONTEND=noninteractive \
	DEBCONF_NONINTERACTIVE_SEEN=true \
	PERL_UNICODE=SDA

ADD https://apertium.projectjj.com/apt/apertium-packaging.public.gpg /etc/apt/trusted.gpg.d/apertium.gpg
ADD https://apertium.projectjj.com/apt/apertium.pref /etc/apt/preferences.d/apertium.pref
RUN chmod 644 /etc/apt/trusted.gpg.d/apertium.gpg /etc/apt/preferences.d/apertium.pref && \
	echo "deb http://apertium.projectjj.com/apt/nightly jammy main" > /etc/apt/sources.list.d/apertium.list

RUN apt-get -qy update && \
	apt-get -qfy --no-install-recommends install apt-utils && \
	apt-get -qfy --no-install-recommends dist-upgrade && \
	apt-get -qfy --no-install-recommends install \
		cg3 \
		perl \
		libipc-run-perl \
		libnet-server-perl \
		libfile-homedir-perl libyaml-libyaml-perl libjson-perl libjson-xs-perl python3-regex \
		divvun-gramcheck hfst hfst-ospell \
	&& \
	apt-get -qy remove apt-utils && \
	apt-get -qfy autoremove && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	groupadd -r gloss && useradd --no-log-init -r -d /gloss -m -g gloss gloss

ADD . /
RUN chown -R root:root /usr/local && \
	chmod -R a-w /usr/local && \
	chown -R gloss:gloss /gloss && \
	find /gloss -type d -exec chmod a+rx "{}" \; && \
	find /gloss -type f -exec chmod a+r "{}" \;

FROM amd64/ubuntu:jammy
COPY --from=base / /

ENV LANG=C.UTF-8 \
	LC_ALL=C.UTF-8 \
	DEBIAN_FRONTEND=noninteractive \
	DEBCONF_NONINTERACTIVE_SEEN=true \
	PERL_UNICODE=SDA

USER gloss
RUN echo 'Oqaatsit' | ~/langtech/gloss/kal2dan/public.pl
RUN echo 'Oqaatsit' | ~/langtech/gloss/kal2eng/public.pl

ENV PORT=4000
ENV WHICH=kal2eng
EXPOSE $PORT
CMD /gloss/langtech/gloss/shared/bin/daemon.pl -c /gloss/langtech/gloss/$WHICH/public.pl -p $PORT
