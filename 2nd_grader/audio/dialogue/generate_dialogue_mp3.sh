#!/usr/bin/bash
#対話文input_dialogue.txt(各行が発話。同一人物の発話中で改行しないこと)
awk -f dialogue2ssml.awk input_dialogue.txt > zzz
#一時ファイルzzzにはいっているssmlをAMAZON Pollyでmp3化
ssml2dialogue.py zzz
#一時ファイルzzzを消去
rm zzz

