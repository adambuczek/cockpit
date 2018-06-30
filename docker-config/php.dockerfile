FROM php:7-fpm-alpine
VOLUME [ "/usr/share/nginx/html" ]
RUN apk add --no-cache \
		wget zip unzip \
		freetype \
		libpng \
		libjpeg-turbo \
		freetype-dev \
		libpng-dev \
		libjpeg-turbo-dev \
		sqlite \
	&& \
	docker-php-ext-configure gd \
		--with-gd \
		--with-freetype-dir=/usr/include/ \
		--with-png-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ && \
	NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
	docker-php-ext-install -j${NPROC} \
		gd \
		zip \
		opcache && \
	apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev && \
	chown -R www-data:www-data /usr/share/nginx/html
USER www-data