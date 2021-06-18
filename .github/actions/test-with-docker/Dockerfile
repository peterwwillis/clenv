FROM alpine:latest
RUN apk add -U curl git make unzip tree file
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
