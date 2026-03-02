#!/usr/bin/env bash
#以下2年pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 427 433 output 2nd_grader/upload_archive/20260303/pronunciation_20260303.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 434 440 output 2nd_grader/upload_archive/20260304/pronunciation_20260304.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 474 484 output 2nd_grader/upload_archive/20260305/pronunciation_20260305.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 485 495 output 2nd_grader/upload_archive/20260306/pronunciation_20260306.pdf
# 以下3年pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 427 433 output 3rd_grader/upload_archive/20260303/pronunciation_20260303.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 434 440 output 3rd_grader/upload_archive/20260304/pronunciation_20260304.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 474 484 output 3rd_grader/upload_archive/20260305/pronunciation_20260305.pdf
pdftk pronunciation/pronunciation_vowel.pdf cat 485 495 output 3rd_grader/upload_archive/20260306/pronunciation_20260306.pdf
#以下2年mp3
cp pronunciation/audio/vowel_pool_pull_01.mp3  2nd_grader/upload_archive/20260303/pronunciation_20260303.mp3
cp pronunciation/audio/vowel_full_fool_01.mp3  2nd_grader/upload_archive/20260304/pronunciation_20260304.mp3
cp pronunciation/audio/vowel_e_02.mp3  2nd_grader/upload_archive/20260305/pronunciation_20260305.mp3
cp pronunciation/audio/vowel_e_03.mp3  2nd_grader/upload_archive/20260306/pronunciation_20260306.mp3
#以下3年mp3
cp pronunciation/audio/vowel_pool_pull_01.mp3  3rd_grader/upload_archive/20260303/pronunciation_20260303.mp3
cp pronunciation/audio/vowel_full_fool_01.mp3  3rd_grader/upload_archive/20260304/pronunciation_20260304.mp3
cp pronunciation/audio/vowel_e_02.mp3  3rd_grader/upload_archive/20260305/pronunciation_20260305.mp3
cp pronunciation/audio/vowel_e_03.mp3  3rd_grader/upload_archive/20260306/pronunciation_20260306.mp3
# 以下1年pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 511 517 output 1st_grader/upload_archive/20260303/pronunciation_20260303.pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 537 538 output 1st_grader/upload_archive/20260304/pronunciation_20260304.pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 539 output 1st_grader/upload_archive/20260305/pronunciation_20260305.pdf
pdftk pronunciation/pronunciation_consonant.pdf cat 540 output 1st_grader/upload_archive/20260306/pronunciation_20260306.pdf
#以下1年mp3
cp pronunciation/audio/consonant_sea_she_01.mp3  1st_grader/upload_archive/20260303/pronunciation_20260303.mp3
cp pronunciation/audio/consonant_p_b_01.mp3  1st_grader/upload_archive/20260304/pronunciation_20260304.mp3
cp pronunciation/audio/consonant_t_d_01.mp3  1st_grader/upload_archive/20260305/pronunciation_20260305.mp3
cp pronunciation/audio/consonant_k_g_01.mp3  1st_grader/upload_archive/20260306/pronunciation_20260306.mp3
