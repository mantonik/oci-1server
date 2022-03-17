#!/bin/bash
. /etc/profile 
/bin/certbot renew --quiet --post-hook "service nginx restart"
