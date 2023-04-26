DOCKER_REGISTRY ?= docker.io/ionhasihcorp
VERSION=0.0.1

buildx:
	@echo "=== PREPARE BUILDER ==="
	(docker buildx rm builder) || true
	docker buildx create --use --name builder --driver-opt network=host
	docker buildx inspect --bootstrap

frontend:
	@echo "=== BUILD FRONTEND ==="
	rm -rf frontend/build || true
	npm run build --prefix frontend/
	docker buildx build \
		--builder builder \
		--platform linux/amd64,linux/arm64,linux/arm/v7 \
		--tag ${DOCKER_REGISTRY}/elktron-frontend:${VERSION} \
		--file Dockerfile.frontend \
		--push \
		./frontend
	rm -rf frontend/build || true

backend:
	@echo "=== BUILD BACKEND ==="
	docker buildx build \
		--builder builder \
		--file Dockerfile.backend \
		--platform linux/amd64,linux/arm64,linux/arm/v7 \
		--tag ${DOCKER_REGISTRY}/elktron-backend:${VERSION} \
		--push \
		./backend/

all: buildx frontend backend
	(docker buildx rm builder) || true
