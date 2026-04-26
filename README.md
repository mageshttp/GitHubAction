# Hello World Web App

A simple Node.js Express web application that is built into a Docker image and pushed to Docker Hub using GitHub Actions.

## Files included

- `app.js` - Express HTTP server
- `package.json` - dependencies and start script
- `Dockerfile` - container definition
- `.dockerignore` - ignore files for Docker build
- `.github/workflows/docker-publish.yml` - GitHub Actions workflow to build and push the image

## Run locally

```bash
npm install
npm start
```

Open http://localhost:3000 in your browser.

## Build with Docker locally

```bash
docker build -t hello-world-web .
docker run -p 3000:3000 hello-world-web
```

## GitHub Actions Docker push

This workflow pushes the Docker image to Docker Hub on every push to `main` or `master`.

### Required GitHub secrets

Set the following repository secrets:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

The image is pushed as:

- `docker.io/${{ secrets.DOCKERHUB_USERNAME }}/hello-world-web:latest`
- `docker.io/${{ secrets.DOCKERHUB_USERNAME }}/hello-world-web:${{ github.sha }}`
