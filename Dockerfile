# Ubuntu based container for Prestashop
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
  apache2 \
  libapache2-mod-php \
  apache2-utils \
  unzip \
  sudo \
  nano \
  wget \
  && echo "mysql-server mysql-server/root_password password abc123" | sudo debconf-set-selections \
  && echo "mysql-server mysql-server/root_password_again password abc123" | sudo debconf-set-selections \
  && apt-get install -y mysql-server \
  php7.0-mysql php7.0 php7.0-mcrypt php7.0-xml php7.0-gd php7.0-dom php7.0-mbstring php7.0-curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 3306

VOLUME ["/var/www/html"]

COPY ./entrypoint.sh /
ENTRYPOINT ["./entrypoint.sh"]
