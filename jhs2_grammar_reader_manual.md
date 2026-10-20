# 「jhs2-grammar-reader」スキル 活用実践マニュアル

このマニュアルでは、中学校第2学年（中2）の英語レベルに特化し、指定された文法項目を自然に織り交ぜた**約8行の英文読み物（ダイアログ、日記、物語、説明文等）**、**語注**、**日本語訳**、**文法解説**、および**3問のTrue/False理解度クイズ**を一括生成するスキル **`jhs2-grammar-reader`** の使い方を分かりやすく解説します。

---

## 1. はじめに：jhs2-grammar-reader とは？

### 概要
日本の公立中学校・私立中学校の**中学2年生（CEFR A1〜A2初頭レベル）**の語彙力・読解力に合わせて設計された英語読み物教材作成スキルです。

授業の導入教材、帯活動（朝読・1分読解）、定期テストの長文読解、ワークシート用の素材としてそのまま使える高品質な英語教材を、文法項目を指定するだけで瞬時に作成します。

```
【入力：文法テーマ / 授業プリント / 教科書単元名】
                       │
                       ▼
┌────────────────────────────────────────────────────────┐
│  Antigravity (AI)                                      │
│  ┌──────────────────────────────────────────────────┐  │
│  │ jhs2-grammar-reader スキルの自動処理             │  │
│  │  1. 文法項目の抽出・分析                         │  │
│  │  2. 最適なテキスト形式の選定（日記/対話/説明文等） │  │
│  │  3. 英文執筆（約8行/約70〜100語、目標文法を2〜4回）│  │
│  │  4. 中2範囲外の語彙に対する語注付け ([*1])       │  │
│  │  5. 全文の自然な日本語対訳作成                   │  │
│  │  6. ターゲット文法のポイント解説                 │  │
│  │  7. T/F正誤問題（3問、折りたたみ解答付き）作成   │  │
│  └──────────────────────────────────────────────────┘  │
└──────────────────────┬─────────────────────────────────┘
                       │
                       ▼
【出力：Markdown形式の整理された読解ワークシート】
```

---

## 2. 教材生成のこだわりと仕様

### ① 英文の長さと語彙レベル
- **長さ**: ちょうど**約8文（約8行 / 70〜100語程度）**
  - 中学生が1コマの授業内（帯活動の5〜10分程度）で無理なく集中して読み切れる絶妙な分量です。
- **ターゲット文法の出現頻度**: 文中に**2〜4回**、自然な文脈で目標の文法構造が登場します。
- **語彙コントロールと語注（Footnotes）**:
  - 原則として中学校2年生教科書レベルの基本英単語で構成されます。
  - 自然な文脈上、やむを得ず中3〜高校レベルの単語を使用する場合は、本文中に `[*1]` のように注記番号を付け、末尾に日本語訳と難易度（例: `[*1] musician: 音楽家（注: 中3〜高校レベル）`）を明記します。

### ② 文法項目に連動した多彩な文章ジャンル
文法項目の特性に合わせて、最も自然に読める文章フォーマットが自動的に選ばれます。

| 文章ジャンル | 適した文法項目 | 活用シーン |
| :--- | :--- | :--- |
| **対話文（Conversation）** | `be going to`, `have to`, `shall we`, 助動詞 | 日常の会話、予定の相談、放課後の誘い |
| **日記・日誌（Diary Entry）** | 過去進行形, 不定詞（副詞的用法）, 接続詞 | 週末の出来事、部活動の思い出、感想 |
| **物語・短編（Narrative）** | 比較級・最上級, 接続詞 `when` / `because` | 簡単なイソップ風寓話、友達との小さな事件 |
| **説明文（Expository）** | 受動態（`be + 過去分詞`）, 天気や環境 | 日本の文化紹介、動物の生態、簡単な科学事実 |
| **手紙・メール（Email / Letter）**| 第4文型（`give / show / tell + 人 + 物`） | 感謝のメッセージ、ALTへの自己紹介 |

---

## 3. 出力フォーマット（Markdown構造）

出力は常に以下の美しいMarkdown構成に統一されています。そのまま印刷用プリント（Word/Docs）にコピペしたり、NotionやMarkdownエディタで閲覧するのに最適です。

```markdown
# 📚 English Reading Passage: [タイトル]

**Target Grammar**: [文法項目名（例: 不定詞の副詞的用法）]  
**Format**: [選定された文章ジャンル（例: Diary Entry）]

---

### English Passage
[1] 英文1行目  
[2] 英文2行目  
...  
[8] 英文8行目  

*(Footnotes if applicable)*
- `[*1]` **単語**: 日本語訳（難易度注記）

---

### 🇯🇵 日本語訳
[1] 日本語訳1行目  
[2] 日本語訳2行目  
...

---

### 💡 Grammar Focus (文法ポイント)
- **[文法項目名]**: 英文中での具体的な使われ方とワンポイント解説

---

### ❓ True / False Quiz (正誤問題)
Read the passage and write **T** (True) or **F** (False) for each statement.

1. [英文の設問1] ( T / F )
2. [英文の設問2] ( T / F )
3. [英文の設問3] ( T / F )

<details>
<summary><b>解答と解説 (Click to reveal)</b></summary>

1. **[T / F]**: 解説文（日本語）
2. **[T / F]**: 解説文（日本語）
3. **[T / F]**: 解説文（日本語）
</details>
```

---

## 4. Antigravityでの使い方（プロンプト実例）

