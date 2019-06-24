!#/usr/bin/env bash

for container in client server worker; do
    docker image build -t docktordick/multi-${container}:latest -t docktordick/multi-${container}:$SHA -f ./${container}/Dockerfile ./${container}
    docker push docktordick/multi-${container}:latest
    # Every tag must be pushed separately to docker hub
    docker push docktordick/multi-${container}:$SHA
done

kubectl apply -f k8s

# Imperatively set latest images on each deployment
for container in client server worker; do
    kubectl set image deployments/${container}-deployment ${container}=docktordick/multi-${container}:$SHA
done
