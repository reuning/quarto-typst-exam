 [!WARNING] 
> This was a mostly vibe coded project as I wanted to port the latex exam class to Typst because of PDF accessibility issues (also Typst seems less frustrating?). I used [Roo Code](https://roocode.com/) in VS with Claude Sonnet 4.5 through [OpenRouter](https://openrouter.ai/). This is the ["alpha-slop" version.](https://simonwillison.net/2026/Jan/11/answers/)


# Quarto Exam Format for Typst

A Quarto extension that provides an exam format for Typst, inspired by the LaTeX `exam` document class.

## Installation

```bash
quarto add [your-username]/exam
```

## Quick Start

Create a `.qmd` file with the exam format:

```markdown
---
title: "Sample Exam"
author: "Professor Smith"
date: "January 25, 2026"
format:
  exam-typst:
    keep-typ: true
    add-points: true
---

# Instructions

Please answer all questions. Show your work for full credit.

::: {.question points="10"}
What is the capital of France?
:::

::: {.question points="15"}
Explain the Pythagorean theorem.
:::

::: {.part points="5"}
State the theorem.
:::

::: {.part points="10"}
Provide a proof.
:::
```

## Important: Sequential Syntax

This extension uses **sequential div syntax** for question parts. Parts, subparts, and subsubparts should be placed **after** (not inside) their parent elements.

**Correct:**
```markdown
::: {.question points="15"}
Main question text.
:::

::: {.part points="5"}
Part (a) text.
:::

::: {.part points="10"}
Part (b) text.
:::
```

**Incorrect:**
```markdown
::: {.question points="15"}
Main question text.

::: {.part points="5"}
Part (a) text.
:::
:::
```

See [`docs/WHY_SEQUENTIAL_SYNTAX.md`](docs/WHY_SEQUENTIAL_SYNTAX.md) for the technical explanation.

## Documentation

- **[Sequential Syntax Guide](docs/SEQUENTIAL_SYNTAX_GUIDE.md)** - Complete guide to writing exams with this format
- **[Why Sequential Syntax?](docs/WHY_SEQUENTIAL_SYNTAX.md)** - Explanation of the nested div problem
- **[Example Exam](test-exam.qmd)** - Full example demonstrating all features

## Features

### Current Features (Phase 1)
- ✅ Question hierarchy (questions, parts, subparts, subsubparts)
- ✅ Automatic numbering (1, 2, 3... / a, b, c... / i, ii, iii... / α, β, γ...)
- ✅ Point values with right-aligned display
- ✅ Bonus points
- ✅ Point totaling
- ✅ Customizable headers and footers

### Planned Features
- Multiple choice questions
- Solution environments (print/hide toggle)
- Answer spaces (blank, lined, grid)
- Grading tables
- Additional point display options

## Configuration

Available YAML options:

```yaml
format:
  exam-typst:
    keep-typ: true              # Keep intermediate .typ file
    add-points: true            # Display point values
    point-name: "points"        # Customize point label
    bonus-point-name: "bonus points"
```

## Development Status

This extension is in active development. See [`PHASE1-COMPLETE.md`](PHASE1-COMPLETE.md) for implementation details.

## License

This work may be distributed and/or modified under the conditions of the LaTeX Project Public License, either version 1.3 of this license or (at your option) any later version.

## Credits

Inspired by the LaTeX `exam` document class by Philip Hirschhorn.
