FROM debian:stretch
MAINTAINER Jan Mitoraj <jan@mitoraj.cz>
ENV w_directory /home/runner
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    wget \
    apt \
    gnupg2
RUN wget -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN wget -qO - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/apt.conf.d/yarn.list
RUN echo "deb https://deb.nodesource.com/node_11.x stretch main" > /etc/apt/apt.conf.d/nodejs.list
RUN apt-get update
RUN apt-get install -y \
    sudo \
    nodejs \
    yarn \
    curl \
    git-core \
    curl \
    nodejs \
    zlib1g-dev \
    build-essential \
    libssl1.0-dev \
    libreadline-dev \
    libyaml-dev \
    libsqlite3-dev \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    python3-software-properties \
    libffi-dev \
    mysql-client \
    postgresql-client \
    default-libmysqlclient-dev \
    libpq-dev \
    libmagickwand-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm-dev \
    imagemagick \
    libpq-dev \
    postgresql-client \
    wget \
    xfonts-base \
    xfonts-75dpi \
    pdftk
RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb -O /tmp/wkhtmltox-0.12.5.1_stretch_amd64.deb
RUN dpkg -i /tmp/wkhtmltox-0.12.5.1_stretch_amd64.deb
RUN rm /tmp/wkhtmltox-0.12.5.1_stretch_amd64.deb
RUN adduser --system runner
RUN echo "runner ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/runner
USER runner
WORKDIR $w_directory
RUN git clone https://github.com/rbenv/rbenv.git .rbenv
RUN git clone https://github.com/rbenv/ruby-build.git .rbenv/plugins/ruby-build
RUN cd .rbenv && src/configure && make -C src
ENV PATH ${w_directory}/.rbenv/bin:$PATH
ENV CONFIGURE_OPTS --disable-install-doc
RUN echo 'gem: --no-rdoc --no-ri --no-document' >> .gemrc
USER root
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN export APT_CACHE_DIR=`pwd`/apt-cache && mkdir -pv $APT_CACHE_DIR
RUN apt-get clean
USER runner
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
# Dropped support for Ruby 2.0.0 to 2.2.4
# RUN rbenv install -v 2.0.0-p648
# RUN rbenv install -v 2.1.5
# RUN rbenv install -v 2.2.0
# RUN rbenv install -v 2.2.4
RUN rbenv install -v 2.3.1
RUN rbenv install -v 2.4.0
RUN rbenv install -v 2.5.0
RUN rbenv install -v 2.5.1
RUN rbenv install -v 2.5.5
RUN rbenv install -v 2.6.0
ENV PATH ${w_directory}/.rbenv/shims:$PATH
# ENV RBENV_VERSION 2.0.0-p648
# RUN gem install bundler
# ENV RBENV_VERSION 2.1.5
# RUN gem install bundler
# ENV RBENV_VERSION 2.2.0
# RUN gem install bundler
# ENV RBENV_VERSION 2.2.4
# RUN gem install bundler
ENV RBENV_VERSION 2.3.1
RUN gem install bundler
ENV RBENV_VERSION 2.4.0
RUN gem install bundler
ENV RBENV_VERSION 2.5.0
RUN gem install bundler
ENV RBENV_VERSION 2.5.1
RUN gem install bundler
ENV RBENV_VERSION 2.5.5
RUN gem install bundler
ENV RBENV_VERSION 2.6.0
RUN gem install bundler
RUN ruby --version
