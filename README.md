---
editor_options: 
  markdown: 
    wrap: 72
---

# english_slides


# ffmpegを利用してmp3から不要な個所を取り除く方法

```{bash}
# 0秒から210秒までを抽出
ffmpeg -i hoge.mp3 -ss 0 -to 210 -c copy part1.mp3

# 215秒から318秒までを抽出
ffmpeg -i hoge.mp3 -ss 215 -to 318 -c copy part2.mp3

# 328秒以降を抽出
ffmpeg -i hoge.mp3 -ss 328 -c copy part3.mp3
```

```{bash}
# 結合リストを作成
echo "file 'part1.mp3'" > file_merge_list.txt
echo "file 'part2.mp3'" >> file_merge_list.txt
echo "file 'part3.mp3'" >> file_merge_list.txt
```

# 結合コマンド
ffmpeg -f concat -safe 0 -i file_merge_list.txt -c copy output.mp3
```


# ffmpegを利用してfoo.mp3とbar.mp3を5秒の空白を挟んで結合する方法

以下の手順で実行できます。

## 1. 5秒の空白音声ファイルを作成

まず、5秒の空白音声ファイル（silent.mp3）を作成します。

``` bash
ffmpeg -f lavfi -t 5 -i anullsrc=r=44100:cl=stereo -q:a 9 -acodec libmp3lame silent.mp3
```

## 入力ファイルリストを作成

foo.mp3、silent.mp3、bar.mp3の順に結合するための入力ファイルリストを作成します。このリストを
file_merge_list.txt として保存します。

file_merge_list.txt の内容：

```         
file 'foo.mp3'
file 'silent.mp3'
file 'bar.mp3'
```

## ファイルを結合

ffmpegを使用して、これらのファイルを結合します。

```         
ffmpeg -f concat -safe 0 -i file_merge_list.txt -c copy output.mp3
```

# 音声ファイル作成(AMAZON POLLYで)

## bashのスクリプトファイルを作った

file名はgenerate_mp3.shにした。

```         
#!/usr/bin/bash
# 発音練習用英文をssml形式にして、一時ファイルzzzに格納
awk -f pronunciation_making.awk input.txt > zzz
# ssml形式のzzzをamazon POLLYでmp3化
ssml2mp3.py zzz
# 一時ファイルを削除
rm zzz
```

これでinut.txtの各業に英語の例文を入れておいて `./generate_mp3.sh`
とすればoutput.mp3ができあがる。このoutput.mp3のファイル名を適当に変えればOK

## listen + repeat(通常の発音練習用)

input.txt

```         
This is a pen.
I am a boy
```

のような感じ。

```         
awk -f pronunciation_making.awk input.txt
```

pronunciation_making.awkの内容はつぎのとおり。

```         
BEGIN {
    print "<speak>"
    print "    <p>"
    print "        <s>"
    print "            <prosody volume=\"soft\">"
    print "                <lang xml:lang=\"ja-JP\">"
    print "                    さあ、実際の音声によく耳をかたむけてください。"
    print "                    <break time=\"1s\" />"
    print "                    それぞれの英文を二回読みます。"
    print "                    <break time=\"1s\" />"
    print "                    はじめはうまく聞き取れなくても、心配する必要はありません。"
    print "                    <break time=\"1s\" />"
    print "                    だんだん慣れてきます。"
    print "                    <break time=\"1s\" />"
    print "                    それでは、始めます。"
    print "                    <break time=\"1s\" />"
    print "                </lang>"
    print "            </prosody>"
    print "        </s>"
    print "    </p>"
    print "</speak>"
    print ""
    print "<speak>"
    print "    <p>"
    print "        <s>"
    print "            <prosody rate=\"slow\" volume=\"loud\">"
    print "                Please listen carefully."
    print "                <break time=\"1s\" />"
}

{
    printf "                Number %d.\n", NR
    printf "                <break time=\"1s\" />\n"
    printf "                %s\n", $0
    printf "                <break time=\"2s\" />\n"
    printf "                %s\n", $0
    printf "                <break time=\"3s\" />\n"
}

END {
    print "            </prosody>"
    print "        </s>"
    print "    </p>"
    print "</speak>"
    print ""
    print "<speak>"
    print "    <p>"
    print "        <s>"
    print "            <prosody volume=\"soft\">"
    print "                <lang xml:lang=\"ja-JP\">"
    print "                    さあ、いかがでしたか。"
    print "                    <break time=\"1s\" />"
    print "                    こんどは、あとに続けて実際にリピートしてください"
    print "                    <break time=\"1s\" />"
    print "                </lang>"
    print "            </prosody>"
    print "        </s>"
    print "    </p>"
    print "</speak>"
    print ""
    print "<speak>"
    print "    <p>"
    print "        <s>"
    print "            <prosody rate=\"slow\" volume=\"loud\">"
    print "                Please repeat after me."
    print "                <break time=\"1s\" />"
    for (i = 1; i <= NR; i++) {
        printf "                Number %d.\n", i
        printf "                <break time=\"1s\" />\n"
        printf "                %s\n", lines[i]
        printf "                <break time=\"5s\" />\n"
        printf "                %s\n", lines[i]
        printf "                <break time=\"3s\" />\n"
    }
    print "                Good job, everyone!"
    print "                <break time=\"1s\" />"
        print "            </prosody>"
    print "        </s>"
    print "    </p>"
    print "</speak>"
}

{
    lines[NR] = $0
}
```

これでssmlファイルができる。

これを

```         
ssml2mp3.py <input_ssml_file>
```

これでoutput.mp3(これは決め打ち)ができるので、適当にリネームすればいい。

なお、ssml2mp3.pyは以下の通り。 このスクリプトでは,
<speak></speak>の中身を英語と日本語を混在させないこと。たとえばつぎみたいにする。
こうすれば、日本語も英語もネイティブになる。
ここを参考にして少しいじった。
https://slides.takanory.net/slides/20240417pythonkansai/#/

```         
<speak>
    <p>
        <s>
            <prosody rate="slow" volume="loud">
            english only.
           </prosody>
        </s>
    </p>
