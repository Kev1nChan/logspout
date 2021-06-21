FROM golang:alpine3.12 as builder

COPY . /src

ENV GO111MODULE=on \
        GOPROXY=https://goproxy.cn

WORKDIR /src

RUN sed -i 's/dl-cdn.alpinelinux.org/repo.huaweicloud.com/g' /etc/apk/repositories \
    && apk add --update build-base ca-certificates \
    && go build -ldflags "-X main.Version=$(cat VERSION)" -o /bin/logspout

FROM alpine:3.12
ENTRYPOINT ["/bin/logspout"]
VOLUME /mnt/routes
EXPOSE 80

RUN sed -i 's/dl-cdn.alpinelinux.org/repo.huaweicloud.com/g' /etc/apk/repositories \
    && apk add --update ca-certificates

COPY --from=builder /bin/logspout /bin/logspout