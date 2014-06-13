# MapServer Suite container
#
# This image includes the following tools
# - MapServer (from Ubuntu 14.04)
# - MapCache (from Ubuntu 14.04)
#
# Version 0.1 

FROM phusion/baseimage:0.9.10
MAINTAINER Vincent Picavet, vincent.picavet@oslandia.com

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# We need UbuntuGIS for TinyOWS in Trusty
RUN apt-get update && \
    apt-get install add-apt-key software-properties-common -y && \
    add-apt-repository ppa:ubuntugis/ubuntugis-unstable -y && \
    add-apt-key -k keyserver.ubuntu.com 314DF160 && \
    apt-get update -yq

# Install MapServer and friends
RUN apt-get install -y \
    libapache2-mod-mapcache apache2 apache2-utils cgi-mapserver tinyows

# ---------- SETUP --------------


# Add Apache/MapServer daemon
RUN mkdir /etc/service/apache2
ADD apache2.sh /etc/service/apache2/run

# Add Apache Environment variables
RUN echo www-data > /etc/container_environment/APACHE_RUN_USER
RUN echo www-data > /etc/container_environment/APACHE_RUN_GROUP
RUN echo /var/log/apache2 > /etc/container_environment/APACHE_LOG_DIR

# Activate needed Apache modules 
RUN a2enmod mapcache && a2enmod cgi

# Add any Apache configuration here :
# ADD tinyows.conf /etc/apache2/sites-available/001-tinyows.conf
# RUN ln -s /etc/apache2/etc/apache2/sites-enabled/

# Expose  MapServer
EXPOSE 80

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/data", "/etc/mapserver", "/var/log/mapserver"]

# ---------- Final cleanup --------------
#
# Clean up APT when done.
USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