</speak>

<speak>
    <p>
        <s>
            <prosody volume="soft">
                <lang xml:lang="ja-JP">
                    ここは日本語だけ
                </lang>
            </prosody>
        </s>
    </p>
</speak>
```

pythonスクリプトはつぎのとおり

```         
#!/usr/bin/env python3
import re
import sys
from contextlib import closing
from pathlib import Path
import boto3

def text2speech(polly, text, f, voice):
    """指定した声で読み上げる"""
    result = polly.synthesize_speech(
        Text=text,
        OutputFormat="mp3",
        VoiceId=voice,
        TextType="ssml"  # SSML形式のテキストを指定
    )
    with closing(result["AudioStream"]) as stream:
        f.write(stream.read())

if len(sys.argv) != 2:
    print("Usage: python3 script.py <input_ssml_file>")
    sys.exit(1)

input_file = sys.argv[1]

try:
    polly = boto3.client('polly')

    # Lexiconを名前をつけて登録
    LEXICON = "DBLexicon"
    script_dir = Path(__file__).parent
    lexicon_path = script_dir / "db-lexicon.xml"
    data = lexicon_path.read_text(encoding="utf-8")
    polly.put_lexicon(Name=LEXICON, Content=data)

    # ファイルから問題文読み込み
    p = Path(input_file)
    text = p.read_text(encoding="utf-8")

    with open("output.mp3", "wb") as f:
        # 日本語と英語のセクションを分離するための正規表現パターン
        sections = re.split(r'(<speak>.*?</speak>)', text, flags=re.DOTALL)

        for section in sections:
            if '<lang xml:lang="ja-JP">' in section:
                text2speech(polly, section, f, "Takumi")
            elif '<speak>' in section:
                text2speech(polly, section, f, "Matthew")

except Exception as e:
    print(f"An error occurred: {e}")
    sys.exit(1)
```

## 発音練習用mp3作成(アルファベットクイズ)

input_alphabe.txtを作っておく

quiz_maiking.awk を作成してある

```         
BEGIN {
    FS = ""
    RS = "\n"
}

{
    letter_count = NF
    
    print "<speak>"
    print "<prosody volume=\"x-loud\" rate=\"slow\">"
    print "<p>Here is today's quiz. I will say " letter_count " letters in a row. Please listen carefully and write them down. These letters will form a word. Please choose what that word represents.<break time=\"3s\"/></p>"
    
    print "<p>"
    for (i = 1; i <= NF; i++) {
        printf "%s.<break time=\"2s\"/>\n", $i
    }
    print "</p>"

    print "<p><lang xml:lang=\"ja-JP\">もう一度いいます。</lang>Please listen carefully and write them down.</p>"
    
    print "<p>"
    for (i = 1; i <= NF; i++) {
        printf "%s.<break time=\"2s\"/>\n", $i
    }
    print "</p>"
    
    print "<p>Good job, everyone! Let's check the answer.</p>"
    print "</prosody>"
    print "</speak>"
    print "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
}
```

### 使い方

```         
awk -f quiz_making.awk input.txt > quiz_manuscript.txt
```

quiz_manuscript.txtにSSMLのソースがはいっているので、
使う部分を切り出してqqqというテンポラリファイルにいれてから

```         
txt2mp3.py qqq
```

とすると、output.mp3（いまのところ、これは決め打ち)ができる。これを中身に合わせたファイル名にすればいい。

## upload用のpdf作成方法

オリジナルファイルからアップロード用に一部のページを抽出したpdfを作成する。
pdftkをインストールしておくこと。

```         
pdftk original.pdf cat 3-4 16-65 output ./upload_archive/2024-06-28/hogehoge.pdf
```

## Chat-GPTのプロンプト

あなたは英語のネイティブスピーカーで、外国人への英語教育の専門家です。
いま、日本の中学生対象に練習問題を作成しています。
以下の【例】のように「ソース」から問題を作成します。「課題」の「ソース」をもとにして「問題」を作成してください。
問題は ・ソースの和訳
・ソースの語句をランダムに並べ替えて、スラッシュで区切って()でくくった部分
・ソースの英文を{}で括って、さらに先頭に\visible<2->を追加した部分
から成り立たせます。

ソースが2行以上に渡るときは、その各行に対して問題を作成してください。

【例】 ソース： I am going to play tennis tomorrow. 問題：
わたしは明日テニスをするつもりです。 ( to / tennis / am / tomorrow /
going / I / play ) \visibe<2->{I am going to play tennis tomorrow.}

【課題】 ソース： I will not eat sushi for dinner. She will not watch TV
tonight. They will not buy a new car. It will not rain tomorrow. \##
テキストからmp3ファイルをAmazon Pollyで作成

走り書き

読み上げたい文章をテキストファイルで作成し、それにAmazon
Pollyのタグを追加。そのファイルをzzzとすると

```         
txt2mp3.py zzz
```

とする。

## default regeon をアメリカ東海岸に

```         
Sys.setenv(AWS_DEFAULT_REGION="us-east-1")
```

## Rmdから音声付きの動画を作成

```         
library(ari)
ari::ari_narrate(
  script = "1st_grader/001_alphabet.Rmd",
  slides = "1st_grader/001_alphabet.html",
  output = "1st_grader/video/001_oyoyo.mp4",
  voice  = "Joanna",
  delay = 10,
  zoom = 2,
  capture_method = "iterative"
  )
