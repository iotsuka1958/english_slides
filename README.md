# english_slides

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
  output = "1st_grader/video/001_alphabet.mp4",
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

- `-loop 1` : 入力画像を1回繰り返し処理するように指定。これにより、入力画像がループして表示される
- `-i input.png` : 入力として `input.png` ファイルを指定。これは静止画のファイル
- `-vcodec libx264` : 動画のビデオコーデックを libx264 に指定します。これはH.264形式のビデオコーデック
- `-pix_fmt yuv420p` : 動画のピクセルフォーマットを yuv420p に指定します。これは一般的なピクセルフォーマットで、広くサポートされています。
- `-t 3` : 出力動画の長さを3秒に指定。この場合、入力画像が3秒間表示される
- `-r 30` : 出力動画のフレームレートを30fpsに指定。つまり、1秒あたり30枚のフレームが表示される
- `output.mp4` : 出力ファイルの名前を指定

したがって、このコマンドは、`input.png` ファイルを1つのフレームとして持つ動画ファイルを作成し、その長さを3秒、フレームレートを30fpsに設定。出力ファイルを `output.mp4` として保存

## 動画に音声を追加
```
ffmpeg -i video.mp4 -i video.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 output.mp4
```
このコードは、FFmpegを使用してビデオファイルとオーディオファイルを結合し、新しいビデオファイルを作成するためのコマンド。

具体的には、：

- `-i video.mp4` : 入力として `video.mp4` ファイルを指定。これはビデオファイル。
- `-i video.mp3` : 入力として `video.mp3` ファイルを指定。これはオーディオファイル。
- `-c:v copy` : ビデオストリームをコピーすることを指定。つまり、元のビデオファイルのビデオデータはそのままで、再エンコードされません
- `-c:a aac` : オーディオストリームをAAC形式でエンコードすることを指定
- `-map 0:v:0` : 元のビデオファイルから最初のビデオストリームを選択。
- `-map 1:a:0` : 第2の入力ファイルから最初のオーディオストリームを選択
- `output.mp4` : 出力ファイルの名前を指定。この場合、新しいビデオファイルの名前は `output.mp4` 

したがって、このコマンドは `video.mp4` ファイルのビデオストリームと `video.mp3` ファイルのオーディオストリームを結合し、新しいビデオファイル `output.mp4` を作成。



# imager

imagerパッケージを用いて、差心から線画を作成する手順
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
# 画像ファイルを読み込み
path <- "./images/me_1.png"
img <- load.image(path)
# 白黒に
gray_img <- img |> grayscale()
# 2値化。画素値が 0.375 より大きければそのピクセルの画素値は 1 にし、0.375以下なら 0 にすることで、白黒画像が作れます。
gray_img[ gray_img > .375] =1
gray_img[ gray_img <= .375] = 0
# 思い切った線画にする（ただし黒地に白線）
nega_img <- gray_img |> isoblur(2) |> imgradient("xy") |> with(sqrt(x^2+y^2)) |> threshold() |> as.cimg() 
# 画像を保存
imager::save.image(nega_img, "./images/nega_me.png")

#保存した画像の白黒を逆転させるために
#ターミナルで
 convert -negate nega_me.png posi_me.png
# convertはimagemagickのコマンド
```

## another way

```
# アルファチャネル操作用の関数
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