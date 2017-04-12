FROM alpine
#FROM ubuntu:14.04
MAINTAINER Jesse Wei <web.jesse@gmail.com>

# basic flask environment
RUN apk add --no-cache bash git nginx uwsgi uwsgi-python py2-pip \
	&& pip2 install --upgrade pip \
	&& pip2 install flask
	
#RUN apt-get update && apt-get install -y \
#    python-pip python-dev uwsgi-plugin-python \
#    nginx supervisor
	
# application folder
ENV APP_DIR /app

# app dir
RUN mkdir ${APP_DIR} \
	&& chown -R nginx:nginx ${APP_DIR} \
	&& chmod 777 /run/ -R \
	&& chmod 777 /root/ -R
VOLUME [${APP_DIR}]
WORKDIR ${APP_DIR}

# expose web server port
# only http, for ssl use reverse proxy
EXPOSE 80

# copy config files into filesystem
COPY nginx.conf /etc/nginx/nginx.conf
COPY app.ini /app.ini
COPY entrypoint.sh /entrypoint.sh

# exectute start up script
ENTRYPOINT ["/entrypoint.sh"]