```

## pdfから静止画像を抽出

```         
pdftoppm -jpg hoge.pdf hoge
```

## 静止画像から動画を作成

```         
ffmpeg -loop 1 -i input.png  -vcodec libx264 -pix_fmt yuv420p -t 3 -r 30 output.mp4
```

このコードは、FFmpegを使用して静止画（input.png）を動画ファイルに変換するためのコマンド。

具体的には、

-   `-loop 1` :
    入力画像を1回繰り返し処理するように指定。これにより、入力画像がループして表示される
-   `-i input.png` : 入力として `input.png`
    ファイルを指定。これは静止画のファイル
-   `-vcodec libx264` : 動画のビデオコーデックを libx264
    に指定します。これはH.264形式のビデオコーデック
-   `-pix_fmt yuv420p` : 動画のピクセルフォーマットを yuv420p
    に指定します。これは一般的なピクセルフォーマットで、広くサポートされています。
-   `-t 3` :
    出力動画の長さを3秒に指定。この場合、入力画像が3秒間表示される
-   `-r 30` :
    出力動画のフレームレートを30fpsに指定。つまり、1秒あたり30枚のフレームが表示される
-   `output.mp4` : 出力ファイルの名前を指定

したがって、このコマンドは、`input.png`
ファイルを1つのフレームとして持つ動画ファイルを作成し、その長さを3秒、フレームレートを30fpsに設定。出力ファイルを
`output.mp4` として保存

## 動画に音声を追加

```         
ffmpeg -i video.mp4 -i video.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 output.mp4
```

このコードは、FFmpegを使用してビデオファイルとオーディオファイルを結合し、新しいビデオファイルを作成するためのコマンド。

具体的には、：

-   `-i video.mp4` : 入力として `video.mp4`
    ファイルを指定。これはビデオファイル。
-   `-i video.mp3` : 入力として `video.mp3`
    ファイルを指定。これはオーディオファイル。
-   `-c:v copy` :
    ビデオストリームをコピーすることを指定。つまり、元のビデオファイルのビデオデータはそのままで、再エンコードされません
-   `-c:a aac` : オーディオストリームをAAC形式でエンコードすることを指定
-   `-map 0:v:0` : 元のビデオファイルから最初のビデオストリームを選択。
-   `-map 1:a:0` : 第2の入力ファイルから最初のオーディオストリームを選択
-   `output.mp4` :
    出力ファイルの名前を指定。この場合、新しいビデオファイルの名前は
    `output.mp4`

したがって、このコマンドは `video.mp4` ファイルのビデオストリームと
`video.mp3` ファイルのオーディオストリームを結合し、新しいビデオファイル
`output.mp4` を作成。

# imager

imagerパッケージを用いて、写真から線画を作成する手順

```         
library(imager)
```

```         
img_1 <- load.image("./images/me_1.png")
plot(img_1)

gray_img_1 <- img_1 |> grayscale()
```

```         
img_2 <- load.image("./images/me_2.png")
plot(img_2)

gray_img_2 <- img_2 |> grayscale()
gray_img_2[ gray_img_2 > .45] =1
gray_img_2[ gray_img_2 <= .45] = 0
gray_img_2 |> plot()
```

```         
画像ファイルを読み込み
path <- "./images/me_1.png"
img <- load.image(path)

 白黒に
gray_img <- img |> grayscale()

 2値化。画素値が 0.375 より大きければそのピクセルの画素値は 1 にし、0.375以下なら 0 にすることで、白黒画像が作れます。
gray_img[ gray_img > .375] =1
gray_img[ gray_img <= .375] = 0

 思い切った線画にする（ただし黒地に白線）
nega_img <- gray_img |> isoblur(2) |> imgradient("xy") |> with(sqrt(x^2+y^2)) |> threshold() |> as.cimg() 
 画像を保存

imager::save.image(nega_img, "./images/nega_me.png")

保存した画像の白黒を逆転させるためにターミナルで

 convert -negate nega_me.png posi_me.png

 convertはimagemagickのコマンド
```

## another way

# アルファチャネル操作用の関数

```         
applyAlpha = function( cimg, alpha, reverse = F ){
  if( class( alpha )[ 1 ] == "cimg" ){
    if( reverse ){
      if( dim( cimg )[ 4 ] >= 3 ){
        return( imappend( list( R(cimg), G(cimg), B(cimg), 1 - alpha ), axis = "c" ) )
      } else {
        return( imappend( list( cimg, 1 - alpha ), axis = "c" ) )
      }
    } else {
      if( dim( cimg )[ 4 ] >= 3 ){
        return( imappend( list( R(cimg), G(cimg), B(cimg), alpha ), axis = "c" ) )
      } else {
        return( imappend( list( cimg, alpha ), axis = "c" ) )
      }
    }
  } else { # if alpha is an array
    if( reverse ){
      a = as.cimg( 1 - alpha, x = width( cimg ), y = height( cimg ), z = 1, cc = 1 )
      if( dim( cimg )[ 4 ] >= 3 ){
        return( imappend( list( R(cimg), G(cimg), B(cimg), a ), axis = "c" ) )
      } else {
        return( imappend( list( cimg, a ), axis = "c" ) )
      }
    } else {
      a = as.cimg( alpha, x = width( cimg ), y = height( cimg ), z = 1, cc = 1 )
      if( dim( cimg )[ 4 ] >= 3 ){
        return( imappend( list( R(cimg), G(cimg), B(cimg), a ), axis = "c" ) )
      } else {
        return( imappend( list( cimg, a ), axis = "c" ) )
      }
    }
  }
}