### パターン 1：文法項目名を直接指定する（最も手軽）
特定の文法を教える授業のプリントを作りたいときに便利です。

```text
/jhs2-grammar-reader
中学2年生の「受動態（be動詞 + 過去分詞）」をテーマにした読解パッセージを作成してください。
```

### パターン 2：文章ジャンルやテーマを指定する
題材やジャンルを指定して、生徒の関心に合わせた英文を作ることができます。

```text
/jhs2-grammar-reader
文法：「比較級・最上級 (taller, the highest)」
形式：2人の生徒が動物園の動物について話す対話文（Conversation）形式
上記の条件で中2向けリーディング教材を作成してください。
```

### パターン 3：手元の文法解説メモや教材テキストを渡す
既存の教材スライドや講義メモを渡して、その定着を図るための読解教材を作ります。

```text
/jhs2-grammar-reader
以下の文法講義メモをもとに、中2レベルの読解テキストを作成してください。

【文法メモ】
- 接続詞 when / if
- when S + V ...: 「〜するとき」
- if S + V ...: 「もし〜ならば」
- 未来のことでも、時・条件を表す副詞節の中では現在形を使う
```

---

## 5. 出力される教材の実例サンプル

### 例：不定詞（副詞的用法：目的「〜するために」）

````markdown
# 📚 English Reading Passage: A Busy Saturday

**Target Grammar**: 不定詞の副詞的用法 (to + 動詞の原形: 〜するために)  
**Format**: Diary Entry (日記)

---

### English Passage

[1] Today, I got up early to practice soccer in the park.  
[2] I ran for thirty minutes to build my stamina[*1].  
[3] After breakfast, I went to the library to study math with Ken.  
[4] There were many books, and the room was very quiet.  
[5] We worked hard to finish our difficult homework.  
[6] In the afternoon, Ken and I stopped by a bakery to buy some bread.  
[7] The melon bread was warm and very delicious.  
[8] I will go to bed early tonight to prepare for tomorrow's match.  

*(Footnotes)*
- `[*1]` **stamina**: スタミナ、体力（注: 中3レベル）

---

### 🇯🇵 日本語訳

[1] 今日、私は公園でサッカーを練習するために早く起きました。  
[2] 私は体力をつけるために30分間走りました。  
[3] 朝食後、私は健と数学を勉強するために図書館へ行きました。  
[4] たくさんの本があり、部屋はとても静かでした。  
[5] 私たちは難しい宿題を終わらせるために一生懸命勉強しました。  
[6] 午後、健と私はパンを買うためにパン屋に立ち寄りました。  
[7] そのメロンパンは温かくてとても美味しかったです。  
[8] 私は明日の試合に備えるために、今夜は早く寝るつもりです。

---

### 💡 Grammar Focus (文法ポイント)

- **不定詞の副詞的用法 (to + 動詞の原形)**:
  - `to practice soccer`（サッカーを練習するために）
  - `to build my stamina`（体力をつけるために）
  - `to study math`（数学を勉強するために）
  - `to finish our difficult homework`（難しい宿題を終わらせるために）
  - `to buy some bread`（パンを買うために）
  - `to prepare for tomorrow's match`（明日の試合に備えるために）
  いずれも「〜するために」という動作の目的を表しています。

---

### ❓ True / False Quiz (正誤問題)

Read the passage and write **T** (True) or **F** (False) for each statement.

1. The writer went to the park to practice baseball in the morning. ( T / F )
2. The writer and Ken studied math at the library. ( T / F )
3. The writer bought some warm melon bread in the afternoon. ( T / F )

<details>
<summary><b>解答と解説 (Click to reveal)</b></summary>

1. **F**: 本文第1文に「practice soccer（サッカーを練習するために）」とあり、野球ではありません。
2. **T**: 本文第3文に「went to the library to study math with Ken」とあります。
3. **T**: 本文第6〜7文に「stopped by a bakery to buy some bread」「The melon bread was warm and very delicious」とあります。
</details>
````

---

## 6. 授業・指導での活用アイデア

1. **帯活動（朝読・ウォーミングアップ）**:
   - 英文（1〜8文）を声に出して音読させ、1分間でT/Fクイズ（3問）を解かせる。
2. **スラッシュリーディング・文構造の把握指導**:
   - 行番号 `[1]`〜`[8]` が付いているため、授業中に「3行目の to study は何のために使われている？」といった発問・指示がスムーズに行えます。
3. **定期テスト・確認小テストの長文問題**:
   - 未知の英文でありながら、習った文法と語彙だけで読めるため、定期テストの大問としてそのまま流用できます。

---

## 7. 他スキルとの使い分け

| スキル名 | 特徴・使い分け |
| :--- | :--- |
| **`jhs2-grammar-reader`（本スキル）** | **ワークシート・読解プリント用**。Markdown形式で8行の読み物＋語注＋和訳＋文法解説＋3問T/Fを出力。 |
| **`beamer-english-reading`** | **スライド提示用**。LaTeX Beamer形式コード＋TTS音声（MP3）を出力。5問T/Fのアニメーション表示付き。 |
| **`english-quiz-tsv-generator`** | **テスト・スプレッドシート用**。20問（文法14問＋語彙6問）の選択式問題をTSV形式で出力。 |

---

## 8. まとめ

`jhs2-grammar-reader` は、中学生のリアルな学習到達度にぴったり寄り添ったオリジナル読解英文を生成できる頼もしいスキルです。
毎日の授業準備や小テスト作成にぜひお役立てください。
