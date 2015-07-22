FROM ubuntu:14.04

RUN apt-get update -y && apt-get install -y software-properties-common
RUN add-apt-repository ppa:vbernat/haproxy-1.5
RUN apt-get update -y && apt-get install -y haproxy golang git mercurial supervisor curl && rm -rf /var/lib/apt/lists/*

ENV GOPATH /opt/go

RUN go get github.com/tools/godep
RUN go get -t github.com/smartystreets/goconvey

ADD . /opt/go/src/github.com/QubitProducts/bamboo
WORKDIR /opt/go/src/github.com/QubitProducts/bamboo
RUN /opt/go/bin/godep restore
RUN go build
RUN ln -s /opt/go/src/github.com/QubitProducts/bamboo /var/bamboo

RUN mkdir -p /run/haproxy

ADD builder/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD builder/run.sh /run.sh
RUN chmod +x /run.sh
RUN curl -L -q https://github.com/kelseyhightower/confd/releases/download/v0.7.1/confd-0.7.1-linux-amd64 -o /usr/local/bin/confd && chmod +x /usr/local/bin/confd
ADD builder/confd /etc/confd/

RUN mkdir -p /var/log/supervisor
VOLUME /var/log/supervisor

EXPOSE 81 80 8000

CMD /run.sh
