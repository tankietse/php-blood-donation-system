FROM php:8.2-apache

# Cài extension cho MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copy toàn bộ mã nguồn vào container
COPY . /var/www/html/

# Phân quyền cho Apache
RUN chown -R www-data:www-data /var/www/html

# Bật mod_rewrite nếu bạn dùng .htaccess
RUN a2enmod rewrite

# Đặt ServerName để tránh cảnh báo
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Đặt DocumentRoot về /var/www/html/public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

EXPOSE 80