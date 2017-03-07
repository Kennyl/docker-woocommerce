FROM wordpress:php7.1-fpm

ENV WOOCOMMERCE_VERSION latest
ENV STOREFRONT_VERSION latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip wget

#Get Woocommerce
RUN html=`curl --silent https://wordpress.org/plugins/woocommerce/` \
    && woofile=`echo $html | grep -Eo "https://downloads.wordpress.org/plugin/woocommerce.[0-9]*[.][0-9]*[.][0-9]*[.]zip" | head -n1 ` \
    && WOOCOMMERCE_VERSION=`echo $woofile | sed -n 's/.*\([0-9]\{1,\}[.][0-9]\{1,\}[.][0-9]\{1,\}\).zip/\1/p' ` \
    && wget $woofile -O /tmp/temp.zip \
    && cd /usr/src/wordpress/wp-content/plugins \
    && unzip /tmp/temp.zip \
    && chown -R www-data:www-data /usr/src/wordpress/wp-content/plugins/woocommerce \
    && rm /tmp/temp.zip

#Get Storefront
RUN html2=`curl --silent https://woocommerce.com/storefront/` \
    && themefile=`echo $html2 | grep -Eo "http://downloads.wordpress.org/theme/storefront.[0-9]*[.][0-9]*[.][0-9]*[.]zip" | head -n1 ` \
    && STOREFRONT_VERSION=`echo $themefile | sed -n 's/.*\([0-9]\{1,\}[.][0-9]\{1,\}[.][0-9]\{1,\}\).zip/\1/p' ` \
    && echo $STOREFRONT_VERSION \
    && wget $themefile -O /tmp/temp2.zip \
    && cd /usr/src/wordpress/wp-content/themes \
    && unzip /tmp/temp2.zip \
    && chown -R www-data:www-data /usr/src/wordpress/wp-content/themes/storefront \
    && rm /tmp/temp2.zip

#Clean apt
RUN rm -rf /var/lib/apt/lists/*

# Download WordPress CLI
RUN curl -L "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar" > /usr/bin/wp && \
    chmod +x /usr/bin/wp

VOLUME ["/var/www/html", "/usr/src/wordpress"]
