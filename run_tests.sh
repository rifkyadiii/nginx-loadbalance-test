#!/bin/bash

ALG=$1  # Algoritma: rr (round-robin) atau lc (least-conn)
SERVER1_URL="http://localhost:3001/"
SERVER2_URL="http://localhost:3002/"
RESULTS_DIR="results"

mkdir -p $RESULTS_DIR

echo "Running benchmark for $ALG algorithm..."

# Skenario pengujian dengan tiga level beban
declare -a BEBAN=("Rendah" "Sedang" "Tinggi")

# Loop untuk menguji berbagai skenario beban dan dua server
for ALG in rr lc
do
    for beban in "${BEBAN[@]}"
    do
        for i in {1..3}  # Pengujian sebanyak 3 kali
        do
            # Tentukan URL berdasarkan beban dan server
            if [ "$beban" == "Rendah" ]; then
                SERVER1_URL="${SERVER1_URL}api/delay/10"  # Delay ringan 10ms
                SERVER2_URL="${SERVER2_URL}api/delay/10"  # Delay ringan 10ms
            elif [ "$beban" == "Sedang" ]; then
                SERVER1_URL="${SERVER1_URL}api/delay/100"  # Delay sedang 100ms
                SERVER2_URL="${SERVER2_URL}api/delay/100"  # Delay sedang 100ms
            else
                SERVER1_URL="${SERVER1_URL}api/delay/1000"  # Delay tinggi 1000ms
                SERVER2_URL="${SERVER2_URL}api/delay/1000"  # Delay tinggi 1000ms
            fi
            
            # Jalankan benchmark untuk Server 1
            ab -n 1000 -c 50 $SERVER1_URL > $RESULTS_DIR/${ALG}_${beban}_server1_run${i}.txt
            echo "Finished run $i for $ALG on Server 1 with $beban load"
            
            # Jalankan benchmark untuk Server 2
            ab -n 1000 -c 50 $SERVER2_URL > $RESULTS_DIR/${ALG}_${beban}_server2_run${i}.txt
            echo "Finished run $i for $ALG on Server 2 with $beban load"
        done
    done
done

echo "Benchmark completed for all scenarios. Results saved in $RESULTS_DIR/"
