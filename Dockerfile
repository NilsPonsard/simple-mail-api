FROM debian:11

WORKDIR /app

# installation et configuration de postfix

RUN apt-get update && \
  echo "postfix postfix/mailname string example.com" | debconf-set-selections && \
  echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
  apt-get install postfix supervisor -y

COPY ./assets/postfix/conf/* /etc/postfix/ 
RUN update-rc.d -f postfix remove
RUN mkdir -p  /var/log/supervisor


# ajout de la config custom

RUN cp /etc/host.conf /etc/hosts /etc/nsswitch.conf /etc/resolv.conf /etc/services /var/spool/postfix/etc

EXPOSE 25

# USER 1000:1000

CMD [ "/bin/sh","-c", "postfix start-fg" ]