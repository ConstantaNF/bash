# ****Написать скрипт для CRON, который раз в час будет формировать письмо и отправлять на заданную почту.**** #

### Описание домашннего задания ###

Написать скрипт для CRON, который раз в час будет формировать письмо и отправлять на заданную почту.

Необходимая информация в письме:

* Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
* Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
* Ошибки веб-сервера/приложения c момента последнего запуска;
* Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта;
* Скрипт должен предотвращать одновременный запуск нескольких копий, до его завершения.

В письме должен быть прописан обрабатываемый временной диапазон.

### Выполнение ###

С помощью Vagrant разворачиваю Ubuntu Focal64 v20240513.0.0. Пишу скрипт для CRON.
Устанавливаю пакет mailx.
Далее добавляю скрипт в crontab:

```
crontab -e
```

```
  GNU nano 4.8                                                                      /tmp/crontab.1U3ZMF/crontab                                                                                
# Edit this file to introduce tasks to be run by cron.
# 
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
# 
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
# 
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
# 
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
# 
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
# 
# For more information see the manual pages of crontab(5) and cron(8)
# 
# m h  dom mon dow   command
SHELL=/bin/bash
MAILTO=konstantin.kanischev@yandex.ru
PATH=/sbin:/bin:/usr/sbin:/usr/bin
HOME=/vagrant
@hourly ~/script.sh && cat access_report | mail -s "Access_report" konstantin.kanischev@yandex.ru
```

