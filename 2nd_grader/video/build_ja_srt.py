#! /usr/bin/env python

# build_ja_srt.py
# 使い方: python build_ja_srt.py "path/to/audio.mp3"
# 出力: 同名ベースの日本語SRT (例: audio.ja.srt)
from __future__ import annotations
import argparse, os, sys, shutil, textwrap, time
from typing import List, Tuple
from faster_whisper import WhisperModel

# ▼ OpenAI: 新SDK
try:
    from openai import OpenAI
except Exception as e:
    OpenAI = None

def hhmmssms(t: float) -> str:
    if t < 0: t = 0.0
    ms = int(round((t - int(t)) * 1000))
    s  = int(t) % 60
    m  = (int(t) // 60) % 60
    h  = int(t) // 3600
    return f"{h:02d}:{m:02d}:{s:02d},{ms:03d}"

def merge_segments(segments, max_chars=70, max_dur=6.0) -> List[Tuple[float,float,str]]:
    """細かいセグメントを読みやすい粒度に束ねる"""
    merged = []
    buf_text = []
    start = None
    last_end = None
    for seg in segments:
        st, ed, tx = float(seg.start), float(seg.end), (seg.text or "").strip()
        if not tx: 
            continue
        if start is None:
            start = st
        candidate = (" ".join(buf_text + [tx])).strip()
        dur = (ed - start) if start is not None else 0.0
        if (len(candidate) > max_chars) or (dur > max_dur):
            # フラッシュ
            if buf_text:
                merged.append((start, last_end if last_end else ed, " ".join(buf_text).strip()))
            # リセット
            buf_text = [tx]
            start = st
            last_end = ed
        else:
            buf_text.append(tx)
            last_end = ed
    if buf_text:
        merged.append((start, last_end, " ".join(buf_text).strip()))
    # 余白の整形
    out = []
    for st, ed, tx in merged:
        tx = tx.replace("  ", " ").strip()
        out.append((st, ed, tx))
    return out

def write_srt(items: List[Tuple[float,float,str]]) -> str:
    lines = []
    for i, (st, ed, tx) in enumerate(items, start=1):
        lines.append(str(i))
        lines.append(f"{hhmmssms(st)} --> {hhmmssms(ed)}")
        # 読みやすい改行（日本語化前は英文を適当に折る）
        wrapped = textwrap.fill(tx, width=42)
        lines.append(wrapped)
        lines.append("")  # blank
    return "\n".join(lines)

def translate_srt_blocks_with_openai(srt_text: str, max_lines_per_block=60, model="gpt-4o-mini") -> str:
    if OpenAI is None:
        raise RuntimeError("openai パッケージが見つかりません。 `pip install openai` を実行してください。")
    client = OpenAI()  # OPENAI_API_KEY を自動参照
    # SRTを行単位で分割し、番号/タイムスタンプは保持、テキストのみ日訳
    lines = srt_text.splitlines()
    blocks = []
    cur = []
    count = 0
    for ln in lines:
        cur.append(ln)
        if ln.strip() == "":
            count += 1
            if count >= max_lines_per_block:
                blocks.append("\n".join(cur))
                cur = []
                count = 0
    if cur:
        blocks.append("\n".join(cur))

    out = []
    sys_prompt = (
        "あなたは字幕翻訳者です。以下のSRTの『テキスト行のみ』を、"
        "読みやすく簡潔な自然な日本語に翻訳してください。"
        "番号とタイムスタンプは一切変更せずにそのまま返してください。"
        "冗長・言い直し・フィラー（えー、あのー等）は適度に削り、意味は保ちます。"
        "句読点は日本語で整え、専門語は一般的な訳語に。"
        "一行が長過ぎる場合は2行に自然に改行しても構いません。"
    )
    for idx, block in enumerate(blocks, start=1):
        msg = [
            {"role": "system", "content": sys_prompt},
            {"role": "user", "content": f"次のSRTブロックを日本語にしてください。\n\n{block}"}
        ]
        resp = client.chat.completions.create(model=model, messages=msg, temperature=0.2)
        out.append(resp.choices[0].message.content.strip())
        time.sleep(0.2)  # 礼儀的に軽い間隔
    return "\n\n".join(out).strip()

def auto_sync_with_ffsubsync(audio_path: str, srt_path: str) -> str:
    exe = shutil.which("ffsubsync") or shutil.which("ffs") or shutil.which("subsync")
    if not exe:
        return srt_path  # ツール未導入なら何もしない
    synced = os.path.splitext(srt_path)[0] + ".synced.srt"
    # 参考: https://github.com/smacke/ffsubsync
    # 例: ffs audio_or_video -i input.srt -o output.srt
    import subprocess
    cmd = [exe, audio_path, "-i", srt_path, "-o", synced]
    subprocess.run(cmd, check=False)
    # 成功/失敗に関わらず、存在すればそれを返す
    return synced if os.path.exists(synced) else srt_path

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("audio", help="英語音声ファイル（mp3/wav等）")
    ap.add_argument("--model", default="large-v3", help="faster-whisper のモデル名（既定: large-v3 高精度）")
    ap.add_argument("--no-sync", action="store_true", help="ffsubsync による自動ずれ補正をスキップ")
    args = ap.parse_args()

    audio = args.audio
    if not os.path.exists(audio):
        print(f"Audio not found: {audio}", file=sys.stderr)
        sys.exit(1)

    base = os.path.splitext(audio)[0]
    en_srt = base + ".en.srt"
    ja_srt = base + ".ja.srt"

    print("== 1) 英語を書き起こし中（faster-whisper） ==")
    # CPUでも動作可。速さ重視なら "medium" などに変更可
    model = WhisperModel(args.model, device="cpu", compute_type="int8")
    # 英語固定で精度・安定性を上げる設定
    segments, info = model.transcribe(
        audio,
        language="en",
        vad_filter=True,
        condition_on_previous_text=False,
        beam_size=5,
        temperature=0.0,
    )
    segs = list(segments)
    merged = merge_segments(segs, max_chars=70, max_dur=6.0)
    en_text = write_srt(merged)
    with open(en_srt, "w", encoding="utf-8") as f:
        f.write(en_text)
    print(f"→ 英語SRT: {en_srt}")

    print("== 2) 日本語へ簡潔に翻訳（OpenAI） ==")
    if OpenAI is None and os.environ.get("OPENAI_API_KEY") is None:
        print("OpenAI SDKが見つからないかAPIキー未設定のため翻訳をスキップしました。", file=sys.stderr)
        print("`pip install openai` と `OPENAI_API_KEY` 設定後に再実行してください。", file=sys.stderr)
        sys.exit(2)
    ja_text = translate_srt_blocks_with_openai(en_text, model="gpt-4o-mini")
    with open(ja_srt, "w", encoding="utf-8") as f:
        f.write(ja_text)
    print(f"→ 日本語SRT: {ja_srt}")

    if not args.no_sync:
        print("== 3) ずれ補正（ffsubsync） ==")
        synced = auto_sync_with_ffsubsync(audio, ja_srt)
        if synced != ja_srt:
            print(f"→ 自動補正後: {synced}")
        else:
            print("ffsubsync 未導入か補正対象なし。")
    print("完了。")

if __name__ == "__main__":
    main()
