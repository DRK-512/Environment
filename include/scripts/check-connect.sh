#!/bin/sh
if curl -s -o /dev/null -w "%{http_code}" https://www.google.com | grep -q '200'; then
	  echo "Connected"
  else
	    echo "Disconnected"
fi
