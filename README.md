# Docker Prestashop

This is more of a pet project I develop as I learn Docker. It is in no way a production ready setup, but a simple way to fire up a clean [PrestaShop](https://www.prestashop.com/) installation.

## Usage

* Inside `entrypoint.sh` set `PS_VERSION` and `SITE_NAME` variables
* Build the image by running `docker build -t="docker-prestashop" .`
* Run the container with `docker run -d -p 80:80 -p 3306:3306 -v $(pwd):/var/www/html docker-prestashop --name "prestashop-dev"`
* Visit the url defined in `SITE_NAME`
* You can optionally pass the flag `--no_install` at the end of the `docker run` to avoid installing a fresh instance of Prestashop. Just move your files into the /prestashop folder and import your database

## Stack
* Linux Ubuntu 16.04
* Apache 2.4.18
* MySQL 5.7
* PHP 7

### To do
- [ ] Use docker compose
- [x] Set correct permissions on PS folders (list [here](http://doc.prestashop.com/display/PS16/Installing+PrestaShop))
