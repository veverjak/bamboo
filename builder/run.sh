#!/bin/bash
confd -onetime -backend etcd -node=`cat /etc/ip`:4001 -prefix=$ETCD_BASEPATH
haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid
/usr/bin/supervisord
