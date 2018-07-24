FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 --branch release/1.8 https://github.com/blockchain/go-blockchain && \
  (cd go-blockchain && make net) && \
  cp go-blockchain/build/bin/net /net && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-blockchain && rm -rf /var/cache/apk/*

EXPOSE 55555
EXPOSE 44444

ENTRYPOINT ["/net"]
