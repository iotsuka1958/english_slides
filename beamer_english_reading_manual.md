# 「beamer-english-reading」スキル 活用実践マニュアル

このマニュアルでは、指定した英語の文法テーマに基づき、**CEFR A1レベルの英語読み物（約80語）**、**5問のT/F正誤問題**、**ネイティブTTS音声ファイル（MP3）**を生成し、プレゼンテーション用スライドの**LaTeX Beamerフレームコード**として一括出力するスキル **`beamer-english-reading`** の使い方を分かりやすく解説します。

---

## 1. はじめに：beamer-english-reading とは？

### 概要
英語授業スライド（LaTeX Beamer）の「Listen, Then Read」セクションを作成するための特化スキルです。
文法項目（例：助動詞 can、過去形、不定詞など）や教材スライドを指定するだけで、以下の成果物をワンアクションで自動作成します：

1. **A1レベルの英語読み物テキスト**（約80語、指定文法を自然に含む）
2. **理解度チェック用のTrue/False正誤問題（5問）**
3. **ネイティブTTS音声ファイル（MP3）**（タイトル読み上げ、ポーズ、本文朗読）
4. **Beamerスライド用LaTeXコード**（音声再生ボタン `\myaudio` や再生時間 `MMSS`、アニメーション番号 `<2->`～`<7->` を完備）

```
【入力：文法テーマ / 既存PDF・TeXスライド】
                      │
                      ▼
┌────────────────────────────────────────────────────────┐
│  Antigravity (AI)                                      │
│  ┌──────────────────────────────────────────────────┐  │
│  │ beamer-english-reading スキルの実行              │  │
│  │  1. A1レベル英文作成（日常/科学/社会, 約80語）    │  │
│  │  2. 正誤問題作成（T/F 5問）                      │  │
│  │  3. TTS音声生成（タイトル＋ポーズ＋本文朗読）    │  │
│  │  4. 音声再生時間をミリ秒/秒単位で計測（例:0035） │  │
│  │  5. Beamerテンプレートへの埋め込み               │  │
│  └──────────────────────────────────────────────────┘  │
└──────────────────────┬─────────────────────────────────┘
                       │
       ┌───────────────┴───────────────┐
       ▼                               ▼
【音声ファイル出力】             【LaTeX Beamerコード出力】
./audio/<名前>_reading.mp3      ```latex
                                \begin{frame}...
                                \end{frame}
                                ```
```

---

## 2. 生成されるスライドの構造と特徴

