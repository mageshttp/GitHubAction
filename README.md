# Multi-App Repository

A monorepo containing Node.js and Python applications, built into Docker images and pushed to Docker Hub using GitHub Actions.

## Project Structure

```
├── apps/
│   ├── node-app/           # Node.js Express app
│   │   ├── config/         # App config
│   │   ├── src/            # Source code
│   │   ├── tests/          # Unit tests
│   │   ├── scripts/        # Build scripts
│   │   ├── Dockerfile      # Node app container
│   │   ├── package.json    # Dependencies
│   │   └── .dockerignore
│   └── python-app/         # Python Flask app
│       ├── app.py          # Flask app
│       ├── requirements.txt # Python deps
│       ├── Dockerfile      # Python app container
│       └── .gitignore
├── environments/           # Environment configs
│   ├── dev.json
│   ├── staging.json
│   └── prod.json
├── docs/                   # Documentation
├── .github/workflows/      # CI/CD pipelines
├── .gitignore
├── .dockerignore
└── README.md
```

## Applications

1. **Node.js App** (`apps/node-app/`): Express server with multiple routes
   - `/` - Hello World
   - `/api` - API endpoints
   - `/status` - Health check

2. **Python App** (`apps/python-app/`): Flask server
   - `/` - Hello World

## Environments

- `dev.json` - Development settings
- `staging.json` - Staging settings
- `prod.json` - Production settings

## Run locally

### Node.js App
```bash
cd apps/node-app
npm install
npm start
```
Open http://localhost:3000

### Python App
```bash
cd apps/python-app
pip install -r requirements.txt
python app.py
```
Open http://localhost:5000

## Development

### Node.js
```bash
cd apps/node-app
npm run dev  # Auto-reload
npm test     # Run tests
```

## Build with Docker locally

### Node.js
```bash
cd apps/node-app
docker build -t node-app .
docker run -p 3000:3000 node-app
```

### Python
```bash
cd apps/python-app
docker build -t python-app .
docker run -p 5000:5000 python-app
```

## Versioning

Each app has a `VERSION` file that defines the Docker image version:

- `apps/node-app/VERSION` - Node app version
- `apps/python-app/VERSION` - Python app version

When you update the source code, update the VERSION file:

```
1.0.0 → 1.0.1 (patch)
1.0.0 → 1.1.0 (minor)
1.0.0 → 2.0.0 (major)
```

Push to `main`/`master` and the workflow will build and tag images with:
- `latest` - Latest version
- `v1.0.0` - Specific version
- `<commit-sha>` - Git commit hash
