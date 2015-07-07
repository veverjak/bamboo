#!/bin/bash
STATSD_IP=$IP
STATSD_PORT=${STATSD_PORT-8125}
confd -onetime -backend etcd -node=`cat /etc/ip`:4001 -prefix=$ETCD_BASEPATH
haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid
/usr/bin/supervisord
