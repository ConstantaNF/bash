#!/bin/bash

# Контроль активности скрипта
if [ -f /vagrant/script.pid ]; then
  echo "Скрипт в данный момент запущен. Параллельный запуск не воможен"
  exit 1
fi
touch /vagrant/script.pid

# Объявление функций
function sortip {
  echo "Список IP адресов с наибольшим количеством запросов и указанием их количества"
}

function sorturl {
  echo "Список запрашиваемых URL с наибольшим количеством запросов и указанием их количества"
}

function allcode {
  echo "Список всех кодов HTTP ответа с указанием их кол-ва"
}

function err {
  echo "Ошибки веб-сервера/приложения"
}

function line {
  echo "====================================================================================" 
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
# объявление переменных
lastd=$(cat /vagrant/lastrun)
nowd=$(LANG=C date +%d/%b/%y:%H:%M:%S)

# сортировка
cat /vagrant/access.log | sed 's/\[//g' | awk -v last_run="$lastd" -v Now="$nowd" '$4 > last_run && $4 < Now {print $1}' | sort -g | uniq -c | sort -gr | sed 's/^[ ^t]*//' | \
head -n20 >> access_report

string >> access_report
sorturl >> access_report
line >> access_report
string >> access_report

# Сортировка по URL
cat /vagrant/access.log | awk '{print $11}' | sort -gr | uniq -c | sort -gr | sed 's/^[ ^t]*//' >> access_report

string >> access_report
allcode >> access_report
line >> access_report
string >> access_report

# Список всех кодов HTTP ответа
cat /vagrant/access.log | awk '{print $9}' | sort -gr | uniq -c | sort -gr | sed 's/^[ ^t]*//' >> access_report

string >> access_report
err >> access_report
line >> access_report
string >> access_report

# Строки с ошибкой сервера/приложения
cat /vagrant/access.log | awk '$9 ~ /400|403|405|499|500/' >> access_report

# Контроль времени запуска скрипта
LANG=C date +%d/%b/%y:%H:%M:%S > lastrun

# Контроль активности скрипта
rm /vagrant/script.pid


