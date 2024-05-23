#!/bin/bash

# Контроль активности скрипта
if [ -f /vagrant/script.pid ]; then
  echo "Скрипт в данный момент запущен. Параллельный запуск не воможен"
  exit 1
fi
touch /vagrant/script.pid

# Объявление переменных
lastd=$(cat /vagrant/lastrun)
nowd=$(LANG=C date +%d/%b/%Y:%H:%M:%S)

# Объявление функций
function sortip {
  echo "Список IP адресов с наибольшим количеством запросов и указанием их количества за период с $lastd по $nowd"
}

function sorturl {
  echo "Список запрашиваемых URL с наибольшим количеством запросов и указанием их количества за период с $lastd по $nowd"
}

function allcode {
  echo "Список всех кодов HTTP ответа с указанием их кол-ва за период с $lastd по $nowd"
}

function err {
  echo "Ошибки веб-сервера/приложения за период с $lastd по $nowd"
}

function line {
  echo "=================================================================================================================" 
}

function string {
  echo " "
}

# Формирование отчёта
# =====================

sortip > access_report
line >> access_report
string >> access_report

# Сортировка по IP:
cat /vagrant/access.log | sed 's/\[//g' | awk -v Lastd="$lastd" -v Nowd="$nowd" '$4 > Lastd && $4 < Nowd {print $1}' | sort -g | uniq -c | sort -gr | sed 's/^[ ^t]*//' | head -n20 >> access_report

string >> access_report
sorturl >> access_report
line >> access_report
string >> access_report

# Сортировка по URL
cat /vagrant/access.log | sed 's/\[//g' | awk -v Lastd="$lastd" -v Nowd="$nowd" '$4 > Lastd && $4 < Nowd {print $11}' | sort -gr | uniq -c | sort -gr | sed 's/^[ ^t]*//' | head -n20 >> access_report

string >> access_report
allcode >> access_report
line >> access_report
string >> access_report

# Список всех кодов HTTP ответа
cat /vagrant/access.log | sed 's/\[//g' | awk -v Lastd="$lastd" -v Nowd="$nowd" '$4 > Lastd && $4 < Nowd {print $9}' | sort -gr | uniq -c | sort -gr | sed 's/^[ ^t]*//' >> access_report

string >> access_report
err >> access_report
line >> access_report
string >> access_report

# Строки с ошибкой сервера/приложения
cat /vagrant/access.log | awk '$9 ~ /400|403|405|499|500/' | sed 's/\[//g' | awk -v Lastd="$lastd" -v Nowd="$nowd" '$4 > Lastd && $4 < Nowd {print $0}' >> access_report

# Контроль времени запуска скрипта
LANG=C date +%d/%b/%Y:%H:%M:%S > lastrun

# Контроль активности скрипта
rm /vagrant/script.pid


