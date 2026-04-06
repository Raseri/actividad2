#!/bin/bash

# --- VARIABLES ---
BUCKET_NAME="respaldos-raseri-tec-123" 
DIRECTORIO_A_RESPALDAR="mis_datos"
BACKUP_FILE="backup_$(date +%F).tar.gz"
LOG_FILE="backup.log"

echo "--- Iniciando proceso de respaldo ---" > $LOG_FILE

# Validación 1: Si no existe el directorio, lo creamos para tener algo que respaldar
if [ ! -d "$DIRECTORIO_A_RESPALDAR" ]; then
    echo "El directorio $DIRECTORIO_A_RESPALDAR no existe. Creando directorio y archivo de prueba..." | tee -a $LOG_FILE
    mkdir $DIRECTORIO_A_RESPALDAR
    echo "Este es un archivo de prueba para el respaldo de AWS" > $DIRECTORIO_A_RESPALDAR/prueba.txt
fi

# Comprimir la carpeta
echo "Comprimiendo archivos..." | tee -a $LOG_FILE
tar -czf $BACKUP_FILE $DIRECTORIO_A_RESPALDAR >> $LOG_FILE 2>&1

# Validación 2: Subir a S3 y verificar si fue exitoso
echo "Subiendo a S3..." | tee -a $LOG_FILE
if aws s3 cp $BACKUP_FILE s3://$BUCKET_NAME/ >> $LOG_FILE 2>&1; then
    echo "EXITO: Respaldo subido correctamente a s3://$BUCKET_NAME/" | tee -a $LOG_FILE
else
    echo "ERROR: Falló la subida del respaldo a S3." | tee -a $LOG_FILE
fi
