#!/bin/bash
set -e

# Eliminar un server.pid anterior si existe
rm -f /app/tmp/pids/server.pid

# Ejecutar el comando pasado al entrypoint
exec "$@" 