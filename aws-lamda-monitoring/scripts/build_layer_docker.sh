#!/bin/bash
set -e

echo "🚀 Building Lambda Layer with Pillow using Docker..."

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"
TERRAFORM_DIR="$PROJECT_DIR/terraform"

# Windows Git Bash fix
if [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* ]]; then
  TERRAFORM_DIR="$(cd "$SCRIPT_DIR" && pwd -W)/../terraform"
fi

if ! command -v docker &> /dev/null; then
  echo "❌ Docker is not installed."
  exit 1
fi

if ! docker info &> /dev/null 2>&1; then
  echo "❌ Docker is not running."
  exit 1
fi

echo "📦 Building layer in Linux container (Python 3.12)..."

docker run --rm \
  --platform linux/amd64 \
  -v "$TERRAFORM_DIR":/output \
  python:3.12-slim \
  bash -c "
    pip install --quiet Pillow==10.4.0 -t /tmp/python/lib/python3.12/site-packages/ &&
    cd /tmp &&
    apt-get update -qq && apt-get install -y -qq zip > /dev/null 2>&1 &&
    zip -q -r pillow_layer.zip python/ &&
    cp pillow_layer.zip /output/
  "

echo "✅ Layer built successfully"
echo "📍 $TERRAFORM_DIR/pillow_layer.zip"