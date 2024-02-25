#!/bin/bash

# Stop docker containers
docker stop flask robot

# Remove docker containers
docker rm flask robot

# Remove existing images
docker image remove flask robot -f

# Build Docker image for Flask
docker build -t flask -f DockerfileFlask .

# Run Docker container and capture the container ID
container_id=$(docker run --name flask -d flask)

# Retrieve IP address of the running container
container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id)
echo "Container1 ID: $container_id"
echo "Container IP: $container_ip"

# Build Docker image for Robot
docker build --build-arg ADDRESS=$container_ip -t robot -f DockerfileRobot .

# Run Docker tests
container_id2=$(docker run --name robot -d robot)
echo "Robot Container ID: $container_id2"

# Wait for the Robot tests container to exit
docker wait $container_id2

# Copy testResults
docker cp $container_id2:/app/testResults/ .

