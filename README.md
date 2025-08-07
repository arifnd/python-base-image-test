# Python Base Image Test

This repository contains experimental results to determine the most suitable Python base image for a production environment. It compares the performance and size of three different base images:

- `python:3.12-alpine`
- `python:3.12-slim`
- `python:3.12` (full)

## Key Features

- **Multi-stage builds**: Reduces final image size by separating build and runtime stages.
- **Bytecode enabled**: Optionally enables `.pyc` file generation to improve Python startup time.
- **Security testing**: Basic security checks are included to identify vulnerabilities in the container image.

## How to Build & Run

Before using this repository, make sure Docker is installed on your system. Then run the following commands in sequence:

### Build Docker Image

```bash
./build.sh
```

### Run Docker Compose

```bash
docker compose up -d
```

### Run Database Migration

```bash
./migrate.sh
```

### Run Benchmark

This benchmarks the running container using `wrk` and saves the results in `wrk_results.csv`.

```bash
./benchmark.sh
```

## Image Size Comparison

| Base Image | Multi-Stage Build | Bytecode Enabled | Image Size | Build Time |
| ---------- | ----------------- | ---------------- | ---------- | ---------- |
| alpine     | ❌                 | ✅                | 100.71 MB  | 3s         |
| alpine     | ✅                 | ✅                | 87.05 MB   | 29s        |
| alpine     | ✅                 | ❌                | 87.05 MB   | 26s        |
| slim       | ❌                 | ✅                | 171.35 MB  | 2s         |
| slim       | ✅                 | ✅                | 157.71 MB  | 22s        |
| slim       | ✅                 | ❌                | 157.71 MB  | 20s        |
| full       | ❌                 | ✅                | 1015.89 MB | 2s         |

ℹ️ Enabling Python bytecode (.pyc files) may improve performance by avoiding source recompilation at runtime. 

ℹ️ Multi-stage builds significantly reduce image size without sacrificing runtime performance.

## Performance Benchmark

The benchmark is based on the average of three test runs using `wrk`, configured with 2 threads, 10 concurrent connections, and a duration of 10 seconds per test.

## Dependencies

- Flask
- Flask-SQLAlchemy
- Flask-Migrate
- Gunicorn
- Psycopg2-binary

## License

This project is open source and available under the terms of the [MIT License](LICENSE).

---

Thank you for checking out this repository!  
Feel free to fork, contribute, or open an issue if you have feedback or suggestions.