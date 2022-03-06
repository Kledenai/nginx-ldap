FROM golang:1.13-alpine AS gobuild

COPY . /build/nginx-ldap

ENV CGO_ENABLED=0

RUN cd /build/nginx-ldap && \
	apk add --no-cache git && \
	go build -a -x -ldflags='-s -w -extldflags -static' -v -o /go/bin/nginx-ldap ./main

FROM scratch

LABEL maintainer="Kledenai Ashver <kledenai@khaneland.com.br>"

COPY --from=gobuild /go/bin/nginx-ldap /usr/local/bin/nginx-ldap

WORKDIR /tmp

VOLUME /etc/nginx-ldap

EXPOSE 5555

USER 65534:65534

CMD [ \
	"/usr/local/bin/nginx-ldap", \
	"--config", \
	"/etc/nginx-ldap/config.yaml" \
	]
