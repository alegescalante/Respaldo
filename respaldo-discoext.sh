#!/bin/bash

# --- CONFIGURACIÓN ---
ORIGEN="/home/age/Escritorio/prueba/"
DESTINO_DISCO="/home/age/Escritorio/borrar/"
CORREO="alertas.recursos@gmail.com"
LOG_FILE="/tmp/backup_disco.log"

echo "Iniciando respaldo a disco externo: $(date)" > "$LOG_FILE"

# Verificar si el disco está conectado
if [ -d "$DESTINO_DISCO" ]; then
    rsync -avh --delete "$ORIGEN" "$DESTINO_DISCO" >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        echo "Respaldo finalizado con éxito." >> "$LOG_FILE"
#        mail -s "[ÉXITO] Backup Disco Externo" "$CORREO" < "$LOG_FILE"
        echo "El respaldo se completó correctamente. Los detalles están adjuntos." | mail -s "[ÉXITO] Backup Disco Externo" -A "$LOG_FILE" "$CORREO"
    else
        echo "ERROR: Ocurrió un problema durante el rsync." >> "$LOG_FILE"
        echo "ERROR: Ocurrió un problema durante el rsync. Los detalles están adjuntos." | mail -s "[FALLO] Backup Disco Externo" "$CORREO" < "$LOG_FILE"
    fi
else
    echo "ERROR CRÍTICO: El disco externo no está montado." >> "$LOG_FILE"
    echo "ERROR CRÍTICO: El disco externo no está montado. Los detalles están adjuntos." | mail -s "[CRÍTICO] Backup Disco No Conectado" "$CORREO" < "$LOG_FILE"
fi
