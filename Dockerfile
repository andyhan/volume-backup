FROM alpine:latest

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk update && apk upgrade \
    && apk add --update --no-cache \
        xz \
        zstd \
    && rm -rf /var/cache/apk/*
    
COPY ./entrypoint.sh /

RUN mkdir -p /var/spool/cron/crontabs && chmod 755 /entrypoint.sh && mkdir /backup && chown 1000:1000 /backup

VOLUME /backup

CMD /entrypoint.sh