# 画像ファイルを読み込み
path <- "./images/me_1.png"
img <- load.image(path)
# 白黒に
gray_img <- img |> grayscale()
# 2値化。画素値が 0.375 より大きければそのピクセルの画素値は 1 にし、0.375以下なら 0 にすることで、白黒画像が作れます。
gray_img[ gray_img > .375] =1
gray_img[ gray_img <= .375] = 0
# 思い切った線画にする（ただし黒地に白線）
zzz <- gray_img |> isoblur(2) |> imgradient("xy") |> with(sqrt(x^2+y^2)) 
sketch <-  1 - threshold(zzz) |> as.cimg()
plot(sketch)
# 画像を保存
imager::save.image(sketch, "./images/oyoyo.png")
```

# 音声ファイル作成(Google Cloud TTSを利用)

Google Cloud TTSを利用して音声ファイルを作成する手順をまとめておく。

OpenAI tts-1だとssmlが利用できないみたいなので、Google Cloud TTSを利用する。

## 環境設定

### pythonライブラリのインストール

```
pip install google-cloud-texttospeech
```

### Google Cloud プロジェクトの設定:

- Google Cloudコンソールでプロジェクトを作成（または選択）します。
- ナビゲーションメニューから "Cloud Text-to-Speech API" を検索し、有効にします。

### サービスアカウントの作成と認証情報のダウンロード:

- ナビゲーションメニューから "IAMと管理" > "サービスアカウント" に移動します。
- "サービスアカウントを作成" をクリックし、名前と説明を入力します。
- "役割を選択" で "プロジェクト" > "オーナー" を選択します。
- "キーを作成" をクリックし、JSON形式でキーをダウンロードします。
- ダウンロードしたJSONファイルのパスを環境変数 `GOOGLE_APPLICATION_CREDENTIALS` に設定します。  

## pythonスクリプト

まえにつくったopen AI用のスクリプトを参考にしてつくった。
OpenAI用のスクリプトをGeminiにお願いしてGoogle TTS用に直してねといったところ
はじめはうまくいっていたが、英語と日本語をssmlで都度指定するように修正を入れてくれといったところ、どうしてもエラーが治らない。
ということで、とちゅうでGemini提案のスクリプトをChatGPTに投げたら、うまく修正してくれた。以下がそのスクリプト。

google_text2speech.pyというファイル名にしてシェバングをつけて実行権限を付与しておく。

使い方は次のとおり。

  ```
  google_text2speech.py  input_file output_file
  ```


```
#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
google_text2speech.py

Google Cloud Text-to-Speech API を使用して、
テキストまたは SSML ファイルから音声（MP3形式）を生成するスクリプト。

使い方:
    python google_text2speech.py input.txt output.mp3

前提条件:
    - pip install google-cloud-texttospeech
    - 環境変数 GOOGLE_APPLICATION_CREDENTIALS に
      サービスアカウントの JSON キーファイルの絶対パスを設定済みであること。
