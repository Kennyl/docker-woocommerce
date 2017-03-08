# 🐳 kennyl/docker-woocommerce

🐳Build File for Docker Woocommerce🐳
Essentially a fork from https://hub.docker.com/r/agrothberg/docker-woocommerce/ and https://hub.docker.com/r/invision70/woocommerce/ with some modifications to it.

you can build or own using Dockerfile 
For sepcific version
```$docker build --build-arg WOOCOMMERCE_VERSION=2.6.14 --build-arg STOREFRONT_VERSION=2.1.8 -t woo .```

For latest version
```$docker build -t woo .```

This container has to be linked with a mysql container, and can be started like this:
```
docker run --name woocom --link some-mysql:mysql -d kennyl/docker-woocommerce
```
But I'd say the best option is to start it with Docker Compose.
A docker-compose.yml like this one will do the trick:

```
webserver:
   container_name: woo_commerce
   image: kennyl/docker-woocommerce
   environment:
    WORDPRESS_DB_PASSWORD: example
   links:
    - dbserver:mysql
   ports:
    - 8080:80

dbserver:
   container_name: woo_mariadb
   image: mariadb
   environment:
    MYSQL_ROOT_PASSWORD: example
   ports:
    - 3307:3306
```
By then, you'll be able to access your freshly installed wordpress on port 8080.

curl http://$(docker-machine ip devbox):8080
You may want to check out https://hub.docker.com/_/wordpress/ for further documentation.
Have fun!

License [LICENSE](https://github.com/Kennyl/docker-woocommerce/blob/master/LICENSE)
