---
name: beamer-english-reading
description: Generate A1-level English reading passages (~80 words) based on grammar points, generate TTS audio MP3 for the reading text, and output them in a specific LaTeX Beamer frame format with 5 True/False questions. Trigger whenever the user requests English reading comprehension exercises, A1 level LaTeX Beamer reading slides, or grammar-based reading passages in Beamer format.
---

# Beamer English Reading Generator

このスキルは、与えられた英語の文法事項に基づいて、CEFR A1レベル・約80語の英語読み物および5問のT/F正誤問題を生成し、TTS音声ファイルを出力し、指定されたLaTeX Beamer形式のソースコードのみを出力します。

## 指示・仕様

### 1. 英文読み物の作成
- **対象レベル**: CEFR A1レベル
- **語数**: 約80語
- **内容の選定**: 「日常的な題材」「科学的な客観的な説明」「社会的なトピック」などのうち、指定された文法事項に適したものを1つ選択
- **タイトル**: 読み物の内容に合ったタイトルを設定

### 2. 正誤問題（T/F）の作成
- 英文の理解度を問う正誤問題を**5問**作成
- 正解を `T` または `F` で設定

### 3. TTS音声ファイルの自動生成
- **対象テキスト**: 英文読み物本文のみ（T/F正誤問題の文章は含めない）
- **言語・アクセント**: 自然なアメリカ英語 (`en-US`)
- **声種指定**:
  - 特に指定がない場合: 男性声 (`en-US-GuyNeural` や `gTTS` 等)
  - 明示的な指示がある場合: 女性声 (`en-US-AvaNeural` 等)
- **保存先・ファイル名規則**:
  - 保存先: 子ディレクトリ `./audio/`
  - ファイル名: ソースファイルの拡張子を除いた文字列に `_reading.mp3` を付与
  - 例: ソースファイル名 `./012_can.pdf` → 音声出力 `./audio/012_can_reading.mp3`

### 4. 出力フォーマットと厳格な制約
- **厳密な出力**: `\begin{frame}[plain,t]{Exercises}` から `\end{frame}` までのLaTeXコードのみを出力すること。コード以外の解説、挨拶、前後のテキスト（Markdownの補足説明など）は**一切出力しない**こと。
- **改行と視認性**: 1行が長くなりすぎないよう、英文読み物の本文（英文1〜2文ごとなど）やLaTeXコードには適度に改行を入れること。
- **アニメーションカウンターの保持**: `<2->` や `<3->` ～ `<7->` のカウンター表記を変更・改変しないこと。
- **音声ファイルパスの連動**: `\myaudio{./audio/<ソース名>_reading.mp3}` のように生成した音声ファイルパスを反映すること。

## テンプレート

以下のテンプレート構造をそのまま厳密に使用してください。

```latex
\begin{frame}[plain,t]{Exercises}
\begin{tcolorbox}[colframe=ForestGreen,
  colback=NavyBlue!10!white,
  colbacktitle=NavyBlue!40!white,
  coltitle=black, %fonttitle=\bfseries,
before upper={\setlength{\parindent}{1.25em}},
 title={{{作成した英文読み物のタイトル}}\hfill{\tiny 0047}\quad{\scriptsize \myaudio{./audio/{{ソース名}}_reading.mp3}}}
]
{{作成した英文読み物本文を出力}}

\end{tcolorbox}

\vspace{-4pt}
\visible<2->{\small 次の各文が本文の内容とあっていればT,そうでなければFと答えましょう}
\vspace{-11pt}
\begin{enumerate}\setlength{\itemsep}{-3.2pt}
\item<2-> {{作成した正誤問題1を出力}}\hfill\visible<3->{{{TまたはF}}}
\item<2-> {{作成した正誤問題2を出力}}\hfill\visible<4->{{{TまたはF}}}
\item<2-> {{作成した正誤問題3を出力}}\hfill\visible<5->{{{TまたはF}}}
\item<2-> {{作成した正誤問題4を出力}}\hfill\visible<6->{{{TまたはF}}}
\item<2-> {{作成した正誤問題5を出力}}\hfill\visible<7->{{{TまたはF}}}
\end{enumerate}
\end{frame}
```
