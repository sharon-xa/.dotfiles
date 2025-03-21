#!/bin/bash

docker run -d \
  --name pgadmin4 \
  -p 5050:80 \
  -e PGADMIN_DEFAULT_EMAIL=admin@example.com \
  -e PGADMIN_DEFAULT_PASSWORD=admin123 \
  -v pgadmin-data:/var/lib/pgadmin \
  dpage/pgadmin4
