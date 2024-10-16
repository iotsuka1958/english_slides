---
editor_options: 
  markdown: 
    wrap: 72
---

# english_slides


# ffmpegを利用してmp3から不要な個所を取り除く方法






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

# 音声ファイル作成

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
