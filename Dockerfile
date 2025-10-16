# Multi-stage build: Download stage
FROM alpine:latest AS downloader

# Install minimal tools for downloading
RUN apk add --no-cache curl

# Download the specific JAR for Keycloak 26 from the latest release
WORKDIR /tmp
RUN curl -L https://github.com/ALMiG-Kompressoren-GmbH/tailcloakify/releases/download/v1.1.17/keycloak-theme-for-kc-all-other-versions.jar \
    -o tailcloakify.jar
RUN curl -L https://github.com/makerspace-darmstadt/keycloak-vikunja-mapper/releases/download/v0.1.2/keycloak-vikunja-mapper.jar \
    -o keycloak-vikunja-mapper.jar

# Production stage
FROM quay.io/keycloak/keycloak:26 AS builder

# Copy provider JARs to providers directory (as root during build)
USER root
COPY --from=downloader --chown=keycloak:keycloak /tmp/tailcloakify.jar /opt/keycloak/providers/
COPY --from=downloader --chown=keycloak:keycloak /tmp/keycloak-vikunja-mapper.jar /opt/keycloak/providers/

# Build Keycloak with the providers
RUN /opt/keycloak/bin/kc.sh build

# Final production stage
FROM quay.io/keycloak/keycloak:26

# Copy the optimized Keycloak build from builder
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Set working directory
WORKDIR /opt/keycloak

# Expose the default Keycloak port
EXPOSE 8080

# Start Keycloak in production mode
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start"]
