# Use the official Debian-based Apache image as the base
FROM httpd:latest

# Install necessary packages for Perl and Apache2 mod_perl
RUN apt-get update \
    && apt-get install -y --no-install-recommends libapache2-mod-perl2 perl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the custom Apache config from host to container
COPY apache-config.conf /usr/local/apache2/conf/apache-config.conf

# Include the custom config in the main Apache config
RUN echo "Include /usr/local/apache2/conf/apache-config.conf" >> /usr/local/apache2/conf/httpd.conf

WORKDIR /app
COPY ./app /app

RUN chmod +x /app/*.pl
RUN chmod +x /app/c/*.pl

EXPOSE 80
