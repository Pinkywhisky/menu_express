FROM php:8 AS builder
# Install required tools
RUN apt update -y && apt install -y wget zip unzip
#install Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash && \
mv /root/.symfony/bin/symfony /usr/local/bin/symfony
#Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	php composer-setup.php && \
	php -r "unlink('composer-setup.php');" && \
	mv composer.phar /usr/local/bin/composer

WORKDIR /app/
COPY composer.json composer.lock /app/
#COPY . /app/
RUN composer install

FROM builder AS development
CMD ["symfony", "server:start", "--no-tls"]
EXPOSE 8000

# En production on a pas besoin de modifier les fichiers, juste de les récupérer
FROM builder AS production
COPY . /app/
CMD ["symfony", "server:start", "--no-tls"]
EXPOSE 8000