#!/bin/bash

echo "Run migration..."

docker compose exec app-slim flask db migrate -m "Initial migration."

docker compose exec app-slim flask db upgrade

curl -X POST http://localhost:8004/todos \
  -H "Content-Type: application/json" \
  -d '{"task": "Learn Flask"}'
