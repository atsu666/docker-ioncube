# ioncube

Docker Image with Docker PHP + IonCube

* [IonCube](https://www.ioncube.com/)

## example

run docker-compose up

```
version: '2'
services:
    # mysql
    mysql:
        image: mysql:5.7
        ports:
            - "3306:3306"
        environment:
            MYSQL_ROOT_PASSWORD: root
    # proxy
    proxy:
        image: jwilder/nginx-proxy:latest
        volumes:
            - /var/run/docker.sock:/tmp/docker.sock:ro
        ports:
            - "80:80"
    # www
    www:
        image: atsu666/ioncube:7.2
        privileged: true
        volumes:
            - ./www:/var/www/html
            - /etc/localtime:/etc/localtime:ro
        links:
            - mysql:mysql
        environment:
            - VIRTUAL_HOST=example.dev
            - APACHE_DOCUMENT_ROOT=/var/www/html
```

