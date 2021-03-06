#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

function displayusage {
  echo -e "${bold}SYSINFO run by $(whoami) ${normal}\n"
  echo "USAGE: systeminfo.sh [-h|help, -n|name, -i|ip, -o|os, -c|cpu, -m|ram, -d|disks, -de|devices, -s|software]"
}
function name {
  hostname -f
  uptime
}
function ip {
  hostname -I
  netstat -r | grep default
}
function os {
  lsb_release -d
}
function cpu {
  grep -m 1 "cpu MHz" /proc/cpuinfo
  grep -m 1 "cpu cores" /proc/cpuinfo
}
function ram {
  grep "MemTotal" /proc/meminfo
  grep "MemFree" /proc/meminfo
}
function disks {
  df -H
}
function processes {
  pstree
}

### Omitted in no arg mode, must be called via arg
function software {
  dpkg --get-selections | more
}
function devices {
  lshw -short && lsusb
}

if [ $# -gt 1 ]; then
  echo "Ignoring that extra arg..."
fi

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      displayusage
      exit 0
      ;;
    -n|--name)
      echo -e "${bold}HOSTNAME${normal}"
      name
      exit 0
      ;;
    -i|--ip)
      echo -e "${bold}IP${normal}"
      ip
      exit 0
      ;;
    -o|--os)
      echo -e "${bold}OS${normal}"
      os
      exit 0
      ;;
    -c|--cpu)
      echo -e "${bold}CPU${normal}"
      cpu
      exit 0
      ;;
    -m|--ram)
      echo -e "${bold}RAM${normal}"
      ram
      exit 0
      ;;
    -d|--disks)
      echo -e "${bold}DISKS${normal}"
      disks
      exit 0
      ;;
    -p|--processes)
      echo -e "${bold}PROCESSES${normal}"
      processes
      exit 0
      ;;
      ### Omitted in no arg mode, must be called via arg
     -s|--software)
      echo -e "${bold}SOFTWARE${normal}"
      software
      exit 0
      ;;
    -de|--devices)
      echo -e "${bold}DEVICES${normal}"
      devices
      exit 0
      ;;

    *)
      echo "${bold}[X]${normal} Invalid argument"
      echo $displayusage
      exit 1
      ;;
  esac
  shift
done

echo -e "${bold}SYSINFO run by $(whoami) ${normal}[-h for usage, some info omitted]\n"

name
ip
os
echo -e "\n"
cpu
ram
echo -e "\n"
disks
echo -e "\n"
processes
