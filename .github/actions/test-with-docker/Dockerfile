FROM alpine:latest
RUN apk add -U curl git make unzip
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
