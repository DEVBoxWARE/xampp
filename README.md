# XAMPP para MikroTik CHR (RouterOS container)

Imagen Docker basada en [tomsik68/docker-xampp](https://github.com/tomsik68/docker-xampp), con:

- **XAMPP para Linux 8.5.13**: PHP 8.5.13, Apache 2.4.71, MariaDB 10.11.19, phpMyAdmin 5.2.3, OpenSSL 3.6.5
- La misma estructura que el original: Debian bookworm-slim, `/opt/lampp`, `/www`, SSH, supervisord, puertos 80/22/3306 y los mismos volúmenes
- **Sin** el aviso de obsolescencia ni el bloqueo del 22 de enero de 2027

## Descargar

Ve a **Releases** y descarga `xampp.tar` (linux/amd64, formato `docker save`).

## Usar en RouterOS

```
/container/add file=xampp.tar interface=veth-xampp root-dir=xampp/root name=xampp start-on-boot=yes logging=yes
/container/start xampp
```

## Construir otra versión

En **Actions → Build xampp.tar → Run workflow** puedes elegir otra versión (por ejemplo `8.4.28` o `8.3.37`). Cada versión se publica como un release propio (`v8.4.28`, etc.).

Para construirla en tu PC:

```bash
docker buildx build --no-cache --platform linux/amd64 -t xampp:8.5.13 --output type=docker,dest=xampp.tar .
```

## Accesos por defecto

| Servicio | Usuario | Contraseña |
|---|---|---|
| SSH | root | root |
| MySQL / phpMyAdmin | root | (vacía) |

No expongas estos puertos a internet. Para poner contraseña a MySQL y phpMyAdmin: `lampp security`.
