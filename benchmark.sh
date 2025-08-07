#!/bin/bash

THREADS=2
CONNECTIONS=10
DURATION=10s
ENDPOINT="/todos"

# Define ports and their labels
PORTS=(8001 8002 8003 8004 8005 8006 8007)
LABELS=("alpine" "alpine-multi" "alpine-multi-bytecode" "slim" "slim-multi" "slim-multi-bytecode" "full")

echo "label,port,requests/sec,latency" > wrk_results.csv

for i in "${!PORTS[@]}"; do
  PORT=${PORTS[$i]}
  LABEL=${LABELS[$i]}

  echo "Testing $LABEL on port $PORT..."
  OUTPUT=$(wrk -t$THREADS -c$CONNECTIONS -d$DURATION "http://127.0.0.1:$PORT$ENDPOINT")

  REQ_PER_SEC=$(echo "$OUTPUT" | grep "Requests/sec" | awk '{print $2}')
  LATENCY=$(echo "$OUTPUT" | grep "Latency" | awk '{print $2}')

  echo "$LABEL,$PORT,$REQ_PER_SEC,$LATENCY" >> wrk_results.csv
done
