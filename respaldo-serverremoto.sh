#!/bin/bash

# --- CONFIGURACIÓN ---
ORIGEN="/ruta/origen/carpeta/"
REMOTO_USER="usuario"
REMOTO_IP="192.168.1.50"
REMOTO_DESTINO="/ruta/destino/remoto/"
REMOTO_PORT="22"
CORREO="tu_email@dominio.com"
LOG_FILE="/tmp/backup_remoto.log"

echo "Iniciando respaldo remoto: $(date)" > "$LOG_FILE"

# Ejecutar transferencia
rsync -avh --delete -e "ssh -p $REMOTO_PORT" "$ORIGEN" "$REMOTO_USER@$REMOTO_IP:$REMOTO_DESTINO" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Respaldo remoto finalizado con éxito." >> "$LOG_FILE"
    mail -s "[ÉXITO] Backup Servidor Remoto" "$CORREO" < "$LOG_FILE"
else
    echo "ERROR: Falló la conexión o la transferencia al servidor." >> "$LOG_FILE"
    mail -s "[FALLO] Backup Servidor Remoto" "$CORREO" < "$LOG_FILE"
fi
