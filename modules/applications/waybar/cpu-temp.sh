#!/usr/bin/env bash

temp=$(sensors -u | grep -A 1 'Tccd1' | tail -n 1 | awk '{print int($2 + 0.5)}')

if [ "$temp" -ge 80 ]; then
    class="critical"
elif [ "$temp" -ge 70 ]; then
    class="warning"
else
    class="normal"
fi

printf '{"text": "%s°C", "class": "%s"}\n' "$temp" "$class"
