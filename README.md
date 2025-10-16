# Keycloak with Tailcloakify

This Docker image is based on the official Keycloak 26 and includes the Tailcloakify theme for a modern, Tailwind CSS-based user interface.

## Features

- 🔐 **Keycloak 26**: Latest stable version (official image)
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
  ghcr.io/lpwebit/keycloak-tailcloakify:latest
```

### Docker Compose

```yaml
version: '3.8'
services:
  keycloak:
    image: ghcr.io/lpwebit/keycloak-tailcloakify:latest
    ports:
      - "8080:8080"
    environment:
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: admin
      KC_DB: dev-file
    volumes:
      - keycloak_data:/opt/keycloak/data

volumes:
  keycloak_data:
```

### Kubernetes with Helm (Official Keycloak Chart)

```yaml
# values.yaml
image:
  repository: ghcr.io/lpwebit/keycloak-tailcloakify
  tag: latest

command:
  - "/opt/keycloak/bin/kc.sh"
  - "start"

extraEnv: |
  - name: KEYCLOAK_ADMIN
    value: admin
  - name: KEYCLOAK_ADMIN_PASSWORD
    value: admin
  - name: KC_PROXY
    value: edge
  - name: KC_HTTP_ENABLED
    value: "true"
```

```bash
helm install keycloak codecentric/keycloak -f values.yaml
```

## Theme Configuration

After deployment, configure Keycloak to use the Tailcloakify theme:

1. Access the Keycloak Admin Console
2. Navigate to **Realm Settings** → **Themes**
3. Set **Login Theme** to `tailcloakify`
4. Set **Account Theme** to `tailcloakify` (if available)
5. Click **Save**

## Environment Variables

All standard Keycloak environment variables are supported:

| Variable | Description | Default |
|----------|-------------|---------|
| `KEYCLOAK_ADMIN` | Admin username | - |
| `KEYCLOAK_ADMIN_PASSWORD` | Admin password | - |
| `KC_DB` | Database vendor (postgres, mysql, mariadb, mssql, dev-file, dev-mem) | `dev-file` |
| `KC_DB_URL_HOST` | Database host | - |
| `KC_DB_URL_PORT` | Database port | - |
| `KC_DB_URL_DATABASE` | Database name | - |
| `KC_DB_USERNAME` | Database user | - |
| `KC_DB_PASSWORD` | Database password | - |
| `KC_HOSTNAME` | Hostname for frontend URLs | - |
| `KC_HTTP_ENABLED` | Enable HTTP listener | `false` |
| `KC_PROXY` | Proxy mode (edge, reencrypt, passthrough) | `none` |

For a complete list, see the [official Keycloak documentation](https://www.keycloak.org/server/all-config).

## Production Considerations

### Database Configuration

For production, use an external database:

```yaml
environment:
  KC_DB: postgres
  KC_DB_URL_HOST: postgres.example.com
  KC_DB_URL_PORT: 5432
  KC_DB_URL_DATABASE: keycloak
  KC_DB_USERNAME: keycloak
  KC_DB_PASSWORD: your-secure-password
```

Or use a full connection string:

```yaml
environment:
  KC_DB: postgres
  KC_DB_URL: jdbc:postgresql://postgres.example.com:5432/keycloak
  KC_DB_USERNAME: keycloak
  KC_DB_PASSWORD: your-secure-password
```

### Proxy Configuration

When running behind a reverse proxy (Nginx, Traefik, etc.):

```yaml
environment:
  KC_PROXY: edge
  KC_HOSTNAME_STRICT: "false"
  KC_HTTP_ENABLED: "true"
```

### SSL/TLS

For HTTPS in production:

```yaml
environment:
  KC_HTTPS_CERTIFICATE_FILE: "/path/to/cert.pem"
  KC_HTTPS_CERTIFICATE_KEY_FILE: "/path/to/key.pem"
```

Note: The official Keycloak image expects certificates at `/opt/keycloak/conf/`.

## Tags

- `latest`: Latest stable build from main branch
- `v*`: Semantic version tags (e.g., `v1.0.0`)
- `main`: Latest build from main branch
- `develop`: Latest build from develop branch

## Building Locally

```bash
git clone https://github.com/lpwebit/keycloak-tailcloakify.git
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

- [Keycloak](https://www.keycloak.org/)
- [Tailcloakify](https://github.com/ALMiG-Kompressoren-GmbH/tailcloakify)
- [Keycloak Vikunja Mapper](https://github.com/makerspace-darmstadt/keycloak-vikunja-mapper)

## Support

For issues related to:
- **This Docker image**: Open an issue in this repository
- **Tailcloakify theme**: Check the [Tailcloakify repository](https://github.com/ALMiG-Kompressoren-GmbH/tailcloakify)
- **Keycloak**: Check the [official Keycloak documentation](https://www.keycloak.org/documentation)
