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
img_1 <- load.image("./images/me_1.png")
# 白黒に
gray_img_1 <- img_1 |> grayscale()
# 2値化。画素値が 0.375 より大きければそのピクセルの画素値は 1 にし、0.375以下なら 0 にすることで、白黒画像が作れます。
gray_img_1[ gray_img_1 > .375] =1
gray_img_1[ gray_img_1 <= .375] = 0
# 思い切った線画にする（ただし黒地に白線）
nega_img <- gray_img_1 |> isoblur(2) |> plot() |> imgradient("xy") |> with(sqrt(x^2+y^2)) |> threshold() |> as.cimg() 
# 画像を保存
imager::save.image(nega_img, "./images/nega_me.png")

#保存した画像の白黒を逆転させるために
#ターミナルで
 convert -negate nega_me.png posi_me.png
# convertはimagemagickのコマンド

```