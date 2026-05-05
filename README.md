# Python Hello World App

A simple Python Flask web application that is built into a Docker image and pushed to Docker Hub using GitHub Actions.

## Project Structure

```
├── app.py              # Flask application
├── requirements.txt    # Python dependencies
├── Dockerfile          # Docker container definition
├── VERSION             # App version for tagging
├── .gitignore          # Git ignore rules
├── .dockerignore       # Files to ignore in Docker build
├── docs/               # Documentation
└── README.md           # This file
```

## Application

**Python Flask App** (`app.py`): Simple hello world server
- `/` - Hello World endpoint

## Run locally

### Using Docker (Recommended)
```bash
docker build -t python-app .
docker run -p 5000:5000 python-app
```

Open http://localhost:5000 in your browser.

### Using Python (if available)
```bash
pip install -r requirements.txt
python app.py
```

## Versioning

The app version is defined in the `VERSION` file:

```
1.0.0
```

When you update the source code, update the VERSION file:

```
1.0.0 → 1.0.1 (patch fix)
1.0.0 → 1.1.0 (new feature)
1.0.0 → 2.0.0 (breaking change)
```

Push to `main`/`master` and the workflow will build and tag images with:
- `latest` - Latest version
- `v1.0.0` - Specific version tag
- `<commit-sha>` - Git commit hash

## GitHub Actions Docker push

Workflow builds and pushes the Docker image to Docker Hub on pushes to `main`/`master`.

### Required GitHub secrets

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

Images pushed as:
- `docker.io/${{ secrets.DOCKERHUB_USERNAME }}/python-app:latest`
- `docker.io/${{ secrets.DOCKERHUB_USERNAME }}/python-app:v1.0.0`
- `docker.io/${{ secrets.DOCKERHUB_USERNAME }}/python-app:<commit-sha>`
