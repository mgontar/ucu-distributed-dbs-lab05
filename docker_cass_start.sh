#!/bin/bash

reset

sudo docker stop cassandra1

sudo docker rm cassandra1

sudo docker run -v /home/mgontar/dev/data:/root/data --name cassandra1 -m 2g -d cassandra:latest

sudo docker inspect --format='{{ .NetworkSettings.IPAddress }}' cassandra1

sleep 1m

sudo docker exec -i -t cassandra1 cqlsh -f root/data/script_create_products.cql

sudo docker exec -i -t cassandra1 cqlsh -f root/data/script_create_orders.cql

sudo docker exec -i -t cassandra1 cqlsh
