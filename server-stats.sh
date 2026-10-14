#!/usr/bin/env bash

get_system_info(){
    printf "User: %s\n" "$(whoami)"
    printf "Host: %s\n" "$(hostname)"
    printf "OS: "
    cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2
    printf "Date: %s\n" "$(date +"%d %b %Y %T")"
    printf "Uptime: %s\n" "$(uptime -p)"
}

get_cpu_usage(){
    top -bn2 | grep '%Cpu' | tail -n1 | awk '{printf "CPU Usage: %.2f%%\n", 100 - $8}'
}

get_memory_usage(){
    free | awk '/Mem:/ {printf "Used: %.2fGiB | Available: %.2fGiB (%.2f%% used)\n", $3/(1024*1024), $7/(1024*1024), $3/$2*100}'
}

get_disk_usage(){
    df -h / | awk 'NR == 2 {printf "Used: %s | Available: %s (%s used)\n", $3, $4, $5}'
}

get_processes_cpu(){
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
}

get_processes_memory(){
    ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6
}

echo "===== System Info ====="
get_system_info
echo

echo "===== CPU Usage ====="
get_cpu_usage
echo

echo "===== Total Memory Usage ====="
get_memory_usage
echo 

echo "===== Disk Usage ====="
get_disk_usage
echo

echo "===== Top 5 processes by CPU ====="
get_processes_cpu
echo

echo "===== Top 5 processes by Memory ====="
get_processes_memory
echo