"""

import os
import argparse
from pathlib import Path
from google.cloud import texttospeech


def main():
    # ------------------------------------------------------------
    # ① コマンドライン引数の設定
    # ------------------------------------------------------------
    parser = argparse.ArgumentParser(
        description="Convert text/SSML to speech using Google Cloud TTS API."
    )
    parser.add_argument(
        "input_file",
        type=str,
        help="Path to the input text or SSML file (e.g., input.txt)."
    )
    parser.add_argument(
        "output_file",
        type=str,
        help="Path to the output MP3 file (e.g., output.mp3)."
    )
    args = parser.parse_args()

    # ------------------------------------------------------------
    # ② Google Cloud 認証確認
    # ------------------------------------------------------------
    # 環境変数 GOOGLE_APPLICATION_CREDENTIALS が設定されていない場合はエラー
    if os.getenv("GOOGLE_APPLICATION_CREDENTIALS") is None:
        raise EnvironmentError(
            "Environment variable 'GOOGLE_APPLICATION_CREDENTIALS' is not set.\n"
            "Please set it to the path of your Google Cloud service account JSON key."
        )

    # ------------------------------------------------------------
    # ③ Text-to-Speech クライアントの初期化
    # ------------------------------------------------------------
    # 認証情報をもとに Google Cloud TTS クライアントを生成
    client = texttospeech.TextToSpeechClient()

    # ------------------------------------------------------------
    # ④ 入力ファイルの存在確認と読み込み
    # ------------------------------------------------------------
    input_file_path = Path(args.input_file)
    output_file_path = Path(args.output_file)

    if not input_file_path.exists():
        raise FileNotFoundError(f"Input file not found: {input_file_path}")

    # UTF-8 で SSML またはテキストを読み込む
    with input_file_path.open("r", encoding="utf-8") as f:
        input_text = f.read()

    # ------------------------------------------------------------
    # ⑤ TTS API に送信するパラメータの準備
    # ------------------------------------------------------------
    # 入力は SSML として扱う（<speak> タグを使用している前提）
    synthesis_input = texttospeech.SynthesisInput(ssml=input_text)

    # 出力形式を MP3 に設定（WAVやLINEAR16に変更も可能）
    audio_config = texttospeech.AudioConfig(
        audio_encoding=texttospeech.AudioEncoding.MP3
    )

    # デフォルト音声設定
    # SSML 内の <voice> タグで上書きされるが、空指定エラーを避けるため必須
    voice = texttospeech.VoiceSelectionParams(
        language_code="ja-JP"  # デフォルトは日本語
    )

    # ------------------------------------------------------------
    # ⑥ 音声合成リクエストの送信
    # ------------------------------------------------------------
    print(f"Requesting synthesis for {input_file_path}...")

    # Google Cloud TTS API へリクエスト送信
    response = client.synthesize_speech(
        input=synthesis_input,
        voice=voice,
        audio_config=audio_config
    )

    # ------------------------------------------------------------
    # ⑦ 出力ファイルへの書き込み
    # ------------------------------------------------------------
    # response.audio_content は MP3 のバイナリデータ
    with output_file_path.open("wb") as out:
        out.write(response.audio_content)

    print(f"Speech saved to {output_file_path}")

    # ------------------------------------------------------------
    # 完了メッセージ
    # ------------------------------------------------------------
    # この段階で output_file_path に音声ファイルが生成される
    # SSMLに複数言語・話者を指定している場合は自動で切り替わる
    # ------------------------------------------------------------


# エントリーポイント（直接実行された場合のみ main() を呼び出す）
if __name__ == "__main__":
    main()
```

##  ssmlファイル


実際に入力ファイルとして使うssmlファイルの例を以下に示す。


言語指定はlanguageで行う。genderを指定すると男性女性の声になる。
nameは指定しなくてもよいが、
指定すると特定の声になる。このときgenderの指定は無視されるみたい。

### 英語の場合

| 音声名 (Name) | 性別 |
| :--- | :--- |
| `en-US-Wavenet-A` | **男性** |
| `en-US-Wavenet-B` | **男性** |
| `en-US-Wavenet-C` | **女性** |
| `en-US-Wavenet-D` | **男性** |
| `en-US-Wavenet-E` | **女性** |
| `en-US-Wavenet-F` | **女性** |
| `en-US-Wavenet-G` | **女性** |
| `en-US-Wavenet-H` | **女性** |
| `en-US-Wavenet-I` | **男性** |
| `en-US-Wavenet-J` | **男性** |


### 日本語
| 音声名 (Name) | 性別 |
| :--- | :--- |
| `ja-JP-Wavenet-A` | **女性** |
| `ja-JP-Wavenet-B` | **男性** |
| `ja-JP-Wavenet-C` | **女性** |
| `ja-JP-Wavenet-D` | **男性** |


```
<speak>
  <voice language="ja-JP" name="ja-JP-Wavenet-C" gender="MALE">
    皆さん、こんにちは。
    私は日本語の男性の声です。
    次は女性の声に切り替わります。
  </voice>

  <voice language="ja-JP" name="ja-JP-Wavenet-A" gender="FEMALE">
    はい、こんにちは。
    私は日本語の女性の声です。
    <break time="700ms"/>
    では次に、英語の男性の声をお聞きください。
  </voice>

  <voice language="en-US" name="en-US-Wavenet-A" gender="MALE">
    <prosody rate="0.9">
      Hello everyone.
      My name is David.
      This is an English male voice from Google Cloud Text-to-Speech.
      <break time="1s"/>
    </prosody>
  </voice>

  <voice language="en-US" name="en-US-Wavenet-C" gender="FEMALE">
    <prosody rate="0.9">
      Hello everyone. My name is Jennifer Jareaux. This is an English female voice from Google Cloud Text-to-Speech.
    </prosody>
  </voice>
</speak>
```


# beamerを音声つき動画にする

beamerで作成したスライドを音声付きの動画にする手順をまとめておく。

## 環境設定

### pythonライブラリのインストール

既にinストーリ済みなら不要です

```
pip install google-cloud-texttospeech
```

### Google Cloud プロジェクトの設定:

以下もすでに設定済みであればスキップ

- Google Cloudコンソールでプロジェクトを作成（または選択）します。
- ナビゲーションメニューから "Cloud Text-to-Speech API" を検索し、有効にします。

### サービスアカウントの作成と認証情報のダウンロード:

これも設定済みならスキップ

- ナビゲーションメニューから "IAMと管理" > "サービスアカウント" に移動します。
- "サービスアカウントを作成" をクリックし、名前と説明を入力します。
- "役割を選択" で "プロジェクト" > "オーナー" を選択します。
- "キーを作成" をクリックし、JSON形式でキーをダウンロードします。
- ダウンロードしたJSONファイルのパスを環境変数 `GOOGLE_APPLICATION_CREDENTIALS` に設定します。  

## pythonスクリプト

geminiに提案してもらったスクリプトをベースに、さらに改良してもらったもの。

beamer2_video.pyというファイル名にしてシェバングをつけて実行権限を付与しておく。

コマンドラインで
beamer2_video.py input_file.tex
とすると、input_file.mp4ができる。

スクリプト名はbeamer2_video.pyとしてあるが、texファイルなら動くと思う。
ただし、エンジンはlualatexを使うようにしてあるので、そこは注意。

texファイルの具体例は後で掲載しておく。

## 機能まとめ

- SSML対応: <break time="1s"/> などのタグを自動認識して反映します。
- 文字化け対策: PDFからテキストを安全に読み取る強力なデコーダーを搭載。
- 日英自動切替: 文章内の言語を判定し、適切なネイティブ音声（日本語/英語）に切り替えます。
- 性別指定: コマンドライン引数で男女の声を選べます。
- 安全性: 動画サイズを偶数に補正し、FFmpegのクラッシュを防ぎます。
- 注釈アイコン非表示対応: TeX側の /F 2 設定と組み合わせて動作します（スクリプト側は変更なしでOK）。

```
#! /usr/bin/env python

import os
import re
import sys
import argparse
import subprocess
from pathlib import Path
from google.cloud import texttospeech
from pypdf import PdfReader
from pypdf.generic import TextStringObject, ByteStringObject
from pdf2image import convert_from_path

def show_usage():
    print("""
Usage: beamer2_video.py <input_file.tex> [options]

Options:
  -h, --help           Show this help message and exit.
  --ja-gender {m,f}    Set Japanese voice gender (m=male, f=female). Default: f
  --en-gender {m,f}    Set English voice gender (m=male, f=female). Default: f

Description:
  Converts a Beamer LaTeX file into an MP4 video using Google Cloud TTS.
  - Requires: LuaLaTeX, FFmpeg, Poppler, Google Cloud Credentials.
  - Supports: SSML tags (e.g., <break time="1s"/>), Mixed languages.
