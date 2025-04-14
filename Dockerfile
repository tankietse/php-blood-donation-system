FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html/

# Install dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Create .env from example if it doesn't exist
RUN if [ ! -f .env ]; then cp .env.example .env || echo "No .env.example found"; fi

# Set permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html/storage || true
RUN chmod -R 755 /var/www/html/bootstrap/cache || true

# Enable Apache modules
RUN a2enmod rewrite

# Set Apache ServerName
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Set DocumentRoot to public folder
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Expose port 80
EXPOSE 80

CMD ["apache2-foreground"]