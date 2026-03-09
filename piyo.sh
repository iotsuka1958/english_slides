#!/usr/bin/env bash
#以下2年pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 507 517 output 2nd_grader/upload_archive/20260310/pronunciation_20260310.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 518 528 output 2nd_grader/upload_archive/20260311/pronunciation_20260311.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 547 557 output 2nd_grader/upload_archive/20260312/pronunciation_20260312.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 558 568 output 2nd_grader/upload_archive/20260313/pronunciation_20260313.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 586 596 output 2nd_grader/upload_archive/20260317/pronunciation_20260317.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 597 607 output 2nd_grader/upload_archive/20260318/pronunciation_20260318.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 611 612 618 output 2nd_grader/upload_archive/20260319/pronunciation_20260319.pdf
#以下2年mp3
cp pronunciation/audio/vowel_ei_02.mp3  2nd_grader/upload_archive/20260310/pronunciation_20260310.mp3
cp pronunciation/audio/vowel_ei_03.mp3  2nd_grader/upload_archive/20260311/pronunciation_20260311.mp3
cp pronunciation/audio/vowel_long_o_02.mp3  2nd_grader/upload_archive/20260312/pronunciation_20260312.mp3
cp pronunciation/audio/vowel_long_o_03.mp3  2nd_grader/upload_archive/20260313/pronunciation_20260313.mp3
cp pronunciation/audio/vowel_ou_02.mp3  2nd_grader/upload_archive/20260317/pronunciation_20260317.mp3
cp pronunciation/audio/vowel_ou_03.mp3  2nd_grader/upload_archive/20260318/pronunciation_20260318.mp3
cp pronunciation/audio/vowel_boat_bought_01.mp3  2nd_grader/upload_archive/20260319/pronunciation_20260319.mp3
# 以下1年pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 541 output 1st_grader/upload_archive/20260310/pronunciation_20260310.pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 542 output 1st_grader/upload_archive/20260311/pronunciation_20260311.pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 543 output 1st_grader/upload_archive/20260312/pronunciation_20260312.pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 544 output 1st_grader/upload_archive/20260313/pronunciation_20260313.pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 545 538 output 1st_grader/upload_archive/20260317/pronunciation_20260317.pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 546 output 1st_grader/upload_archive/20260318/pronunciation_20260318.pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 547 output 1st_grader/upload_archive/20260319/pronunciation_20260319.pdf
#以下1年mp3
cp pronunciation/audio/consonant_f_v_01.mp3  1st_grader/upload_archive/20260310/pronunciation_20260310.mp3
cp pronunciation/audio/consonant_s_z_01.mp3  1st_grader/upload_archive/20260311/pronunciation_20260311.mp3
cp pronunciation/audio/consonant_Th_01.mp3  1st_grader/upload_archive/20260312/pronunciation_20260312.mp3
cp pronunciation/audio/consonant_textesh_textyogh_01.mp3  1st_grader/upload_archive/20260313/pronunciation_20260313.mp3
cp pronunciation/audio/consonant_ts_dz_01.mp3  1st_grader/upload_archive/20260317/pronunciation_20260317.mp3
cp pronunciation/audio/consonant_ttextesh_dtextyogh_01.mp3  1st_grader/upload_archive/20260318/pronunciation_20260318.mp3
cp pronunciation/audio/consonant_l_r_01.mp3  1st_grader/upload_archive/20260319/pronunciation_20260319.mp3
