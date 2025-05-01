#!/bin/bash

ALG=$1  # Algoritma: rr (round-robin) atau lc (least-conn)
TARGET_URL="http://localhost:8080/"
RESULTS_DIR="results"

mkdir -p $RESULTS_DIR

echo "Running benchmark for $ALG algorithm..."

# 3x pengujian berturut-turut biar lebih stabil
for i in {1..3}
do
    ab -n 1000 -c 50 $TARGET_URL > $RESULTS_DIR/${ALG}_run${i}.txt
    echo "Finished run $i for $ALG"
done

echo "Benchmark for $ALG completed. Results saved in $RESULTS_DIR/"
