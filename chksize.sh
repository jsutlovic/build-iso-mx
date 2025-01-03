#!/bin/bash

AWK=${AWK:-/usr/bin/awk}

# awk script to produce some formatted JSON
read -r -d '' freespace_json <<'EOF'
BEGIN {
  printf "{"
  printf "\"server\": \"" machine "\","
  printf "\"timestamp\": \"" timestamp "\","
  printf "\"filesystems\":["
}
{
  if ($1 != "Filesystem") {
    if (i) {
      printf ","
    }
    printf "{\"mount\":\"" $6 "\",\"size\":\"" $2 "\",\"used\":\"" $3 \
            "\",\"avail\":\"" $4 "\",\"used_pct\":\"" $5 "\", \"fs\":\"" $1 "\"}"
    i++
  }
}
END {
  print "]}"
}
EOF

df -P -k | grep -vE "(/snap/core|^//)" | sed 's/%//g' | $AWK -v machine="$(hostname)" -v timestamp="$(date +%s)" -f <(echo "$freespace_json")
