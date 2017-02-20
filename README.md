## caddy-php56

Docker image for running php56 and Caddy (https://caddyserver.com) servers. This docker image is designed to be run as user www-data. So no root needed. Because of this it exposes port 8080. To run it on port 80 do something like this.

```docker run -d -p 80:8080 cloudmanic/caddy-php56```
