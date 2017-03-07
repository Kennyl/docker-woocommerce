FROM wordpress:php7.0-fpm
MAINTAINER Kristian Østergaard Martensen <km@shipbeat.com>

ENV WOOCOMMERCE_VERSION latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends grep unzip wget \
    && html=`curl https://wordpress.org/plugins/woocommerce/` \
    && echo $html \
    && woofile=`echo $html | grep -Eo "\https://downloads.wordpress.org/plugin/woocommerce.[0-9]*[.][0-9]*[.][0-9]*[.]zip"` \
    && wget $woofile -O /tmp/temp.zip \
    && cd /usr/src/wordpress/wp-content/plugins \
    && unzip /tmp/temp.zip \
    && chown -R www-data:www-data /usr/src/wordpress/wp-content/plugins/woocommerce \
    && rm /tmp/temp.zip \
    && rm -rf /var/lib/apt/lists/*

# Download WordPress CLI
RUN curl -L "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar" > /usr/bin/wp && \
    chmod +x /usr/bin/wp

VOLUME ["/var/www/html", "/usr/src/wordpress"]
