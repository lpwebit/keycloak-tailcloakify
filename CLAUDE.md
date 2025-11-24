# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository provides a Docker image that combines the official Keycloak 26 with the Tailcloakify theme (a modern Tailwind CSS-based UI) and the Vikunja mapper extension. The image is published to GitHub Container Registry (ghcr.io) and supports multi-architecture deployments (AMD64 and ARM64).

## Architecture

### Docker Build Strategy

The project uses a **three-stage Docker build** (Dockerfile:1-40):
- **Stage 1 (downloader)**: Alpine-based image downloads two JAR files from GitHub releases:
  - `tailcloakify.jar` (v1.1.17) - The Tailwind CSS theme for Keycloak
  - `keycloak-vikunja-mapper.jar` (v0.1.2) - Extension for Vikunja integration
- **Stage 2 (builder)**: Based on `quay.io/keycloak/keycloak:26`, copies both JARs into `/opt/keycloak/providers/` and runs `kc.sh build` to optimize Keycloak with the new providers
- **Stage 3 (production)**: Clean Keycloak 26 image with the optimized build copied from stage 2

This approach creates an optimized production image with providers pre-built into Keycloak, improving startup time and keeping the final image minimal.

### CI/CD Pipeline

GitHub Actions workflow (`.github/workflows/docker-build.yml`) handles:
- **Triggers**: Pushes to `main` branch, version tags (`v*`), or manual dispatch
- **Multi-arch builds**: Both linux/amd64 and linux/arm64 using Docker Buildx
- **Registry**: Publishes to GitHub Container Registry (ghcr.io)
- **Tagging strategy**:
  - `latest` - Latest build from main branch
  - `main` - Branch-specific tag
  - `main-<sha>` - Commit SHA tags for traceability
  - `v*`, `major.minor`, `major` - Semantic version tags (only on release tags)
- **Attestations**: Generates build provenance attestations for security
- **Releases**: Automatically creates GitHub releases with usage instructions for version tags

## Development Commands

### Building the Docker Image

```bash
# Build locally
docker build -t keycloak-tailcloakify .

# Build for specific platform
docker build --platform linux/amd64 -t keycloak-tailcloakify .
docker build --platform linux/arm64 -t keycloak-tailcloakify .
```

### Testing Locally

```bash
# Run with default dev configuration
docker run -d \
  --name keycloak-tailcloakify \
  -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  keycloak-tailcloakify

# Access Keycloak at http://localhost:8080
# Admin console: http://localhost:8080/admin
```

### Updating Dependencies

When updating the Tailcloakify or Vikunja mapper versions:
1. Update the version number and download URLs in Dockerfile:9-12
2. Update the version reference in `.github/workflows/docker-build.yml`:98 (release notes)
3. Update README.md:162 if pointing to specific versions

## Key Configuration

### Theme Activation

After deployment, the Tailcloakify theme must be manually activated:
1. Access Keycloak Admin Console
2. Navigate to Realm Settings → Themes
3. Set Login Theme to `tailcloakify`
4. Set Account Theme to `tailcloakify` (if available)
5. Save changes

### Production Environment Variables

The image uses official Keycloak environment variables (KC_ prefix for configuration). Critical ones for production:
- Admin: `KEYCLOAK_ADMIN`, `KEYCLOAK_ADMIN_PASSWORD` (no KC_ prefix)
- Database: `KC_DB`, `KC_DB_URL_HOST`, `KC_DB_URL_DATABASE`, `KC_DB_USERNAME`, `KC_DB_PASSWORD`
- Proxy: `KC_PROXY=edge`, `KC_HOSTNAME_STRICT=false`, `KC_HTTP_ENABLED=true`
- TLS: `KC_HTTPS_CERTIFICATE_FILE`, `KC_HTTPS_CERTIFICATE_KEY_FILE` (expects files in `/opt/keycloak/conf/`)

Note: The official Keycloak image requires `KC_HTTP_ENABLED=true` for development or when running behind a reverse proxy.

## Release Process

1. Commit and push changes to `main` branch (triggers `latest` tag build)
2. Create and push a version tag: `git tag v1.0.0 && git push origin v1.0.0`
3. GitHub Actions automatically:
   - Builds multi-arch images
   - Publishes to ghcr.io with semantic version tags
   - Creates GitHub release with usage instructions
   - Generates build attestations

## External Dependencies

- **Base Image**: quay.io/keycloak/keycloak:26 (Official Keycloak 26.x.x)
- **Tailcloakify**: https://github.com/ALMiG-Kompressoren-GmbH/tailcloakify (v1.1.17)
- **Vikunja Mapper**: https://github.com/makerspace-darmstadt/keycloak-vikunja-mapper (v0.1.2)

## Key Differences from Bitnami Image

If migrating from a Bitnami-based setup:
- Paths: `/opt/bitnami/keycloak/` → `/opt/keycloak/`
- User: 1001 → 1000 (keycloak)
- Environment variables: `KEYCLOAK_*` → `KC_*` (except admin credentials)
- Entrypoint: `/opt/bitnami/scripts/keycloak/run.sh` → `/opt/keycloak/bin/kc.sh start`
- HTTP must be explicitly enabled with `KC_HTTP_ENABLED=true` for non-TLS deployments
