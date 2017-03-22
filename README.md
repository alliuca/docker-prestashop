# Docker Prestashop

This is more of a pet project I develop as I learn Docker. It is in no way a production ready setup, but a simple way to fire up a clean [PrestaShop](https://www.prestashop.com/) installation.

## Usage

* Inside `entrypoint.sh` set `PS_VERSION` and `SITE_NAME` variables
* Build the image by running `docker build -t="docker-prestashop" .`
* Run the container with `docker run -d -p 80:80 -p 3306:3306 -v /path/to/docker-prestashop:/var/www/html docker-prestashop`
* Visit the url defined in `SITE_NAME`
* You can optionally pass the flag `--no_install` at the end of the `docker run` to avoid installing a fresh instance of Prestashop. Just move your files into the /prestashop folder and import your database

### To do
[ ] - Use docker compose