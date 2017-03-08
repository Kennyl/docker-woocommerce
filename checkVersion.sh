#!/bin/bash
#need set at Environment Variable DOCKER-WOOCOMMERCE-TOKEN
#put this script into cron job
WOOCOMMERCE_VERSION=`curl --silent https://wordpress.org/plugins/woocommerce/ | grep -Eo "https://downloads.wordpress.org/plugin/woocommerce.[0-9]*[.][0-9]*[.][0-9]*[.]zip" | head -n1 | sed -n 's/.*\([0-9]\{1,\}[.][0-9]\{1,\}[.][0-9]\{1,\}\).zip/\1/p' `

STOREFRONT_VERSION=`curl --silent https://woocommerce.com/storefront/ |  grep -Eo "http://downloads.wordpress.org/theme/storefront.[0-9]*[.][0-9]*[.][0-9]*[.]zip" | head -n1 | sed -n 's/.*\([0-9]\{1,\}[.][0-9]\{1,\}[.][0-9]\{1,\}\).zip/\1/p' `

if [ ! -f WOOCOMMERCE_VERSION.latest ]; then
	echo $WOOCOMMERCE_VERSION > WOOCOMMERCE_VERSION.latest
	WOOCOMMERCE_CURRENT_VERSION=$WOOCOMMERCE_VERSION
else
    WOOCOMMERCE_VERSION=`cat WOOCOMMERCE_VERSION.latest`
fi

if [ ! -f STOREFRONT_VERSION.latest ]; then
	echo $STOREFRONT_VERSION > STOREFRONT_VERSION.latest
	STOREFRONT_CURRENT_VERSION=$STOREFRONT_VERSION
else
    STOREFRONT_VERSION=`cat STOREFRONT_VERSION.latest`
fi

if [ $WOOCOMMERCE_CURRENT_VERSION == $WOOCOMMERCE_VERSION ]; then
	echo "WooCommerce has no changes. Version : $WOOCOMMERCE_VERSION"
	if [ $STOREFRONT_CURRENT_VERSION == $STOREFRONT_VERSION ]; then
		echo "Storefront has not changees. Version : $STOREFRONT_VERSION"
	else
		echo "#kick web hook"
	 	curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/kennyl/docker-woocommerce/trigger/$DOCKER-WOOCOMMERCE-TOKEN/
		echo $WOOCOMMERCE_VERSION >  WOOCOMMERCE_VERSION.latest
		echo $STOREFRONT_VERSION >  STOREFRONT_VERSION.latest
	fi
else
	echo "#kick web hook"
	curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/kennyl/docker-woocommerce/trigger/$DOCKER-WOOCOMMERCE-TOKEN/	
	echo $WOOCOMMERCE_VERSION >  WOOCOMMERCE_VERSION.latest
	echo $STOREFRONT_VERSION >  STOREFRONT_VERSION.latest	
fi


