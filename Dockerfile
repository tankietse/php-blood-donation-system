FROM php:8.2-apache

# Cài extension cho MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copy toàn bộ mã nguồn vào container
COPY . /var/www/html/

# Phân quyền cho Apache
RUN chown -R www-data:www-data /var/www/html

# Bật mod_rewrite nếu bạn dùng .htaccess
RUN a2enmod rewrite

EXPOSE 80