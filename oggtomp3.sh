#!/bin/bash

cd ~/Music/Strange\ dude\ and\ AI/2023\ -\ Soundraw

for i in *.ogg
do
  ffmpeg -i "$i" -acodec libmp3lame "${i%.*}.mp3"
done

read -p "Видалити файли .ogg? [Y/n]: " remove_ogg

if [[ $remove_ogg == "Y" || $remove_ogg == "y" ]]; then
  for i in *.ogg
  do
    rm "$i"
  done
  echo "Файли .ogg успішно видалено."
else
  echo "Файли .ogg залишено."
fi
