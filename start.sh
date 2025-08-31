#!/bin/bash

# === Compilación ===
echo ">> Compilando analizador..."
bison -d parserbison.y || { echo "Error en Bison"; exit 1; }
flex flex.l || { echo "Error en Flex"; exit 1; }
gcc -o act1 parserbison.tab.c lex.yy.c Tree.c SymbolTable.c -lfl || { echo "Error en compilación"; exit 1; }
echo ">> Compilación exitosa"
echo

mkdir -p resultados/valid resultados/syntax resultados/semantics  # carpeta para las salidas

# === Función para correr un test ===
run_test() {
    file=$1
    expected=$2 # "valid", "syntax" o "semantics"
    base=$(basename "$file" .txt)   # nombre base sin path ni .txt
    outfile="resultados/$expected/${base}.out"

    echo "== Probando $file =="

    # Ejecuta y guarda salida en archivo, sin mostrar en consola
    ./act1 < "$file" > "$outfile" 2>&1
    code=$? #captura el codigo de salida de ./act1

    if [ "$expected" = "valid" ]; then
        if [ "$code" -eq 0 ]; then
            echo "✅ $file (OK, válido)"
        else
            echo "❌ $file (FAIL, debería ser válido, salió $code)"
            echo "👉 Ver salida en $outfile"
        fi
    elif [ "$expected" = "syntax" ]; then
        if [ "$code" -eq 1 ]; then
            echo "✅ $file (OK, error sintáctico detectado)"
        else
            echo "❌ $file (FAIL, debería ser error sintáctico, salió $code)"
            echo "👉 Ver salida en $outfile"
        fi
    elif [ "$expected" = "semantics" ]; then
        if [ "$code" -eq 2 ]; then
            echo "✅ $file (OK, error semántico detectado)"
        else
            echo "❌ $file (FAIL, debería ser error semántico, salió $code)"
            echo "👉 Ver salida en $outfile"
        fi
    fi
    echo
}

# === Correr tests válidos ===
for t in test/valid/test[0-9]*.txt; do
    run_test "$t" valid
done

# === Correr tests inválidos por sintaxis ===
for t in test/syntax/test_err*.txt; do
    run_test "$t" syntax
done

# === Correr tests inválidos por semantica ===
for t in test/semantics/test[0-9]*.txt; do
    run_test "$t" semantics
done