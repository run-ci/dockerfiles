# Dockerfiles

## Building

See the `package` task.

## Pushing

Currenty `run` doesn't support pushing to Docker hub so
the Docker push needs to be done using the Docker daemon
on the host.

```
docker push runci/$IMAGE_NAME:$IMAGE_TAG
```