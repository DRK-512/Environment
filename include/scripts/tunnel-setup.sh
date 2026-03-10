#!/bin/sh
sudo iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE && \
sudo iptables -A FORWARD -i $1 -o ens33 -j ACCEPT && \
sudo iptables -A FORWARD -i ens33 -o $1 -m state --state RELATED,ESTABLISHED -j ACCEPT
