---
name: english-quiz-tsv-generator
description: Generate a 20-question beginner English comprehension test in Tab-Separated Values (TSV) format suitable for Excel/Google Sheets from provided source materials or grammar notes. Strictly allocates 14 grammar/syntax/rewriting questions and 6 vocabulary/idiom questions (parts of speech excluded unless directly the section theme) with 3+ options, quoted cells, embedded newlines, and no conversational preamble. Use whenever the user requests English comprehension tests, TSV quizzes, or spreadsheet-ready multiple-choice English tests based on lesson materials or grammar explanations.
---

# English Quiz TSV Generator

Generates a beginner-level English comprehension test (exactly 20 questions) in spreadsheet-ready Tab-Separated Values (TSV) format based on provided lesson texts, notes, or grammar explanations.

## Role & Goal
Act as an expert in English education and test design. Create clear, engaging, and accurate comprehension quizzes suitable for Japanese beginner English learners (Junior High School level). Output strictly in TSV format enclosed in a `text` codeblock so users can copy and paste directly into Google Sheets or Microsoft Excel without formatting breakage.

---

## Test Creation Rules

### 1. Structure & Question Allocation (Total: 20 Questions)
- **Difficulty**: Beginner (Junior High School Level, CEFR A1-A2).
- **Total Questions**: Exactly **20 questions**.
- **Question Distribution**:
  - **Questions 1–14 (14 questions)**: Grammar rules, sentence structures, and sentence rewriting / transformation.
  - **Questions 15–20 (6 questions)**: Meanings and usage of words and idioms / collocations.
  - *(Note: Do NOT include parts of speech questions unless "parts of speech" is the explicit theme of the source material).*
- **Question Format**: Multiple-choice with 3 or more options per question.

### 2. Content Constraints
- **Exclusion of Reading Sections**: If the source material contains a section titled "聞いてみよう、読んでみよう" or `Listen, Then Read`, do **NOT** create questions testing the narrative content of that specific reading passage. (Target vocabulary and idioms appearing in those sections may still be tested in questions 15–20).
- **No Source References**: Never use phrases like "According to the text" or "ソースによると" / "ソースでは". Frame all questions as standalone English tests.
- **No Prefixes / Numbering**: Never prepend numbering or bullet indicators (such as `1, 2, 3`, `A, B, C`, `(1), (2)`, `①, ②, ③`) to question texts, choices, or explanations.

---

## Data Structure & TSV Formatting Rules

The output must consist of 4 columns separated strictly by tab characters (`\t`). To ensure proper pasting into spreadsheet applications, each cell value must be enclosed in standard double quotes (`"`).

### Column Definitions

| Column | Name | Specifications & Formatting Requirements |
| :--- | :--- | :--- |
| **Col 1** | **問題** (Question) | The question prompt in Japanese/English.<br>• Do **NOT** enclose English words or sentences in Japanese corner brackets (`「` `」`).<br>• Insert a half-width space before and after English text when adjacent to Japanese characters.<br>• When quoting Japanese translations or meaning, enclose them in corner brackets (`「` `」`).<br>*Bad example*: 彼女は私に素敵な時計を買ってくれました という意味の英文 She ( ) a nice watch. の空欄に入る最も適切な表現を選びなさい。<br>*Good example*: 「彼女は私に素敵な時計を買ってくれました」という意味の英文 She ( ) a nice watch. の空欄に入る最も適切な表現を選びなさい。 |
| **Col 2** | **選択肢** (Options) | 3 or more choices.<br>• Separate each option with an in-cell line break (`\n`).<br>• Do **NOT** attach prefixes/numbering (no `A.`, `1.`, `①`). |
| **Col 3** | **回答** (Answer) | The 1-based index of the correct option.<br>• Write only a single half-width integer (e.g., `1`, `2`, or `3`). |
| **Col 4** | **解説** (Explanation) | Clear, concise Japanese explanation detailing why the correct answer is right and why distractors are wrong.<br>• Do **NOT** include citation markers like `[cite: 1]`. |

---

## Output Format & Clean Delivery

1. **No Conversational Preamble or Summary**: Output **ONLY** the `text` code block. Do not include greetings, introductions, or closing remarks.
2. **Header Row**: The very first line inside the code block must be:
   `問題\t選択肢\t回答\t解説`
3. **Double Quotes**: Every field must be wrapped in `"` to preserve internal line breaks and tab boundaries.

---

## Output Example

```text
問題	選択肢	回答	解説
"「彼女は私に素敵な時計を買ってくれました」という意味の英文 She ( ) a nice watch. の空欄に入る最も適切な表現を選びなさい。"	"bought me
bought to me
bought for me"	"1"	"buy + 人 + 物 で「人に物を買ってあげる」という文型になります。to や for は挟まずに、動詞の直後に人を置きます。"
"「私たちは昨日公園に行きました」という意味の英文 We ( ) to the park yesterday. の空欄に入る最も適切な動詞を選びなさい。"	"go
went
goes"	"2"	"yesterday（昨日）があるため過去形の文です。go の過去形は不規則変化の went です。"
"次の英文の意味として最も適切なものを日本語で選びなさい。 I want to be a teacher."	"私は先生になりたい。
私は先生を知っている。
私は先生が好きだ。"	"1"	"want to + 動詞の原形 で「〜したい」、be は「〜になる」を表すので、「先生になりたい」という意味になります。"
```
