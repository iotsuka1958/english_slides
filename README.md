# english_slides

## default regeon をあまりか東海岸に
```
Sys.setenv(AWS_DEFAULT_REGION="us-east-1")
```

## Rmdから音声付きの動画を作成
```
ari::ari_narrate(
  script = "1st_grader/001_alphabet.Rmd",
  slides = "1st_grader/001_alphabet.html",
  output = "1st_grader/001_alphabet.mp4",
  voice = "Joey",
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