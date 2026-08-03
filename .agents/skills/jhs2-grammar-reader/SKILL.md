---
name: jhs2-grammar-reader
description: Generate an ~8-line English reading passage (dialogue, story, diary, expository text, etc.) based on provided English grammar explanation source text, targeting Japanese Junior High School Grade 2 (中2) vocabulary level. Includes a True/False comprehension quiz, footnotes for words beyond JHS2 level, and Japanese translations. Use this skill whenever the user provides grammar notes or requests reading materials, passages, or reading comprehension texts based on specific English grammar concepts for junior high school students.
---

# JHS2 Grammar Reader Generator

Generates high-quality, engaging 8-line English reading passages tailored to Japanese Junior High School 2nd Grade (中2) students, built directly around target grammar points extracted from source materials.

## Workflow

### Step 1: Analyze Target Grammar Point
- Read the provided source text, notes, or grammar explanation carefully.
- Identify the core grammar concept (e.g., Infinitive, Passive Voice, Comparison, Conjunctions `when`/`if`/`because`/`that`, `be going to`, `must`/`have to`, Past Continuous, Give/Show/Tell + O1 + O2).

### Step 2: Select Best Passage Format
Vary the text format dynamically based on the grammar topic and context to keep reading materials fresh and authentic:
- **Dialogue / Conversation**: Best for spoken expressions, suggestions, plans (`be going to`, `have to`, `shall we`).
- **Diary / Journal Entry**: Best for past continuous, personal experiences, thoughts, and memories.
- **Narrative / Short Story**: Best for comparisons, fables, cause-and-effect, or sequential events.
- **Expository / Informative Text**: Best for passive voice, environmental/cultural facts, or simple science topics.
- **Letter / Email / Speech**: Best for introductions, advice, or expressing gratitude.

### Step 3: Write the English Passage
- **Length**: Exactly or approximately 8 lines / sentences (~70-100 words).
- **Target Grammar Inclusion**: Embed 2-4 natural instances of the target grammar structure throughout the text.
- **Vocabulary Level**: Target Japanese Junior High School 2nd Grade (中2) standard vocabulary.
- **Footnotes**: If any word or phrase exceeds standard JHS2 vocabulary, add a footnote marker `[*1]`, `[*2]` in the text and list them at the bottom with a brief Japanese translation and difficulty note.

### Step 4: Add Comprehension Quiz & Translation
- **True / False Quiz**: Provide 3 True/False questions in English testing passage comprehension. Include the Answer Key (T/F) and brief explanation in Japanese.
- **Japanese Translation**: Provide a natural Japanese translation of the entire passage line-by-line or paragraph-by-paragraph.
- **Grammar Focus**: Briefly highlight how the target grammar was used in key sentences.

---

## Output Template Structure

ALWAYS use the following markdown structure when generating the reading output:

# 📚 English Reading Passage: [Title]

**Target Grammar**: [e.g., 不定詞の副詞的用法 (Infinitive of Purpose: to + verb)]  
**Format**: [e.g., Diary Entry / Conversation / Narrative / Expository]

---

### English Passage

[1] ...  
[2] ...  
[3] ...  
[4] ...  
[5] ...  
[6] ...  
[7] ...  
[8] ...  

*(Footnotes if applicable)*
- `[*1]` **word/phrase**: 日本語訳（注: 中3以上レベル）

---

### 🇯🇵 日本語訳

[1] ...  
[2] ...  
...  

---

### 💡 Grammar Focus (文法ポイント)

- **[文法項目名]**: 英文中の具体的な使用箇所と簡単な補足解説

---

### ❓ True / False Quiz (正誤問題)

Read the passage and write **T** (True) or **F** (False) for each statement.

1. [Statement 1 in English] ( T / F )
2. [Statement 2 in English] ( T / F )
3. [Statement 3 in English] ( T / F )

<details>
<summary><b>解答と解説 (Click to reveal)</b></summary>

1. **[T / F]**: 解説文（日本語）
2. **[T / F]**: 解説文（日本語）
3. **[T / F]**: 解説文（日本語）
</details>

---

## Examples

### Example 1: Infinitive of Purpose (to + 動詞の原形) -> Diary Format
Target Grammar: 不定詞（目的：〜するために）  
Genre: Diary Entry

**English Passage**:  
[1] Today, I got up early to practice basketball in the park.  
[2] I ran for 30 minutes to get stronger.  
[3] After that, I met my friend Kenta near the station.  
[4] We went to the library to study for our English test.  
[5] There were many students in the library.  
[6] Kenta worked hard to finish his homework.  
[7] I helped him to understand some difficult questions.  
[8] We left the library at 5 p.m. to buy some ice cream.  

### Example 2: Passive Voice (受動態: be + 過去分詞) -> Informative Text
Target Grammar: 受動態（〜される、〜された）  
Genre: Expository Text

**English Passage**:  
[1] Today, many famous movies are enjoyed by people around the world.  
[2] My favorite movie, *The Blue Sky*, was made in Japan 10 years ago.  
[3] Its story was written by a young Japanese writer.  
[4] Beautiful songs were selected for this movie by a popular musician[*1].  
[5] It was shown in many foreign countries last year.  
[6] The movie is loved by children and adults alike.  
[7] A new movie by the same director[*2] will be released next month.  
[8] I hope it will be watched by many people again.  

*Footnotes:*  
- `[*1]` **musician**: 音楽家（注: 中3〜高校レベル）  
- `[*2]` **director**: 映画監督（注: 中3〜高校レベル）
