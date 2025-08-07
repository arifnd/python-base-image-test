#!/bin/bash
set -e

echo "== 🚀 Docker Image Building Benchmark =="

for FILE in Dockerfile*; do
    TAG_SUFFIX=$(echo "$FILE" | sed 's/Dockerfile\.//')
    [ "$FILE" == "Dockerfile" ] && TAG_SUFFIX="default"

    IMAGE_TAG="flask-app:$TAG_SUFFIX"

    echo ""
    echo "🔨 Building $IMAGE_TAG from $FILE..."

    START=$(date +%s)
    docker build -q -f "$FILE" -t "$IMAGE_TAG" . > /dev/null
    END=$(date +%s)

    SIZE=$(docker image inspect "$IMAGE_TAG" --format='{{.Size}}')
    SIZE_MB=$(echo "scale=2; $SIZE/1024/1024" | bc)

    echo "✅ Build time: $((END - START))s"
    echo "📦 Image size: ${SIZE_MB} MB"
done
