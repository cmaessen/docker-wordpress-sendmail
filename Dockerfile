FROM wordpress
 
MAINTAINER Collin Maessen “c.maessen@realskeptic.com”
 
# Installs sendmail
RUN apt-get update && apt-get install -q -y ssmtp mailutils && rm -rf /var/lib/apt/lists/*

# set up sendmail config, see http://linux.die.net/man/5/ssmtp.conf for options
RUN echo "hostname=localhost.localdomain" > /etc/ssmtp/ssmtp.conf
RUN echo "root=c.maessen@realskeptic.com" >> /etc/ssmtp/ssmtp.conf
RUN echo "mailhub=maildev" >> /etc/ssmtp/ssmtp.conf
# The above 'maildev' is the name you used for the link command
# in your docker-compose file or docker link command.
# Docker automatically adds that name in the hosts file
# of the container you're linking MailDev to.

# Set up php sendmail config
RUN echo "sendmail_path=sendmail -i -t" >> /usr/local/etc/php/conf.d/php-sendmail.ini

# Set up php config
RUN echo "upload_max_filesize = 15M" > /usr/local/etc/php/conf.d/realskeptic-php-ext.ini
RUN echo "post_max_size = 15M" >> /usr/local/etc/php/conf.d/realskeptic-php-ext.ini
# The above two files can be combined into one generic php ini file.
# Serves as an example on how you can create multiple ini files.

# Fully qualified domain name configuration for sendmail on localhost.
# Without this sendmail will not work.
# This must match the value for 'hostname' field that you set in ssmtp.conf.
RUN echo "localhost localhost.localdomain" >> /etc/hosts
