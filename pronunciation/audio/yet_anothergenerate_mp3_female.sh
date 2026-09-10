#!/usr/bin/bash
# 発音練習用英文をssml形式にして、一時ファイルzzzに格納
awk -f pronunciation_making.awk input.txt > zzz
# ssml形式のzzzをamazon POLLYでmp3化
ssml2mp3_female.py zzz
# 一時ファイルを削除
rm zzz
