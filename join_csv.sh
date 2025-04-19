#!/bin/bash

# Verificar si se proporciona un directorio
if [ $# -ne 2 ]; then
    echo "Uso: $0 <directorio_de_origen> <archivo_de_salida>"
    exit 1
fi

SOURCE_DIR=$1
OUTPUT_FILE=$2
OUTPUT_BASENAME=$(basename "$OUTPUT_FILE")

# Verificar si el directorio existe
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: El directorio '$SOURCE_DIR' no existe."
    exit 1
fi

# Verificar si hay archivos CSV en el directorio (excluyendo el archivo de salida)
csv_count=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.csv" ! -name "$OUTPUT_BASENAME" | wc -l)
if [ "$csv_count" -eq 0 ]; then
    echo "Error: No se encontraron archivos CSV en el directorio '$SOURCE_DIR'."
    exit 1
fi

echo "Fusionando archivos CSV de $SOURCE_DIR en $OUTPUT_FILE..."

# Crear archivo de salida con el encabezado del primer archivo CSV
first_csv=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.csv" ! -name "$OUTPUT_BASENAME" | head -n 1)
head -n 1 "$first_csv" > "$OUTPUT_FILE"

# Concatenar todos los datos sin encabezados, excluyendo el archivo de salida
find "$SOURCE_DIR" -maxdepth 1 -name "*.csv" ! -name "$OUTPUT_BASENAME" -print0 | xargs -0 -I{} bash -c 'tail -n +2 "{}"' >> "$OUTPUT_FILE"

echo "Fusión completada. Se procesaron $csv_count archivos."
echo "Archivo resultante: $OUTPUT_FILE"
