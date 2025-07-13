# Keycloak with Tailcloakify

This Docker image is based on Bitnami Keycloak 26 and includes the Tailcloakify theme for a modern, Tailwind CSS-based user interface.

## Features

- 🔐 **Keycloak 26**: Latest stable version from Bitnami
- 🎨 **Tailcloakify Theme**: Modern, responsive UI built with Tailwind CSS
- 🚀 **Multi-architecture**: Supports both AMD64 and ARM64
- 🔧 **Production Ready**: Optimized for production deployments

## Quick Start

### Docker Run

```bash
docker run -d \
  --name keycloak-tailcloakify \
  -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  ghcr.io/your-username/keycloak-tailcloakify:latest
```

### Docker Compose

```yaml
version: '3.8'
services:
  keycloak:
    image: ghcr.io/your-username/keycloak-tailcloakify:latest
    ports:
      - "8080:8080"
    environment:
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: admin
      KEYCLOAK_DATABASE_VENDOR: dev-file
    volumes:
      - keycloak_data:/opt/bitnami/keycloak/data

volumes:
  keycloak_data:
```

### Kubernetes with Helm (Bitnami Keycloak Chart)

```yaml
# values.yaml
image:
  registry: ghcr.io
  repository: your-username/keycloak-tailcloakify
  tag: latest

auth:
  adminUser: admin
  adminPassword: admin

# Enable Tailcloakify theme
extraEnvVars:
  - name: KEYCLOAK_EXTRA_ARGS
    value: "--spi-theme-static-max-age=-1 --spi-theme-cache-themes=false"
```

```bash
helm install keycloak bitnami/keycloak -f values.yaml
```

## Theme Configuration

After deployment, configure Keycloak to use the Tailcloakify theme:

1. Access the Keycloak Admin Console
2. Navigate to **Realm Settings** → **Themes**
3. Set **Login Theme** to `tailcloakify`
4. Set **Account Theme** to `tailcloakify` (if available)
5. Click **Save**

## Environment Variables

All standard Bitnami Keycloak environment variables are supported:

| Variable | Description | Default |
|----------|-------------|---------|
| `KEYCLOAK_ADMIN` | Admin username | `admin` |
| `KEYCLOAK_ADMIN_PASSWORD` | Admin password | `admin` |
| `KEYCLOAK_DATABASE_VENDOR` | Database vendor | `dev-file` |
| `KEYCLOAK_DATABASE_HOST` | Database host | - |
| `KEYCLOAK_DATABASE_PORT` | Database port | - |
| `KEYCLOAK_DATABASE_NAME` | Database name | - |
| `KEYCLOAK_DATABASE_USER` | Database user | - |
| `KEYCLOAK_DATABASE_PASSWORD` | Database password | - |

For a complete list, see the [Bitnami Keycloak documentation](https://github.com/bitnami/containers/tree/main/bitnami/keycloak).

## Production Considerations

### Database Configuration

For production, use an external database:

```yaml
environment:
  KEYCLOAK_DATABASE_VENDOR: postgresql
  KEYCLOAK_DATABASE_HOST: postgres.example.com
  KEYCLOAK_DATABASE_PORT: 5432
  KEYCLOAK_DATABASE_NAME: keycloak
  KEYCLOAK_DATABASE_USER: keycloak
  KEYCLOAK_DATABASE_PASSWORD: your-secure-password
```

### Proxy Configuration

When running behind a reverse proxy (Nginx, Traefik, etc.):

```yaml
environment:
  KEYCLOAK_PROXY: edge
  KEYCLOAK_PROXY_ADDRESS_FORWARDING: "true"
  KEYCLOAK_HOSTNAME_STRICT: "false"
```

### SSL/TLS

For HTTPS in production:

```yaml
environment:
  KEYCLOAK_ENABLE_HTTPS: "true"
  KEYCLOAK_HTTPS_CERTIFICATE_FILE: "/path/to/cert.pem"
  KEYCLOAK_HTTPS_CERTIFICATE_KEY_FILE: "/path/to/key.pem"
```

## Tags

- `latest`: Latest stable build from main branch
- `v*`: Semantic version tags (e.g., `v1.0.0`)
- `main`: Latest build from main branch
- `develop`: Latest build from develop branch

## Building Locally

```bash
git clone https://github.com/your-username/keycloak-tailcloakify.git
cd keycloak-tailcloakify
docker build -t keycloak-tailcloakify .
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

- [Bitnami Keycloak](https://github.com/bitnami/containers/tree/main/bitnami/keycloak)
- [Tailcloakify](https://github.com/ALMiG-Kompressoren-GmbH/tailcloakify)
- [Keycloak](https://www.keycloak.org/)

## Support

For issues related to:
- **This Docker image**: Open an issue in this repository
- **Tailcloakify theme**: Check the [Tailcloakify repository](https://github.com/ALMiG-Kompressoren-GmbH/tailcloakify)
- **Keycloak**: Check the [official Keycloak documentation](https://www.keycloak.org/documentation)
