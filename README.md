# XAMPP para MikroTik CHR (RouterOS container)

Imagen Docker basada en [tomsik68/docker-xampp](https://github.com/tomsik68/docker-xampp), con:

- **XAMPP para Linux 8.5.13**: PHP 8.5.13, Apache 2.4.71, MariaDB 10.11.19, phpMyAdmin 5.2.3, OpenSSL 3.6.5
- La misma estructura que el original: Debian bookworm-slim, `/opt/lampp`, `/www`, SSH, supervisord, puertos 80/22/3306 y los mismos volúmenes
- **Sin** el aviso de obsolescencia ni el bloqueo del 22 de enero de 2027

## Descargar

Ve a **Releases** y descarga `xampp.tar` (si GitHub Actions está activo en la cuenta) (linux/amd64, formato `docker save`).

## Usar en RouterOS

```
/container/add file=xampp.tar interface=veth-xampp root-dir=xampp/root name=xampp start-on-boot=yes logging=yes
/container/start xampp
```

## Compilar en tu PC (recomendado)

- **Windows:** doble clic en `build.bat` (abre Docker Desktop si está cerrado y espera a que arranque).
- **Linux:** `./build.sh`

El resultado es `xampp-<versión>.tar` en la misma carpeta.

### Actualizar a una versión nueva de XAMPP

1. Mira el número nuevo en https://www.apachefriends.org (por ejemplo `8.5.14`).
2. Cambia **una sola línea** en `build.bat` (`set "XAMPP_VERSION=..."`) o en `build.sh` (`XAMPP_VERSION="..."`).
3. Compila otra vez.

También puedes no editar nada y pasar la versión: `build.bat 8.4.28` o `./build.sh 8.4.28`.

## Construir con GitHub Actions

En **Actions → Build xampp.tar → Run workflow** puedes elegir otra versión (por ejemplo `8.4.28` o `8.3.37`). Cada versión se publica como un release propio (`v8.4.28`, etc.).


## Accesos por defecto

| Servicio | Usuario | Contraseña |
|---|---|---|
| SSH | root | root |
| MySQL / phpMyAdmin | root | (vacía) |

No expongas estos puertos a internet. Para poner contraseña a MySQL y phpMyAdmin: `lampp security`.
