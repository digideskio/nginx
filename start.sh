#!/bin/bash
# Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and

# /etc/nginx-config-secret/env (stored in K8s Secret 'nginx-config-secret') holds:
# SERVER_NAME
# ENABLE_SSL
source /etc/nginx-config-secret/env

# Remove existing configs, if any
rm /etc/nginx/conf.d/*.conf

# Env says we're using SSL 
if [ -n "${ENABLE_SSL+1}" ] && [ "${ENABLE_SSL,,}" = "true" ]; then
  echo "Enabling SSL..."
  cp /usr/src/proxy_ssl.conf /etc/nginx/conf.d/proxy.conf
else
  # No SSL
  echo "Enabling *Without* SSL..."
  cp /usr/src/proxy_nossl.conf /etc/nginx/conf.d/proxy.conf
fi

# Insert env vars from /etc/nginx-config-secret/env
sed -i "s/{{SERVER_NAME}}/${SERVER_NAME}/g;" /etc/nginx/conf.d/proxy.conf

cat /etc/nginx/conf.d/proxy.conf

echo "Starting nginx..."
nginx -g 'daemon off;'
