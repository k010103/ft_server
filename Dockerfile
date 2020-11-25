FROM	debian:buster

RUN		apt-get update && apt-get upgrade && apt-get install -y \
		nginx \
		mariadb-server \
		php-mysql \
		php-mbstring \
		openssl \
		vim \
		wget \
		php7.3-fpm

COPY	./srcs/ft_server_run.sh ./
COPY	./srcs/default ./tmp
COPY	./srcs/wp-config.php ./tmp
COPY	./srcs/config.inc.php ./tmp

EXPOSE	80 443

CMD		bash ft_server_run.sh
