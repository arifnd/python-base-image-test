# Python Base Image Test

<a href="https://studio.firebase.google.com/import?url=https%3A%2F%2Fgithub.com%2Farifnd%2Fpython-base-image-test">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://cdn.firebasestudio.dev/btn/try_light_32.svg">
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://cdn.firebasestudio.dev/btn/try_dark_32.svg">
    <img
      height="32"
      alt="Try in Firebase Studio"
      src="https://cdn.firebasestudio.dev/btn/try_blue_32.svg">
  </picture>
</a>

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

![Performance Results](https://raw.githubusercontent.com/arifnd/python-base-image-test/refs/heads/main/results.png)

| image                  | requests/sec | latency |
|------------------------|--------------|---------|
| alpine                 | 259,77       | 38,08   |
| alpine-multi           | 261,85       | 37,81   |
| alpine-multi-bytecode  | 262,34       | 37,71   |
| slim                   | 283,03       | 34,97   |
| slim-multi             | 282,86       | 35,00   |
| slim-multi-bytecode    | 278,98       | 35,47   |
| full                   | 278,10       | 35,57   |

## Security

To check for known security vulnerabilities in your Docker image, you can use [Trivy](https://github.com/aquasecurity/trivy), a simple and fast vulnerability scanner.

Run the following command:

```bash
trivy image <image-name>
```

### Sample Results

Below are example scan results comparing the three Python base images used in this project:

```text
flask-app:alpine (alpine 3.22.1)
================================
Total: 1 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 1)

flask-app:slim (debian 12.11)
=============================
Total: 106 (UNKNOWN: 1, LOW: 74, MEDIUM: 22, HIGH: 7, CRITICAL: 2)

flask-app:full (debian 12.11)
=============================
Total: 1711 (UNKNOWN: 6, LOW: 775, MEDIUM: 666, HIGH: 253, CRITICAL: 11)
```

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
