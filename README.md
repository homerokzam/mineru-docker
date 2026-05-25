# MinerU Docker

Docker image for running MinerU as a persistent API service.

## Build

Build directly on the cloud server. The base image is very large (>10 GB), so building locally is not recommended.

```bash
# Clone on the server
git clone <repo-url>
cd mineru-docker

# Build
docker build -t <your-username>/mineru:latest .

# Push to Docker Hub
docker login
docker push <your-username>/mineru:latest
```

## Run locally for development

```bash
docker run -d \
  --name mineru-dev \
  --shm-size 8g \
  -p 8000:8000 \
  --ipc=host \
  <your-username>/mineru:latest
```

Check health:

```bash
curl http://localhost:8000/health
```

## Run in production

Use one MinerU container shared by staging and production. Both WebAPI containers should point to:

```text
http://mineru-server:8000
```

```bash
docker network create mineru-network

docker stop mineru-server
docker rm mineru-server

docker run -d \
  --name mineru-server \
  --shm-size 8g \
  -p 30000:30000 -p 7860:7860 -p 8000:8000 -p 8002:8002 \
  --ipc=host \
  --network mineru-network \
  --restart unless-stopped \
  <your-username>/mineru:latest
```

## Pull from Docker Hub

```bash
docker pull <your-username>/mineru:latest
```
