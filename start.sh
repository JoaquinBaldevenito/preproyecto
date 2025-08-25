#!/bin/bash

# === Compilación ===
echo ">> Compilando analizador..."
bison -d parserbison.y || { echo "Error en Bison"; exit 1; }
flex flex.l || { echo "Error en Flex"; exit 1; }
gcc -o act1 parserbison.tab.c lex.yy.c Tree.c -lfl || { echo "Error en compilación"; exit 1; }
echo ">> Compilación exitosa"
echo

mkdir -p resultados  # carpeta para las salidas

# === Función para correr un test ===
run_test() {
    file=$1
    expected=$2 # "valid" o "invalid"
    base=$(basename "$file" .txt)   # nombre base sin path ni .txt
    outfile="resultados/${base}.out"

    echo "== Probando $file =="

    if ./act1 < "$file" > "$outfile" 2>&1; then
        if [ "$expected" = "valid" ]; then
            echo "✅ $file (OK, válido)"
        else
            echo "❌ $file (FAIL, esperaba error pero pasó)"
            echo "👉 Ver salida en $outfile"
        fi
    else
        if [ "$expected" = "invalid" ]; then
            echo "✅ $file (OK, error detectado)"
        else
            echo "❌ $file (FAIL, debería ser válido)"
            echo "👉 Ver salida en $outfile"
        fi
    fi
    echo
}

# === Correr tests válidos ===
for t in test/test[0-9]*.txt; do
    run_test "$t" valid
done

# === Correr tests inválidos ===
for t in test/test_err*.txt; do
    run_test "$t" invalid
done