本スキルが出力するLaTeXコードは、授業での提示や生徒の操作性を考慮した高度なBeamer設定が組み込まれています。

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ Exercises                                                                    │
│ ┌──────────────────────────────────────────────────────────────────────────┐ │
│ │ A Walk in the Park                       0035  [▶再生アイコン]            │ │
│ │                                                                          │ │
│ │   Ken walks in the park every morning. He sees a small bird.             │ │
│ │                                                                          │ │
│ │   The bird sings in a tall tree. Ken smiles and listens to the song.     │ │
│ │ It is a very beautiful morning.                                          │ │
│ └──────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│ 次の各文が本文の内容とあっていればT,そうでなければFと答えましょう (スライド2-)   │
│ 1. Ken walks in the park every afternoon.                         F (スライド3-)│
│ 2. He sees a small bird in the park.                              T (スライド4-)│
│ 3. The bird is sleeping in the tree.                              F (スライド5-)│
│ 4. Ken listens to the song of the bird.                           T (スライド6-)│
│ 5. It is a rainy morning.                                         F (スライド7-)│
└──────────────────────────────────────────────────────────────────────────────┘
```

### 主な特徴と仕様
- **tcolorbox デザイン**: 上部に背景色付きの読み物枠を配置。タイトルの横に再生時間（例: `0035`）と音声再生ボタン `\myaudio{...}` が並びます。
- **適切なインデント**: 段落間に物理的な空行を挟むことで、`tcolorbox` の `\parindent`（段落字下げ）が綺麗に機能します。
- **ステップ表示（Overlays）**: 
  - スライド 1枚目：読み物枠のみ提示
  - スライド 2枚目：設問 1〜5 が一括表示
  - スライド 3〜7枚目：1問ずつ順番に正解（T / F）が表示されるアニメーション構成

---

## 3. 音声生成（TTS）の仕様

| 項目 | 仕様 |
| :--- | :--- |
| **対象テキスト** | **「タイトル」 ➔ 若干の空白時間（ポーズ） ➔ 「本文」**<br>※T/F問題の文は音声に含まれません。 |
| **音声の種類** | アメリカ英語（`en-US`）<br>・デフォルト：男性声（`en-US-GuyNeural` 等）<br>・女性声の指示がある場合：女性声（`en-US-AvaNeural` 等） |
| **保存先** | カレントディレクトリ下の `./audio/` ディレクトリ |
| **ファイル命名規則** | `{{ソース名}}_reading.mp3`<br>例: `012_can.pdf` を指定した場合 ➔ `./audio/012_can_reading.mp3` |
| **再生時間** | 生成されたMP3の実際の再生時間を分秒4桁（`MMSS`、例: 35秒なら `0035`）としてLaTeXコードへ自動反映 |

---

## 4. Antigravityでの使い方・プロンプト例

### パターン 1：既存のPDFやTeXファイルを指定して作成する（基本）
講義スライドの元ファイルを指定すると、ソース名を引き継いで音声ファイルとBeamerコードを生成します。

```text
/beamer-english-reading
./2nd_grader/012_can.pdf をソースとして、「Listen, Then Read」の読み物スライドを作成してください。
```

### パターン 2：文法テーマを直接指定して作成する
特定の文法項目を指定して即座に作成することも可能です。

```text
/beamer-english-reading
中学2年生レベルの「助動詞 must / have to」をターゲットにした約80語の読み物スライドを作成してください。
ソース名は 018_must でお願いします。
```

### パターン 3：女性声での読み上げを指定する
音声の声種を変更したい場合は、プロンプトで明示的に指示します。

```text
/beamer-english-reading
./2nd_grader/005_past_tense.pdf をもとに作成してください。
音声は女性声（en-US-AvaNeural）で生成してください。
```

---

## 5. 出力されるLaTeXコードのテンプレート

スキルは余計な前置き・挨拶を出力せず、以下の構造の `latex` コードブロックのみを出力します。

```latex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\section{Listen, Then Read\,\,\,\,\,{\tiny 0035}\,{\scriptsize \myaudio{./audio/012_can_reading.mp3}}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{frame}[plain,t]{Exercises}
\begin{tcolorbox}[colframe=ForestGreen,
  colback=NavyBlue!10!white,
  colbacktitle=NavyBlue!40!white,
  coltitle=black, %fonttitle=\bfseries,
before upper={\setlength{\parindent}{1.25em}},
 title={A Friendly Robot\hfill{\tiny 0035}\quad{\scriptsize \myaudio{./audio/012_can_reading.mp3}}}
]
Robots can do many things today. Some robots can clean rooms, and other robots can carry heavy boxes.

Ken has a small robot at home. It can speak English and Japanese. It can also sing funny songs. Ken talks to the robot every evening. He enjoys his time with it.
\end{tcolorbox}

\vspace{-4pt}
\visible<2->{\small 次の各文が本文の内容とあっていればT,そうでなければFと答えましょう}
\vspace{-11pt}
\begin{enumerate}\setlength{\itemsep}{-3.2pt}
\item<2-> Robots cannot carry heavy boxes.\hfill\visible<3->{F}
\item<2-> Ken has a big robot at home.\hfill\visible<4->{F}
\item<2-> Ken's robot can speak two languages.\hfill\visible<5->{T}
\item<2-> The robot can sing funny songs.\hfill\visible<6->{T}
\item<2-> Ken talks to the robot every morning.\hfill\visible<7->{F}
\end{enumerate}
\end{frame}
```

---

## 6. スライドへの組み込み手順（コンパイルと確認）

1. **出力コードをコピー**:
   Antigravityが出力したコードブロックの右上にある「Copy」をクリックします。
2. **既存の `.tex` ファイルへ貼り付け**:
   授業用スライドの `.tex` ファイル（例: `012_can.tex`）の該当箇所に貼り付けます。
3. **音声ファイルの存在を確認**:
   `./audio/012_can_reading.mp3` が生成されていることを確認します。
4. **コンパイル**:
   `lualatex` や `xelatex` 等でコンパイルし、PDFを生成します。
   ```bash
   lualatex 012_can.tex
   ```
5. **動作確認**:
   - 英文読み物のタイトル横の再生時間（`0035` 等）が合っているか
   - `\myaudio` アイコンをクリックしたときに音声が再生されるか
   - スライド送りで設問と正解（T/F）が順次表示されるか

---

## 7. トラブルシューティング

| 困ったこと | 原因と対処法 |
| :--- | :--- |
| **ダブルクォーテーションの表示がおかしい** | LaTeXでは通常の `"` ではなく、開き引用符に `` `` ``、閉じ引用符に `''` を使用します。本スキルはこの変換を自動で行います。 |
| **音声ボタンをクリックしても音が鳴らない** | PDFビューアのJavaScript設定や、`./audio/` フォルダの相対パスがずれている可能性があります。PDFと同じ階層に `audio` フォルダが存在するか確認してください。 |
| **パラグラフの字下げが揃わない** | 本文中に `\\`（改行コマンド）を使用すると字下げが無効になります。文と文の間に空行を挟む物理的な段落分けを行ってください。 |

---

## 8. まとめ

`beamer-english-reading` を利用することで、読み物作成・正誤問題作成・ネイティブTTS録音・Beamerレイアウト設計という複数の手間のかかる作業を**数秒で自動完結**させることができます。

英語スライドの教材作成・更新にぜひご活用ください。
