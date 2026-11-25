#!/usr/bin/env bash
# ============================================================================
#  Compila la imagen XAMPP para MikroTik CHR (linux/amd64) -> xampp-VERSION.tar
#
#  Uso:   ./build.sh            (usa la version de abajo)
#         ./build.sh 8.4.28     (compila otra version sin editar el archivo)
# ============================================================================

# ===== En futuras actualizaciones solo cambia esta linea =====
XAMPP_VERSION="8.5.13"
# =============================================================

set -euo pipefail
[ -n "${1:-}" ] && XAMPP_VERSION="$1"

cd "$(dirname "$(readlink -f "$0")")"
OUT="xampp-${XAMPP_VERSION}.tar"
TAG="xampp:${XAMPP_VERSION}"

echo "=============================================================="
echo "  Compilando XAMPP ${XAMPP_VERSION} para MikroTik CHR (amd64)"
echo "  Salida: $(pwd)/${OUT}"
echo "=============================================================="

if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker no responde."
    echo "  - Arrancalo con:  sudo systemctl start docker"
    echo "  - O ejecuta este script con sudo si tu usuario no esta en el grupo docker."
    exit 1
fi

START=$(date +%s)

if docker buildx version >/dev/null 2>&1; then
    docker buildx build --no-cache --platform linux/amd64 \
        --build-arg XAMPP_VERSION="${XAMPP_VERSION}" \
        -t "${TAG}" \
        --output "type=docker,dest=${OUT}" .
else
    echo "(buildx no disponible, usando docker build + docker save)"
    docker build --no-cache --platform linux/amd64 \
        --build-arg XAMPP_VERSION="${XAMPP_VERSION}" \
        -t "${TAG}" .
    docker save "${TAG}" -o "${OUT}"
fi

echo
echo "=============================================================="
echo "  LISTO en $(( ($(date +%s) - START) / 60 )) min"
echo "  Archivo: ${OUT} ($(du -h "${OUT}" | cut -f1))"
echo "  SHA256:  $(sha256sum "${OUT}" | cut -d' ' -f1)"
echo
echo "  Subelo al CHR y crealo con:"
echo "  /container/add file=${OUT} ..."
echo "=============================================================="