""")

def compile_tex(tex_file):
    """LuaLaTeXでTeXファイルをコンパイルする"""
    print(f">>> 1. Compiling LaTeX ({tex_file})...")
    subprocess.run(["lualatex", "--interaction=nonstopmode", tex_file], check=True)

def get_safe_text(pdf_object):
    """
    pypdfのオブジェクトからテキストを安全に抽出する強力なデコーダー
    """
    # 1. まずはバイト列(bytes)を取り出す
    raw_bytes = None
    
    if isinstance(pdf_object, ByteStringObject) or isinstance(pdf_object, bytes):
        raw_bytes = bytes(pdf_object)
    elif isinstance(pdf_object, TextStringObject) or isinstance(pdf_object, str):
        try:
            # 既に文字列になっている場合、pypdfがLatin-1で誤読した可能性が高いため
            # Latin-1でエンコードして元のバイト列に戻す
            raw_bytes = pdf_object.encode("latin-1")
        except UnicodeEncodeError:
            # Latin-1に戻せない文字がある＝既に正しくデコードされている可能性が高い
            return pdf_object

    if raw_bytes is None:
        return ""

    # 2. 順次デコードを試みる
    # LuaLaTeXの場合、UTF-8が最有力だが、PDF仕様的にはUTF-16BEも多い
    encodings = ["utf-8", "utf-16-be", "utf-16-le", "shift_jis"]
    
    for enc in encodings:
        try:
            return raw_bytes.decode(enc)
        except UnicodeDecodeError:
            continue
    
    # 全滅した場合はLatin-1（文字化けするがエラーは出ない）で返す
    return raw_bytes.decode("latin-1", errors="ignore")

def is_japanese(text):
    """テキストに日本語文字が含まれているか判定する"""
    pattern = r'[ぁ-んァ-ン一-龥]'
    return re.search(pattern, text) is not None

def generate_mixed_audio(client, text, voice_ja, voice_en, audio_config):
    """日英混合テキストを分割して音声を生成・結合する（SSML対応版）"""
    # 制御文字などを削除
    text = text.replace('\n', ' ').replace('\r', '')
    
    # 分割（日本語の塊 と それ以外）
    split_pattern = r'([ぁ-んァ-ン一-龥。、！？「」]+)'
    segments = re.split(split_pattern, text)
    
    combined_audio_content = b"" 
    segment_logs = []

    # SSMLタグっぽいものを含むか判定する正規表現
    ssml_tag_pattern = re.compile(r'<[^>]+>')

    for seg in segments:
        if not seg.strip():
            continue
            
        if is_japanese(seg):
            voice = voice_ja
            lang_label = "JA"
        else:
            voice = voice_en
            lang_label = "EN"
            
        # ログ表示用
        display_seg = seg[:15].replace('\n', '')
        
        try:
            # SSMLタグ判定
            if ssml_tag_pattern.search(seg):
                # SSMLとして送信 (<speak>で囲む)
                ssml_text = f"<speak>{seg}</speak>"
                synthesis_input = texttospeech.SynthesisInput(ssml=ssml_text)
                segment_logs.append(f"[{lang_label}/SSML]{display_seg}")
            else:
                # 通常テキストとして送信
                synthesis_input = texttospeech.SynthesisInput(text=seg)
                segment_logs.append(f"[{lang_label}]{display_seg}")

            response = client.synthesize_speech(
                input=synthesis_input, voice=voice, audio_config=audio_config
            )
            combined_audio_content += response.audio_content
            
        except Exception as e:
            print(f"      [Error] TTS segment failed: {e}")
            
    print(f"      Parsed: {' '.join(segment_logs)}")
    return combined_audio_content

def extract_narrations_and_generate_audio(pdf_file, ja_gender, en_gender):
    """PDFの注釈からテキストを抽出し、指定された性別で音声を生成する"""
    print(f">>> 2. Extracting text from {pdf_file} and Generating Audio...")
    
    client = texttospeech.TextToSpeechClient()
    
    # 性別設定
    ja_name = "ja-JP-Neural2-C" if ja_gender == 'm' else "ja-JP-Neural2-B"
    en_name = "en-US-Neural2-D" if en_gender == 'm' else "en-US-Neural2-F"

    print(f"    Voices: JA={ja_name}, EN={en_name}")

    voice_ja = texttospeech.VoiceSelectionParams(language_code="ja-JP", name=ja_name)
    voice_en = texttospeech.VoiceSelectionParams(language_code="en-US", name=en_name)
    audio_config = texttospeech.AudioConfig(audio_encoding=texttospeech.AudioEncoding.MP3)

    reader = PdfReader(pdf_file)
    audio_files = []

    for i, page in enumerate(reader.pages):
        text_parts = []
        if "/Annots" in page:
            for annot in page["/Annots"]:
                obj = annot.get_object()
                if obj["/Subtype"] == "/Text":
                    # 強力デコード関数を使用
                    raw_content = obj["/Contents"]
                    decoded_text = get_safe_text(raw_content)
                    text_parts.append(decoded_text)
        
        full_text = " ".join(text_parts).strip()
        print(f"   Slide {i+1}: Processing...") 

        filename = f"audio_{i:03d}.mp3"
        
        if full_text:
            try:
                audio_content = generate_mixed_audio(client, full_text, voice_ja, voice_en, audio_config)
                if audio_content:
                    with open(filename, "wb") as out:
                        out.write(audio_content)
                else:
                    generate_silent_mp3(filename)
            except Exception as e:
                print(f"      [Warning] TTS Error on Slide {i+1}: {e}")
                generate_silent_mp3(filename)
        else:
            generate_silent_mp3(filename)

        audio_files.append(filename)
    
    return audio_files

def generate_silent_mp3(filename):
    cmd = [
        "ffmpeg", "-y", "-f", "lavfi", "-i", "anullsrc=r=24000:cl=mono", 
        "-t", "1", "-q:a", "9", "-acodec", "libmp3lame", filename
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def pdf_to_images(pdf_file):
    print(f">>> 3. Converting {pdf_file} to Images...")
    images = convert_from_path(pdf_file, dpi=200)
    image_files = []
    for i, img in enumerate(images):
        filename = f"slide_{i:03d}.png"
        img.save(filename, "PNG")
        image_files.append(filename)
    return image_files

def create_video(image_files, audio_files, output_video):
    print(f">>> 4. Combining into Video ({output_video})...")
    
    segment_files = []
    
    for i, (img, aud) in enumerate(zip(image_files, audio_files)):
        seg_name = f"segment_{i:03d}.mp4"
        
        if not os.path.exists(aud) or os.path.getsize(aud) == 0:
            generate_silent_mp3(aud)

        # 画像サイズを偶数にするフィルタを追加
        cmd = [
            "ffmpeg", "-y", "-loop", "1", "-i", img, "-i", aud,
            "-vf", "scale=trunc(iw/2)*2:trunc(ih/2)*2",
            "-c:v", "libx264", "-tune", "stillimage", "-c:a", "aac",
            "-b:a", "192k", "-pix_fmt", "yuv420p", "-shortest", seg_name
        ]
        
        ret = subprocess.run(cmd, stderr=subprocess.DEVNULL)
        if ret.returncode != 0:
            print(f"      [Error] Failed to create segment {i}.")
            raise RuntimeError("FFmpeg failed.")
            
        segment_files.append(seg_name)

    list_file = "concat_list.txt"
    with open(list_file, "w") as f:
        for seg in segment_files:
            f.write(f"file '{seg}'\n")

    subprocess.run([
        "ffmpeg", "-y", "-f", "concat", "-safe", "0", "-i", list_file,
        "-c", "copy", output_video
    ], check=True)
    
    print(f">>> Done! Video saved as {output_video}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("filename", nargs="?", help="Input TeX file")
    parser.add_argument("--ja-gender", choices=['m', 'f'], default='f', help="Japanese voice gender")
    parser.add_argument("--en-gender", choices=['m', 'f'], default='f', help="English voice gender")
    parser.add_argument("-h", "--help", action="store_true")
    
    args = parser.parse_args()

    if args.help or not args.filename:
        show_usage()
        sys.exit(0)

    tex_path = Path(args.filename)
    if not tex_path.exists():
        print(f"Error: File '{tex_path}' not found.")
        sys.exit(1)

    base_name = tex_path.stem
    pdf_file = f"{base_name}.pdf"
    output_video = f"{base_name}.mp4"

    try:
        compile_tex(str(tex_path))
        audios = extract_narrations_and_generate_audio(pdf_file, args.ja_gender, args.en_gender)
        images = pdf_to_images(pdf_file)
        
        if len(images) != len(audios):
            print("Warning: Slide count and Audio count mismatch!")
            min_len = min(len(images), len(audios))
            images = images[:min_len]
            audios = audios[:min_len]
        
        create_video(images, audios, output_video)
        
    except Exception as e:
        print(f"\n[FATAL ERROR] {e}")

```

## texファイルの例

読み上げるテキストを
```
\narration{...}
```
とします。

スライド指定は
```
\only<n>{\narration{...}}
```
とします。nは数字。

以下が具体例ですが、かなり長いので、必要に応じて参照してください。
必須とあるところを実際のtexソースのプリアンブルに追加してください。

あとはdocument環境で、読み上げるテキストを
```
\only<n>{\narration{...}}
```
で囲んでください。

テキストにはssml記法いもけるとおもいます。

日本語も英語もネイティブの発音になります。

```
\documentclass[aspectratio=169,xcolor={dvipsnames,table}]{beamer}
\usepackage[no-math,deluxe,haranoaji]{luatexja-preset}
\renewcommand{\kanjifamilydefault}{\gtdefault}
\renewcommand{\emph}[1]{{\upshape\bfseries #1}}
\usetheme{metropolis}
\metroset{block=fill}
\setbeamertemplate{navigation symbols}{}
\setbeamertemplate{blocks}[rounded][shadow=false]
\usecolortheme[rgb={0.7,0.2,0.2}]{structure}
%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Change alert block colors
%%% 1- Block title (background and text)
\setbeamercolor{block title alerted}{fg=mDarkTeal, bg=mLightBrown!45!yellow!45}
\setbeamercolor{block title example}{fg=magenta!10!black, bg=mLightGreen!60}
%%% 2- Block body (background)
\setbeamercolor{block body alerted}{bg=mLightBrown!25}
\setbeamercolor{block body example}{bg=mLightGreen!15}
%%%%%%%%%%%%%%%%%%%%%%%%%%%
\input{myPreamble4Slide.tex}
\usepackage{pxrubrica}
\UseTblrLibrary{counter}%%%%tabularrayとpauseが衝突することを回避する
%\usepackage{lmodern}
\usetikzlibrary{tikzmark}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%これ以下は必須です
% 読み上げテキストをPDF注釈として埋め込むコマンド定義
% 修正後 ( \newcommand<> とすることでオーバーレイ引数を受け取れるようになります )
% ==============================================
% ここからプリアンブルの設定
% ==============================================
\usepackage{luacode} % これが必要です

% Luaを使ってテキストを「UTF-16BEの16進数」に変換する関数を定義
\begin{luacode*}
function to_utf16be_hex(str)
    local hex = "FEFF" -- BOM (Byte Order Mark)
    for p, c in utf8.codes(str) do
        if c < 0x10000 then
            hex = hex .. string.format("%04X", c)
        else
            -- サロゲートペア対応 (絵文字など)
            c = c - 0x10000
            local high = 0xD800 + math.floor(c / 1024)
            local low = 0xDC00 + (c % 1024)
            hex = hex .. string.format("%04X%04X", high, low)
        end
    end
    tex.print(hex)
end
\end{luacode*}

% \narrationコマンドの再定義(アイコン非表示版)
% テキストを (...) ではなく <...> (Hex形式) で埋め込みます
\newcommand<>{\narration}[1]{%
  \only#2{%
    \pdfextension annot width 0pt height 0pt depth 0pt {%
      /Subtype /Text
      /F 2  % <--- これを追加！ (Flag 2 = Hidden/非表示)
      /Contents <\directlua{to_utf16be_hex("\luaescapestring{#1}")}>%
    }%
  }%
}
% ==============================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%
\title{English is fun.}
\subtitle{天気について話そう}
\author{}
\institute[]{}
\date[]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TEXT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{document}

\begin{frame}[plain]
  \titlepage
% ここに読み上げさせたい文章を書く
    \narration{こんにちは。これは、エイピイアイを経由してグウグルの音声合成を使ったテスト動画です。}
    \narration{Hello, everybody. How are you doing today? Let's begin today's lesson!}
\end{frame}
%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section*{授業の流れ}
\begin{frame}[plain]
  \frametitle{授業の流れ}
  \tableofcontents
% ここに読み上げさせたい文章を書く
    \narration{Hello, folks. Let's learn how to express the weather in plain English.きょうは英語で天気の表現についていろいろ学習します。さあ、準備はいいですか。}
\end{frame}

\section{いろいろな天気}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{frame}[plain]{天気をあらわすさまざまな表現}


\begin{enumerate}
 \item How is the weather today?
 \item It is fine today.\hfill{\scriptsize fine \textipa{/f\'aIn/} \Circled{ 形 } 晴れた}
\item It is sunny today.\hfill{\scriptsize sunny \textipa{/s\'\textturnv ni/} \Circled{ 形 } 晴れた}
 \item It is cloudy today.\hfill{\scriptsize cloudy \textipa{/kr\'aUdi/} \Circled{ 形 } 曇った}
 \item It is rainy today.\hfill{\scriptsize rainy \textipa{/r\'eIni/} \Circled{ 形 } 雨の}
\item It is raining today.\hfill{\scriptsize rain \textipa{/r\'eIn/} \Circled{ 動 } 雨が降る}
  \item  It is snowy today.\hfill{\scriptsize snowy \textipa{/sn\'oUi/} \Circled{ 形 } 雪の}
\item It is snowing today.\hfill{\scriptsize snow \textipa{/sn\'oU/} \Circled{ 動 } 雪が降る}
\end{enumerate}

\begin{block}{Today's Points}\small
天気を表すときはItを主語にします
\begin{itemize}\setbeamertemplate{items}[square]\small
 \item It is 形容詞
 \item It 一般動詞
\end{itemize}
\end{block}
\hfill{\scriptsize \myaudio{./audio/003_weather_01.mp3}}

% ここに読み上げさせたい文章を書く
    \narration{ここにさまざまな表現をあげました。各英文に目を通してください。<break time="10s"/>これでおわかりのように天気をあらわすとき、英語では it を主語にしますよ。「それ」という意味は特になく、ばくぜんと天候を表しているとかんがえればいいでしょう。}
\end{frame}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{frame}<1-8>[plain]{Exercises}

日本語の意味になるよう空所に適当な語を補いましょう%
\hfill{\scriptsize \myaudio{./audio/003_weather_02.mp3}}

\begin{enumerate}
 \item (~~\visible<2->{How}~~) was the weather yesterday?\hspace{2\zw}昨日の天気はどうでしたか
 \item (~~~\visible<3->{It}~~~) is hot in (~~\visible<3->{August}~~).\hspace{2\zw}8月は暑い
 \item (~~~\visible<4->{It's}~~~) cold in winter.\hspace{2\zw}冬は寒い
 \item It (~~\visible<5->{snowed}~~) yesterday.\hspace{2\zw}昨日は雪でした
 \item It (~~\visible<6->{rains}~~) a lot in  (~~\visible<6->{June}~~).\hspace{2\zw}6月はたくさん雨が降る\hfill{\scriptsize a lot \textipa{/@ l\'At/}} とても
 \item (~~~\visible<7->{It}~~~) is windy  (~~\visible<7->{today}~~).\hspace{2\zw}今日は風が強い%
\hfill{\scriptsize windy \textipa{/w\'Indi/} 風の強い}
\end{enumerate}
% ここに読み上げさせたい文章を書く
    \narration<1>{さあ、ここで練習問題に取り組んでもらいましょう。これまで学習してきたことが身についているか、確認しますよ。それでは、はじめましょう。}
   \narration<2>{きのうの天気はどうでしたか。先頭の空所には「どんな。どのような」という意味の疑問詞 how がつかわれます。全体でよく使う慣用表現です。How was the weather yesterday.<break time="2s"/>How was the weather yesterday?}
   \narration<3>{では次の問題です。八月は暑い。It is hot in August. 主語が it であることに注意してください。}
   \narration<4>{冬は寒い。やはり it を主語にします。 でも空所がひとつしかありません。どうすればいいでしょうか。<break time="4s"/>It is の短縮形が正解です。}
   \narration<4>{It's cold in winter.}
   \narration<4>{では次の問題です。 }
   \narration<5>{きのうは雪が降った。 雪が降るという意味の動詞は snow です。きのうのことですから、過去形になります。}
   \narration<5>{It snowed yesterday.}
   \narration<5>{では次の問題。六月は雨がたくさん降る。梅雨のことをいっているのですね。雨が降るという意味の動詞はrainです。三人称単数現在に注意しましょう。六月はJuneです。}
   \narration<6>{It rains a lot in June.}
   \narration<6>{最後の問題です。windy、これは風が強いという意味の形容詞です。主語はやはり it です。きょうは、かんたんです。today.}
   \narration<7>{It is windy today. }
   \narration<8>{いかがでしたか。きょうは天候の表現について学習しました。That's all for today. Have a good day!}

\end{frame}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\end{document}
```

