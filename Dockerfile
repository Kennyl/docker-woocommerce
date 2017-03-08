FROM wordpress:php7.1-apache
#example :
#docker build --build-arg WOOCOMMERCE_VERSION=2.6.14 --build-arg STOREFRONT_VERSION=2.1.8 -t woo .

ARG WOOCOMMERCE_VERSION=0
ARG STOREFRONT_VERSION=0

ENV WOOCOMMERCE_VERSION $WOOCOMMERCE_VERSION
ENV STOREFRONT_VERSION $STOREFRONT_VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip wget

#Get Woocommerce when --build-arg WOOCOMMERCE_VERSION is not set
RUN if [ "$WOOCOMMERCE_VERSION" = "0" ]; then \
    html=`curl --silent https://wordpress.org/plugins/woocommerce/` \
    && woofile=`echo $html | grep -Eo "https://downloads.wordpress.org/plugin/woocommerce.[0-9]*[.][0-9]*[.][0-9]*[.]zip" | head -n1 ` \
    && WOOCOMMERCE_VERSION=`echo $woofile | sed -n 's/.*\([0-9]\{1,\}[.][0-9]\{1,\}[.][0-9]\{1,\}\).zip/\1/p' ` \
    && wget $woofile -O /tmp/temp.zip \
    && cd /usr/src/wordpress/wp-content/plugins \
    && unzip /tmp/temp.zip \
    && chown -R www-data:www-data /usr/src/wordpress/wp-content/plugins/woocommerce \
    ; fi

#Get Woocommerce use --build-arg, example, --build-arg WOOCOMMERCE_VERSION=2.6.14
RUN if [ "$WOOCOMMERCE_VERSION" != "0" ]; then \
    woofile=https://downloads.wordpress.org/plugin/woocommerce.$WOOCOMMERCE_VERSION.zip \
    && wget $woofile -O /tmp/temp.zip \
    && cd /usr/src/wordpress/wp-content/plugins \
    && unzip /tmp/temp.zip \
    && chown -R www-data:www-data /usr/src/wordpress/wp-content/plugins/woocommerce \
    ; fi

#Get Storefront when --build-arg STOREFRONT_VERSION is not set
RUN if [ "$STOREFRONT_VERSION" = "0" ]; then \
    html2=`curl --silent https://woocommerce.com/storefront/` \
    && themefile=`echo $html2 | grep -Eo "http://downloads.wordpress.org/theme/storefront.[0-9]*[.][0-9]*[.][0-9]*[.]zip" | head -n1 ` \
    && STOREFRONT_VERSION=`echo $themefile | sed -n 's/.*\([0-9]\{1,\}[.][0-9]\{1,\}[.][0-9]\{1,\}\).zip/\1/p' ` \
    && wget $themefile -O /tmp/temp2.zip \
    && cd /usr/src/wordpress/wp-content/themes \
    && unzip /tmp/temp2.zip \
    && chown -R www-data:www-data /usr/src/wordpress/wp-content/themes/storefront \
    ; fi

#Get Storefront use --build-arg, example, --build-arg STOREFRONT_VERSION=2.1.8
RUN if [ "$STOREFRONT_VERSION" != "0" ]; then \    
    themefile=http://downloads.wordpress.org/theme/storefront.$STOREFRONT_VERSION.zip \
    && wget $themefile -O /tmp/temp2.zip \
    && cd /usr/src/wordpress/wp-content/themes \
    && unzip /tmp/temp2.zip \
    && chown -R www-data:www-data /usr/src/wordpress/wp-content/themes/storefront \
    ; fi

#Housekeep
RUN rm -rf /var/lib/apt/lists/* \
    && rm /tmp/temp.zip \
    && rm /tmp/temp2.zip

# Download WordPress CLI
RUN curl -L "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar" > /usr/bin/wp && \
    chmod +x /usr/bin/wp

VOLUME ["/var/www/html", "/usr/src/wordpress"]
