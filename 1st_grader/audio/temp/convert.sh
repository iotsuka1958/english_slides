for file in *.mp3; do
    ffmpeg -i "$file" -ar 22050 "converted_$file"
done
