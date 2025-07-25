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
FROM bitnami/keycloak:26

# Copy the JAR file to providers directory (as user 1001)
COPY --from=downloader --chown=1001:1001 /tmp/tailcloakify.jar /opt/bitnami/keycloak/providers/
COPY --from=downloader --chown=1001:1001 /tmp/keycloak-vikunja-mapper.jar /opt/bitnami/keycloak/providers/

# Expose the default Keycloak port
EXPOSE 8080

# Use the default entrypoint from the base image
CMD ["/opt/bitnami/scripts/keycloak/run.sh"]
