#!/bin/bash
trap "./uhubctl -p $port -a on &> /dev/null; echo 'Exit'; exit" INT

rate=$1
if [ -z "$rate" ]; then
  echo "Usage: ./fan.sh rate"
  exit 1
fi

down=$(echo $rate | ruby -e 'print((1 - STDIN.read.to_f)* 0.1)')
up=$(echo $rate | ruby -e 'print(STDIN.read.to_f * 0.1)')
port=2

echo "Power: $rate"
while true; do
  ./uhubctl -p $port -a on &> /dev/null
  sleep $up
  ./uhubctl -p $port -a off &> /dev/null
  sleep $down
done
