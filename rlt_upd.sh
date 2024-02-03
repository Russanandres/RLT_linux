#!/bin/bash
VER="1"
roms=roms
function pause(){ read -p "Press ENTER to continue....";}
function exitscr(){
 clear
 echo "Redmi Lazy Tools for linux $VER. Russanandres 2024."
 date
 exit
}
trap "exitscr" SIGINT

while [ "$1" != "" ]; do
    case $1 in
        -v ) echo $VER; exit;;
        -h | --help )       helpscr;;
        -r | --roms )  if [ -z "$2" ]; then echo -e "После аргумента --roms напишите название папки\nПример: bash linux.sh --roms redmi";exit;fi;roms=$2;shift;;
    esac
    shift
done



function helpscr(){
echo -e "Какое рекавери для чего?

OrangeFox A12 FBEv1
Отлично подойдёт для MIUI 13 на Android 12.
А так же для кастомов которые используют шифрование FBEv1.

OrangeFox A12 FBEv2
Для кастомов с шифрованием FBEv2 , например официальной LineageOS 19.1.

OrangeFox A11
Название говорит само за себя. Для Android 11, a так же для любой MIUI 12 на Android 11.

LineageOS 18.1
Для официальных сборок LineageOS 18.1, ибо больше никакое рекавери эти сборки не сожрёт.
Полагаю что для неофициальных сборок 18.1 и других 19.1 [от других разработчиков] тоже сгодится.
Так же это рекавери теоретически может шить кастомы на А12 [способно шить неофициальные сборки LineageOS 19.1 от dereference23].

LineageOS 19.1.
Название говорит само за себя. Для официальных сборок LineageOS 19.1. Думаю кастомы A12 должно шить спокойно.

TWRP 3.6.2 A12 FBEv2
TWRP от автора неофициальных и официальных сборок LOS 19.1 dereference23.
По идее способно ставить любой А12 кастом с шифрованием FBEv2
Рекомендуется для crDroid 8 ветки."
exit; }


function installrom(){
if [ ! -f ./$roms/* ]; then
echo "Файлы в папке для прошивок не найдены! Задайте папку с помощью аргумента --roms или создайте её в каталоге со скриптом с названием roms";exit
fi
cd ./$roms;ls
echo -e "\n\nНапишите название файла прошивки [с окончанием zip]"
read rom
echo "Убедитесь что ваше устроиство находится в режиме sideload!"
adb wait-for-device
adb sideload "$rom"
}


function flashfastboot(){ clear; echo "Убедитесь что ваше устроиство находится в режиме fastboot!"; fastboot erase recovery; fastboot --disable-verity --disable-verification flash recovery $@;}
function flashsideload(){ clear; echo Убедитесь что ваше устроиство находится в режиме sideload!; adb wait-for-device; adb sideload $@;}

while true; do clear
echo -e "Статус: \c"; adb get-state
echo "[-] Вывести список устроиств и их состояние.

[1] Обновить Firmware до MIUI 13
[2] Пофиксить проблемы с MIUI 12 после отката с MIUI 13
[3] Прошить оффициальное рекавери LinageOS 19.1
[4] Прошить оффициальное рекавери LinageOS 18.1
[5] Прошить OrangeFox Recovery Project для Android 11
[6] Прошить OrangeFox Recovery Project для Android 12 c FBEv1
[7] Прошить OrangeFox Recovery Project для Android 12 c FBEv2
[8] Прошить TeamWin Recovery Project для Android 12 c FBEv2
[9] Установить прошивку по adb sideload
[0] Установить Magisk по adb sideload

[*] Любая кнопка - выход
"
echo -e "Выберите:\c"
read -sn1 ch
case "$ch" in
"-" ) clear; adb devices; echo -e "Статус: \c"; adb get-state; pause;;
"1" ) flashsideload ./"MIUI13 FW Update.zip";;
"2" ) flashsideload ./"MIUI 12 Firmware_And_Persist.zip";;
"3" ) flashfastboot ./Recovery_Images/LOS19_1_A12.img;;
"4" ) flashfastboot ./Recovery_Images/LOSR.img;;
"5" ) flashfastboot ./Recovery_Images/ORFOX.img;;
"6" ) flashfastboot ./Recovery_Images/ORFOX_A12_FBEv1_MIUI13.img;;
"7" ) flashfastboot ./Recovery_Images/ORFOX_A12_FBEv2.img;;
"8" ) flashfastboot ./Recovery_Images/TWRP362_FBEv2-LOS191.img;;
"9" ) clear; installrom;;
"0" ) flashsideload ./"Magisk.zip";;
* ) exitscr
esac
done
