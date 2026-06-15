# 1. Use the official PHP image with Apache pre-installed
FROM php:8.2-apache

# 2. Install system dependencies and PHP extensions required by CodeIgniter 4
RUN apt-get update && apt-get install -y \
    libicu-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl mysqli pdo pdo_mysql

# 3. Enable Apache mod_rewrite (Crucial for CI4 URL routing)
RUN a2enmod rewrite

# 4. Change Apache document root to the CI4 /public folder
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 5. Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. Set the working directory inside the server
WORKDIR /var/www/html

# 7. Copy ONLY the Composer files from the backend folder first
COPY backend/composer.json backend/composer.lock ./

# 8. Install CodeIgniter dependencies (memory limit bypassed)
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev --optimize-autoloader

# 9. NOW copy the rest of your backend files into the container
# The dot at the end means "copy into the current WORKDIR (/var/www/html)"
COPY backend/ .

# 10. Force create all required CI4 writable subfolders
RUN mkdir -p writable/cache writable/logs writable/session writable/uploads

# 11. Give the Apache web user absolute ownership of those folders
RUN chown -R www-data:www-data writable/ public/

# 12. Set aggressive permissions so CI4 can freely read and write
RUN chmod -R 777 writable/

# 13. Start the Apache web server
CMD ["apache2-foreground"]