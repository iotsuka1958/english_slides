#! /usr/bin/env python

import subprocess
import sys

def get_seconds(time_str):
    """HH:MM:SS 形式の文字列を秒数(float)に変換するヘルパー関数"""
    parts = list(map(float, time_str.split(':')))
    if len(parts) == 3:
        return parts[0] * 3600 + parts[1] * 60 + parts[2]
    elif len(parts) == 2:
        return parts[0] * 60 + parts[1]
    else:
        return parts[0]

def merge_videos():
    # --- 設定項目 ---
    input_file_1 = "hoge.mp4"
    input_file_2 = "fuga.mp4"
    output_file = "piyo.mp4"
    
    # 解像度設定 (Full HD)
    width = 1920
    height = 1080
    fps = 30

    # タイムスタンプ設定 (HH:MM:SS)
    # これを秒数に変換して使用します
    start_a_str = "00:04:32"
    end_a_str   = "00:37:07"
    
    start_c_str = "00:44:54"
    end_c_str   = "00:45:02"

    # 秒数への変換実行
    start_a = get_seconds(start_a_str)
    end_a   = get_seconds(end_a_str)
    start_c = get_seconds(start_c_str)
    end_c   = get_seconds(end_c_str)

    # --- 共通の映像フィルタ設定 ---
    # エスケープ問題を避けるため、パラメータをシンプルに構築
    scale_filter = (
        f"scale={width}:{height}:force_original_aspect_ratio=decrease,"
        f"pad={width}:{height}:(ow-iw)/2:(oh-ih)/2,"
        f"setsar=1,"
        f"fps={fps}"
    )

    # --- filter_complex の構築 ---
    # start/end に秒数(数値)を使うことでコロン(:)の問題を回避
    filter_complex = (
        # 1. パート(a): hoge.mp4
        f"[0:v]trim=start={start_a}:end={end_a},setpts=PTS-STARTPTS,{scale_filter}[v0];"
        f"[0:a]atrim=start={start_a}:end={end_a},asetpts=PTS-STARTPTS[a0];"

        # 2. パート(b): fuga.mp4 (全編)
        f"[1:v]{scale_filter}[v1];"
        f"[1:a]aformat=sample_rates=44100:channel_layouts=stereo[a1];"

        # 3. パート(c): hoge.mp4
        f"[0:v]trim=start={start_c}:end={end_c},setpts=PTS-STARTPTS,{scale_filter}[v2];"
        f"[0:a]atrim=start={start_c}:end={end_c},asetpts=PTS-STARTPTS[a2];"

        # 4. 結合
        f"[v0][a0][v1][a1][v2][a2]concat=n=3:v=1:a=1[outv][outa]"
    )

    # --- FFmpeg コマンド構築 ---
    command = [
        "ffmpeg",
        "-y",
        "-i", input_file_1,
        "-i", input_file_2,
        "-filter_complex", filter_complex,
        "-map", "[outv]",
        "-map", "[outa]",
        "-c:v", "libx264",
        "-crf", "23",
        "-preset", "medium",
        "-c:a", "aac",
        "-b:a", "192k",
        output_file
    ]

    # --- 実行 ---
    print(f"処理を開始します: {output_file} を生成中...")
    print(f"  パート(a): {start_a}秒 ～ {end_a}秒")
    print(f"  パート(c): {start_c}秒 ～ {end_c}秒")

    try:
        subprocess.run(command, check=True)
        print(f"完了しました。出力ファイル: {output_file}")
    except subprocess.CalledProcessError as e:
        print("FFmpegの実行中にエラーが発生しました。")
        # エラーコードを表示
        print(f"Return Code: {e.returncode}")
    except FileNotFoundError:
        print("エラー: FFmpegが見つかりません。")

if __name__ == "__main__":
    merge_videos()
