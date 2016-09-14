FROM ubuntu:trusty
MAINTAINER maxcrc GmbH <info@maxcrfc.de>

RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
	    git \
	    ca-certificates \
            curl \
            node-less \
            node-clean-css \
	    libjpeg-dev \
	    libfreetype6-dev \
	    zlib1g-dev \
	    libpng12-dev \
	    libsasl2-dev \
	    libldap2-dev \
	    libssl-dev \
	    libxml2-dev \
	    libxslt1-dev \
	    python-dev \
            python-pyinotify \
            python-renderpm \
            python-support \
	    python-pip \
	    build-essential \
	    autoconf \
	    python-dev \
	    libxml2 \
	    libpq-dev \
	    freetds-dev\
	    telnet \
	    mc \
        && curl -o wkhtmltox.deb -SL http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

COPY ./requirements.txt /etc/odoo/

RUN pip install -r /etc/odoo/requirements.txt

RUN useradd -m odoo

COPY ./openerp-server.conf /etc/odoo/

RUN chown -R odoo /etc/odoo/

RUN mkdir -p /mnt/extra-addons && chown -R odoo /mnt/extra-addons

RUN mkdir -p /var/lib/odoo && chown -R odoo /var/lib/odoo

VOLUME ["/opt/odoo", "/var/lib/odoo", "/mnt/extra-addons", "/etc/odoo"]

EXPOSE 8069 8071

ENV OPENERP_SERVER /etc/odoo/openerp-server.conf

USER odoo

ENTRYPOINT ["/opt/odoo/odoo.py"]