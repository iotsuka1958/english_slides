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
ffmpeg -i video.mp4 -i video.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 output.mp4
```

## 動画に音声を追加
```
ffmpeg -i opening.mp4 -i opening.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 zzz.mp4
```

amazon polly
text-to-speech
standared
english,US
Male,Joey

# imager
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