#!/bin/bash
VER="0.1"
roms=roms
function pause(){ read -p "Press ENTER to continue...."
}
function exitscr(){
 clear
 echo Redmi Lazy Tools for linux $VER. Russanandres 2022.
 date
 exit
}
trap "exitscr" SIGINT
if [ "$1" == "-v" ]; then echo $VER; exit
elif [ "$1" == "-h" ]; then
echo Какое рекавери для чего?
echo
echo OrangeFox A12 FBEv1
echo Отлично подойдёт для MIUI 13 на Android 12.
echo А так же для кастомов которые используют шифрование FBEv1.
echo
echo OrangeFox A12 FBEv2
echo Для кастомов с шифрованием FBEv2 , например официальной LineageOS 19.1.
echo
echo OrangeFox A11
echo Название говорит само за себя. Для Android 11, a так же для любой MIUI 12 на Android 11.
echo
echo LineageOS 18.1
echo Для официальных сборок LineageOS 18.1, ибо больше никакое рекавери эти сборки не сожрёт.
echo Полагаю что для неофициальных сборок 18.1 и других 19.1 [от других разработчиков] тоже сгодится.
echo Так же это рекавери теоретически может шить кастомы на А12 [способно шить неофициальные сборки LineageOS 19.1 от dereference23].
echo
echo LineageOS 19.1.
echo Название говорит само за себя. Для официальных сборок LineageOS 19.1. Думаю кастомы A12 должно шить спокойно.
echo
echo TWRP 3.6.2 A12 FBEv2
echo TWRP от автора неофициальных и официальных сборок LOS 19.1 dereference23.
echo По идее способно ставить любой А12 кастом с шифрованием FBEv2
echo Рекомендуется для crDroid 8 ветки.
exit
elif [ "$1" == "--roms" ]; then
 if [ -z "$2" ]; then
 echo после аргумента --roms напишите название папки
 echo
 echo Пример: bash linux.sh --roms redmi
 exit
 fi
roms=$2
fi
function installrom(){
if [ ! -f ./$roms/* ]; then
echo Файлы в папке для прошивок не найдены! Задайте папку с помощью аргумента --roms или создайте её в каталоге со скриптом с названием roms;exit
fi
cd ./$roms
ls
echo
echo
echo Напишите название файла прошивки [с окончанием zip]
read rom
echo Убедитесь что ваше устроиство находится в режиме sideload!
adb wait-for-device
adb sideload "$rom"
}
function upd(){
gitver=$(curl -f -# https://raw.githubusercontent.com/Russanandres/RLT_linux/main/lv)
 if [ "$gitver" -gt "$VER" ]; then
  echo У вас старая версия! Обновление через 3 секунды.
  sleep 3
 # if [ ! -f "./linux.sh" ]; then
  wget https://raw.githubusercontent.com/Russanandres/RLT_linux/main/rlt_upd.sh
  bash rlt_upd.sh
#  elif linuxu.sh https://raw.githubusercontent.com/Russanandres/RLT_linux/main/linux.sh
#  fi
exitscr
 fi
}

while true; do
clear
echo -e "Статус: \c"; adb get-state
echo [-] Вывести список устроиств и их состояние.
echo
echo [1] Обновить Firmware до MIUI 13
echo [2] Пофиксить проблемы с MIUI 12 после отката с MIUI 13
echo [3] Прошить оффициальное рекавери LinageOS 19.1
echo [4] Прошить оффициальное рекавери LinageOS 18.1
echo [5] Прошить OrangeFox Recovery Project для Android 11
echo [6] Прошить OrangeFox Recovery Project для Android 12 c FBEv1
echo [7] Прошить OrangeFox Recovery Project для Android 12 c FBEv2
echo [8] Прошить TeamWin Recovery Project для Android 12 c FBEv2
echo [9] Установить прошивку по adb sideload
echo [0] Установить Magisk по adb sideload
echo
echo [*] Любая кнопка - выход
echo [=] Проверить обновление.
echo
echo -e "Выберите:\c"
read -sn1 ch
case "$ch" in
"-" ) clear; adb devices; echo -e "Статус: \c"; adb get-state; pause;;

"1" ) clear; echo Убедитесь что ваше устроиство находится в режиме sideload!; adb wait-for-device; adb sideload "MIUI13 FW Update.zip";;
"2" ) clear; echo Убедитесь что ваше устроиство находится в режиме sideload!; adb wait-for-device; adb sideload "MIUI 12 Firmware_And_Persist.zip";;
"3" ) clear; echo Убедитесь что ваше устроиство находится в режиме fastboot!; fastboot erase recovery; fastboot --disable-verity --disable-verification flash recovery ./Recovery_Images/LOS19_1_A12.img;;
"4" ) clear; echo Убедитесь что ваше устроиство находится в режиме fastboot!; fastboot erase recovery; fastboot --disable-verity --disable-verification flash recovery ./Recovery_Images/LOSR.img;;
"5" ) clear; echo Убедитесь что ваше устроиство находится в режиме fastboot!; fastboot erase recovery; fastboot --disable-verity --disable-verification flash recovery ./Recovery_Images/ORFOX.img;;
"6" ) clear; echo Убедитесь что ваше устроиство находится в режиме fastboot!; fastboot erase recovery; fastboot --disable-verity --disable-verification flash recovery ./Recovery_Images/ORFOX_A12_FBEv1_MIUI13.img;;
"7" ) clear; echo Убедитесь что ваше устроиство находится в режиме fastboot!; fastboot erase recovery; fastboot --disable-verity --disable-verification flash recovery ./Recovery_Images/ORFOX_A12_FBEv2.img;;
"8" ) clear; echo Убедитесь что ваше устроиство находится в режиме fastboot!; fastboot erase recovery; fastboot --disable-verity --disable-verification flash recovery ./Recovery_Images/TWRP362_FBEv2-LOS191.img;;
"9" ) clear; installrom;;
"0" ) clear; echo Убедитесь что ваше устроиство находится в режиме sideload!; adb wait-for-device; adb sideload "Magisk.zip";;

"=" ) upd;;
* ) exitscr
esac
done
