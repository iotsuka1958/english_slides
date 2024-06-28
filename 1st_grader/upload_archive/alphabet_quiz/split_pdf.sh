#!/usr/bin/bash

input_pdf="999quiz.pdf"
output_prefix="quiz_"

for i in {0..25}
do
  start_page=$((i * 2 + 1))
  end_page=$((start_page + 1))
  output_pdf="${output_prefix}$(printf "%02d" $((i + 1))).pdf"
  pdftk "$input_pdf" cat "$start_page-$end_page" output "$output_pdf"
done
