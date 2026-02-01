// Main template file for Quarto exam format
// This file is the entry point that Quarto uses

// Quarto Exam Format for Typst
// Core template functions for exam creation

// ============================================================================
// State Management
// ============================================================================

// Counter for questions
#let question-counter = counter("question")

// Counter for parts (a, b, c, ...)
#let part-counter = counter("part")

// Counter for subparts (i, ii, iii, ...)
#let subpart-counter = counter("subpart")

// Counter for subsubparts (α, β, γ, ...)
#let subsubpart-counter = counter("subsubpart")

// State for tracking total points
#let total-points = state("total-points", 0)

// State for tracking total bonus points
#let total-bonus-points = state("total-bonus-points", 0)

// State for tracking per-question points (for grading tables)
#let question-points = state("question-points", (:))

// Global configuration states
#let global-point-name = state("global-point-name", "points")
#let global-bonus-point-name = state("global-bonus-point-name", "bonus points")
#let global-point-position = state("global-point-position", "inline")
#let global-point-format = state("global-point-format", "parentheses")

// Solution configuration states
#let global-print-answers = state("global-print-answers", false)
#let global-solution-style = state("global-solution-style", "framed")
#let global-solution-color = state("global-solution-color", rgb("#e0e0e0"))
#let global-solution-title = state("global-solution-title", "Solution:")

// Multiple choice configuration states
#let global-choice-label-style = state("global-choice-label-style", "A.")
#let global-checkbox-char = state("global-checkbox-char", "☐")
#let global-checked-char = state("global-checked-char", "☑")
#let global-correct-choice-emphasis = state("global-correct-choice-emphasis", "bold")

// ============================================================================
// Helper Functions
// ============================================================================

// Format points for display with various formatting options
#let format-points(
  points,
  bonus: false,
  point-name: "points",
  bonus-point-name: "bonus points",
  point-format: "parentheses"
) = {
  if points == none {
    return none
  }
  
  // Handle half-points (decimals)
  let point-str = if type(points) == float or (type(points) == int and points != int(points)) {
    str(points)
  } else {
    str(int(points))
  }
  
  // Determine singular or plural
  let pts = if points == 1 {
    if bonus {
      point-str + " " + bonus-point-name.replace("points", "point")
    } else {
      point-str + " " + point-name.replace("points", "point")
    }
  } else {
    point-str + " " + if bonus { bonus-point-name } else { point-name }
  }
  
  // Apply formatting based on point-format parameter
  if point-format == "parentheses" {
    "(" + pts + ")"
  } else if point-format == "brackets" {
    "[" + pts + "]"
  } else if point-format == "box" {
    box(stroke: 0.5pt, inset: 3pt, outset: 0pt, pts)
  } else {
    // Default to parentheses if unknown format
    "(" + pts + ")"
  }
}

// ============================================================================
// Question Hierarchy Functions
// ============================================================================

// Main question function
#let question(
  points: none,
  bonus: false,
  title: none,
  label: none,
  body
) = context {
  // Get global settings
  let point-name = global-point-name.get()
  let bonus-point-name = global-bonus-point-name.get()
  let point-position = global-point-position.get()
  let point-format = global-point-format.get()
  
  // Increment question counter
  question-counter.step()
  
  // Reset sub-counters
  part-counter.update(0)
  subpart-counter.update(0)
  subsubpart-counter.update(0)
  
  // Get current question number for tracking
  let qnum = context question-counter.get().first()
  
  // Update point totals
  if points != none {
    if bonus {
      total-bonus-points.update(x => x + points)
    } else {
      total-points.update(x => x + points)
    }
    
    // Track per-question points for grading tables
    context {
      let num = question-counter.get().first()
      question-points.update(dict => {
        dict.insert(str(num), (points: points, bonus: bonus))
        dict
      })
    }
  }
  
  // Format the point display
  let point-display = if points != none {
    format-points(points, bonus: bonus, point-name: point-name, bonus-point-name: bonus-point-name, point-format: point-format)
  } else {
    none
  }
  
  // Build the question display based on point position
  v(0.5em)
  
  let question_content = if point-position == "left-margin" {
    // Points in left margin
    grid(
      columns: (auto, 1fr),
      column-gutter: 1em,
      
      // Points in left margin
      if point-display != none {
        align(right)[#point-display]
      } else {
        []
      },
      
      // Question number/title and body
      [#context {
        let num = question-counter.get().first()
        if title != none {
          strong([#num. #title])
        } else {
          strong([#num.])
        }
      } #body]
    )
  } else if point-position == "right-margin" or point-position == "inline" {
    // Points in right margin (inline is treated as right-aligned for now)
    grid(
      columns: (1fr, auto),
      column-gutter: 1em,
      
      // Question number/title and body
      [#context {
        let num = question-counter.get().first()
        if title != none {
          strong([#num. #title])
        } else {
          strong([#num.])
        }
      } #body],
      
      // Points aligned to right
      if point-display != none {
        align(right + top)[#point-display]
      } else {
        []
      }
    )
  } else if point-position == "dropped" {
    // Points at end of question text
    [#context {
      let num = question-counter.get().first()
      if title != none {
        strong([#num. #title])
      } else {
        strong([#num.])
      }
    }
    #body
    #if point-display != none { h(0.5em); point-display }]
  } else {
    // Default to right margin
    grid(
      columns: (1fr, auto),
      column-gutter: 1em,
      
      // Question number/title and body
      [#context {
        let num = question-counter.get().first()
        if title != none {
          strong([#num. #title])
        } else {
          strong([#num.])
        }
      } #body],
      
      // Points aligned to right
      if point-display != none {
        align(right + top)[#point-display]
      } else {
        []
      }
    )
  }
  
  // Output the question content
  question_content
  
  v(0.3em)
}

// Part function (a, b, c, ...)
#let part(
  points: none,
  bonus: false,
  label: none,
  body
) = context {
  // Get global settings
  let point-name = global-point-name.get()
  let bonus-point-name = global-bonus-point-name.get()
  let point-position = global-point-position.get()
  let point-format = global-point-format.get()
  
  // Increment part counter
  part-counter.step()
  
  // Reset sub-counters
  subpart-counter.update(0)
  subsubpart-counter.update(0)
  
  // Update point totals
  if points != none {
    if bonus {
      total-bonus-points.update(x => x + points)
    } else {
      total-points.update(x => x + points)
    }
  }
  
  // Format the point display
  let point-display = if points != none {
    format-points(points, bonus: bonus, point-name: point-name, bonus-point-name: bonus-point-name, point-format: point-format)
  } else {
    none
  }
  
  // Build the part display
  v(0.3em)
  
  if point-position == "left-margin" {
    block[#grid(
      columns: (auto, 1fr),
      column-gutter: 1em,
      
      if point-display != none {
        align(right)[#point-display]
      } else {
        []
      },
      
      [#h(1.5em)#context {
        let num = part-counter.get().first()
        let letter = numbering("a", num)
        [(#letter)]
      } #body]
    ) #if label != none { label }]
  } else if point-position == "dropped" {
    block[#h(1.5em)#context {
      let num = part-counter.get().first()
      let letter = numbering("a", num)
      [(#letter)]
    } #body #if point-display != none { h(0.5em) + point-display } #if label != none { label }]
  } else {
    // Default to right margin
    block[#grid(
      columns: (1fr, auto),
      column-gutter: 1em,
      
      [#h(1.5em)#context {
        let num = part-counter.get().first()
        let letter = numbering("a", num)
        [(#letter)]
      } #body],
      
      if point-display != none {
        align(right + top)[#point-display]
      } else {
        []
      }
    ) #if label != none { label }]
  }
  
  v(0.2em)
}

// Subpart function (i, ii, iii, ...)
#let subpart(
  points: none,
  bonus: false,
  label: none,
  body
) = context {
  // Get global settings
  let point-name = global-point-name.get()
  let bonus-point-name = global-bonus-point-name.get()
  let point-position = global-point-position.get()
  let point-format = global-point-format.get()
  
  // Increment subpart counter
  subpart-counter.step()
  
  // Reset sub-counters
  subsubpart-counter.update(0)
  
  // Update point totals
  if points != none {
    if bonus {
      total-bonus-points.update(x => x + points)
    } else {
      total-points.update(x => x + points)
    }
  }
  
  // Format the point display
  let point-display = if points != none {
    format-points(points, bonus: bonus, point-name: point-name, bonus-point-name: bonus-point-name, point-format: point-format)
  } else {
    none
  }
  
  // Build the subpart display
  v(0.2em)
  
  if point-position == "left-margin" {
    block[#grid(
      columns: (auto, 1fr),
      column-gutter: 1em,
      
      if point-display != none {
        align(right)[#point-display]
      } else {
        []
      },
      
      [#h(3em)#context {
        let num = subpart-counter.get().first()
        let roman = numbering("i", num)
        [(#roman)]
      } #body]
    ) #if label != none { label }]
  } else if point-position == "dropped" {
    block[#h(3em)#context {
      let num = subpart-counter.get().first()
      let roman = numbering("i", num)
      [(#roman)]
    } #body #if point-display != none { h(0.5em) + point-display } #if label != none { label }]
  } else {
    // Default to right margin
    block[#grid(
      columns: (1fr, auto),
      column-gutter: 1em,
      
      [#h(3em)#context {
        let num = subpart-counter.get().first()
        let roman = numbering("i", num)
        [(#roman)]
      } #body],
      
      if point-display != none {
        align(right + top)[#point-display]
      } else {
        []
      }
    ) #if label != none { label }]
  }
  
  v(0.2em)
}

// Subsubpart function (α, β, γ, ...)
#let subsubpart(
  points: none,
  bonus: false,
  label: none,
  body
) = context {
  // Get global settings
  let point-name = global-point-name.get()
  let bonus-point-name = global-bonus-point-name.get()
  let point-position = global-point-position.get()
  let point-format = global-point-format.get()
  
  // Increment subsubpart counter
  subsubpart-counter.step()
  
  // Update point totals
  if points != none {
    if bonus {
      total-bonus-points.update(x => x + points)
    } else {
      total-points.update(x => x + points)
    }
  }
  
  // Format the point display
  let point-display = if points != none {
    format-points(points, bonus: bonus, point-name: point-name, bonus-point-name: bonus-point-name, point-format: point-format)
  } else {
    none
  }
  
  // Build the subsubpart display
  v(0.2em)
  
  if point-position == "left-margin" {
    block[#grid(
      columns: (auto, 1fr),
      column-gutter: 1em,
      
      if point-display != none {
        align(right)[#point-display]
      } else {
        []
      },
      
      [#h(4.5em)#context {
        let num = subsubpart-counter.get().first()
        let greek = ("α", "β", "γ", "δ", "ε", "ζ", "η", "θ")
        let letter = if num <= greek.len() {
          greek.at(num - 1)
        } else {
          numbering("a", num)
        }
        [(#letter)]
      } #body]
    ) #if label != none { label }]
  } else if point-position == "dropped" {
    block[#h(4.5em)#context {
      let num = subsubpart-counter.get().first()
      let greek = ("α", "β", "γ", "δ", "ε", "ζ", "η", "θ")
      let letter = if num <= greek.len() {
        greek.at(num - 1)
      } else {
        numbering("a", num)
      }
      [(#letter)]
    } #body #if point-display != none { h(0.5em) + point-display } #if label != none { label }]
  } else {
    // Default to right margin
    block[#grid(
      columns: (1fr, auto),
      column-gutter: 1em,
      
      [#h(4.5em)#context {
        let num = subsubpart-counter.get().first()
        let greek = ("α", "β", "γ", "δ", "ε", "ζ", "η", "θ")
        let letter = if num <= greek.len() {
          greek.at(num - 1)
        } else {
          numbering("a", num)
        }
        [(#letter)]
      } #body],
      
      if point-display != none {
        align(right + top)[#point-display]
      } else {
        []
      }
    ) #if label != none { label }]
  }
  
  v(0.2em)
}

// ============================================================================
// Content Formatting Functions
// ============================================================================

// Uplevel function - format content with reduced indentation
// Useful for instructions, notes, or special content within questions
// Note: With sequential syntax, this provides visual separation rather than
// escaping nested indentation (which doesn't occur with sequential divs)
#let uplevel(body) = {
  // Add vertical spacing before
  v(0.4em)
  
  // Display content with visual emphasis
  // In sequential syntax, this is primarily for formatting/emphasis
  block(
    width: 100%,
    inset: (left: 0em, top: 0.2em, bottom: 0.2em),
    body
  )
  
  // Add vertical spacing after
  v(0.4em)
}

// Fullwidth function - format content using full width with emphasis
// Useful for exam-wide notices, instructions, or important information
#let fullwidth(body) = {
  // Add vertical spacing before
  v(0.5em)
  
  // Display content at full width with visual separation
  block(
    width: 100%,
    inset: (left: 0em, top: 0.3em, bottom: 0.3em),
    body
  )
  
  // Add vertical spacing after
  v(0.5em)
}

// ============================================================================
// Answer Space Functions
// ============================================================================

// Blank vertical space
#let answer_space(height) = {
  v(height)
}

// Empty box for answers
#let answer_box(height) = {
  v(0.3em)
  rect(
    width: 100%,
    height: height,
    stroke: 0.5pt + black,
    radius: 2pt
  )
  v(0.3em)
}

// Lined space for answers
#let answer_lines(
  height,
  spacing: 0.5cm,
  line_thickness: 0.5pt,
  line_color: black
) = {
  v(0.3em)
  
  // Calculate number of lines based on height and spacing
  let h = if type(height) == length {
    height
  } else {
    // Try to parse as length
    eval(height)
  }
  
  let s = if type(spacing) == length {
    spacing
  } else {
    eval(spacing)
  }
  
  // Calculate number of lines that fit in the height
  let num-lines = calc.floor(h / s)
  
  // Draw lines one by one with proper spacing
  for i in range(num-lines) {
    v(s - line_thickness)
    line(length: 100%, stroke: line_thickness + line_color)
  }
  
  v(0.3em)
}

// Dotted lined space for answers
#let answer_dotted_lines(
  height,
  spacing: 0.5cm,
  line_thickness: 0.5pt,
  line_color: black
) = {
  v(0.3em)
  
  // Calculate number of lines
  let h = if type(height) == length {
    height
  } else {
    eval(height)
  }
  
  let s = if type(spacing) == length {
    spacing
  } else {
    eval(spacing)
  }
  
  // Calculate number of lines that fit in the height
  let num-lines = calc.floor(h / s)
  
  // Draw dotted lines one by one with proper spacing
  for i in range(num-lines) {
    v(s - line_thickness)
    line(length: 100%, stroke: (paint: line_color, thickness: line_thickness, dash: "dotted"))
  }
  
  v(0.3em)
}

// Grid space for answers
#let answer_grid(
  height,
  spacing: 0.5cm,
  line_thickness: 0.3pt,
  line_color: gray
) = {
  v(0.3em)
  
  // Calculate dimensions
  let h = if type(height) == length {
    height
  } else {
    eval(height)
  }
  
  let s = if type(spacing) == length {
    spacing
  } else {
    eval(spacing)
  }
  
  // Draw grid
  block(
    width: 100%,
    height: h,
    stroke: 0.5pt + black,
    {
      // Horizontal lines
      let num-h-lines = calc.floor(h / s)
      for i in range(num-h-lines + 1) {
        place(
          top + left,
          dy: i * s,
          line(length: 100%, stroke: line_thickness + line_color)
        )
      }
      
      // Vertical lines - use a reasonable number based on typical page width
      let num-v-lines = 20  // Approximately 20 vertical lines for a typical grid
      for i in range(num-v-lines + 1) {
        place(
          top + left,
          dx: i * s,
          line(angle: 90deg, length: h, stroke: line_thickness + line_color)
        )
      }
    }
  )
  
  v(0.3em)
}

// Single answer line for short answers
#let answer_line(
  width: 2in,
  answer: none,
  show_answer: false
) = context {
  let print-answers = global-print-answers.get()
  
  if print-answers and show_answer and answer != none {
    // Show the answer
    box(
      width: width,
      stroke: (bottom: 0.5pt + black),
      inset: (bottom: 2pt),
      align(center)[#answer]
    )
  } else {
    // Just show the line
    box(
      width: width,
      stroke: (bottom: 0.5pt + black),
      inset: (bottom: 2pt),
      []
    )
  }
}

// Fill-in-the-blank inline
#let fillin(
  width: 2in,
  answer: none,
  show_answer: false
) = context {
  let print-answers = global-print-answers.get()
  
  if print-answers and show_answer and answer != none {
    // Show the answer
    box(
      width: width,
      stroke: (bottom: 0.5pt + black),
      inset: (bottom: 2pt, x: 4pt),
      align(center)[#answer]
    )
  } else {
    // Just show the blank
    box(
      width: width,
      stroke: (bottom: 0.5pt + black),
      inset: (bottom: 2pt),
      []
    )
  }
}
// ============================================================================
// Solution Functions
// ============================================================================

// Basic solution function with print/hide toggle
#let solution(
  style: none,
  height: auto,
  title: none,
  body
) = context {
  // Get global settings
  let print-answers = global-print-answers.get()
  let solution-style = if style != none { style } else { global-solution-style.get() }
  let solution-color = global-solution-color.get()
  let solution-title = if title != none { title } else { global-solution-title.get() }
  
  if print-answers {
    // Print the solution with appropriate styling
    v(0.3em)
    
    if solution-style == "framed" {
      // Framed solution (box around solution)
      block(
        width: 100%,
        stroke: 0.5pt + black,
        inset: 8pt,
        radius: 2pt,
        [
          #if solution-title != none and solution-title != "" {
            text(weight: "bold")[#solution-title]
            v(0.3em)
          }
          #body
        ]
      )
    } else if solution-style == "shaded" {
      // Shaded solution (colored background)
      block(
        width: 100%,
        fill: solution-color,
        inset: 8pt,
        radius: 2pt,
        [
          #if solution-title != none and solution-title != "" {
            text(weight: "bold")[#solution-title]
            v(0.3em)
          }
          #body
        ]
      )
    } else if solution-style == "unframed" {
      // Unframed solution (plain text with optional title)
      [
        #if solution-title != none and solution-title != "" {
          text(weight: "bold")[#solution-title]
          v(0.3em)
        }
        #body
      ]
    } else {
      // Default to framed
      block(
        width: 100%,
        stroke: 0.5pt + black,
        inset: 8pt,
        radius: 2pt,
        [
          #if solution-title != none and solution-title != "" {
            text(weight: "bold")[#solution-title]
            v(0.3em)
          }
          #body
        ]
      )
    }
    
    v(0.3em)
  } else {
    // Don't print solution, optionally leave space
    if height != auto and height != none {
      v(height)
    }
  }
}

// Solution or box - print solution or empty box
#let solutionorbox(
  height: 2in,
  title: none,
  body
) = context {
  let print-answers = global-print-answers.get()
  
  if print-answers {
    solution(style: "framed", title: title, body)
  } else {
    // Empty box for student to write in
    v(0.3em)
    rect(
      width: 100%,
      height: height,
      stroke: 0.5pt + black,
      radius: 2pt
    )
    v(0.3em)
  }
}

// Solution or lines - print solution or lined space
#let solutionorlines(
  height: 2in,
  spacing: 0.5cm,
  title: none,
  body
) = context {
  let print-answers = global-print-answers.get()
  
  if print-answers {
    solution(style: "framed", title: title, body)
  } else {
    // Lined space for student to write
    answer_lines(height, spacing: spacing)
  }
}

// Solution or dotted lines - print solution or dotted lined space
#let solutionordottedlines(
  height: 2in,
  spacing: 0.5cm,
  title: none,
  body
) = context {
  let print-answers = global-print-answers.get()
  
  if print-answers {
    solution(style: "framed", title: title, body)
  } else {
    // Dotted lined space for student to write
    answer_dotted_lines(height, spacing: spacing)
  }
}

// Solution or grid - print solution or grid space
#let solutionorgrid(
  height: 2in,
  spacing: 0.5cm,
  title: none,
  body
) = context {
  let print-answers = global-print-answers.get()
  
  if print-answers {
    solution(style: "framed", title: title, body)
  } else {
    // Grid space for student to write
    answer_grid(height, spacing: spacing)
  }
}

// Solution box - always print box, with or without solution
#let solutionbox(
  height: 2in,
  title: none,
  body
) = context {
  let print-answers = global-print-answers.get()
  
  v(0.3em)
  block(
    width: 100%,
    height: height,
    stroke: 0.5pt + black,
    inset: 8pt,
    radius: 2pt,
    [
      #if print-answers {
        if title != none and title != "" {
          text(weight: "bold")[#title]
          v(0.3em)
        }
        body
      }
    ]
  )
  v(0.3em)
}

// ============================================================================
// Multiple Choice Functions
// ============================================================================

// Vertical list of choices (A, B, C, ...)
#let choices(
  correct: none,
  label-style: none,
  emphasis: none,
  ..items
) = context {
  // Get global settings
  let print-answers = global-print-answers.get()
  let choice-label-style = if label-style != none { label-style } else { global-choice-label-style.get() }
  let correct-emphasis = if emphasis != none { emphasis } else { global-correct-choice-emphasis.get() }
  
  // Convert items to array
  let choice-items = items.pos()
  
  v(0.3em)
  
  // Display each choice
  for (idx, item) in choice-items.enumerate() {
    let choice-num = idx + 1
    let choice-label = if choice-label-style == "A." {
      numbering("A.", choice-num)
    } else if choice-label-style == "A)" {
      numbering("A)", choice-num)
    } else if choice-label-style == "(A)" {
      "(" + numbering("A", choice-num) + ")"
    } else if choice-label-style == "a." {
      numbering("a.", choice-num)
    } else if choice-label-style == "a)" {
      numbering("a)", choice-num)
    } else if choice-label-style == "(a)" {
      "(" + numbering("a", choice-num) + ")"
    } else {
      // Default to "A."
      numbering("A.", choice-num)
    }
    
    // Check if this is the correct answer
    let is-correct = if correct != none {
      if type(correct) == int {
        choice-num == correct
      } else if type(correct) == str {
        // Support letter-based correct answers (e.g., "A", "B")
        let correct-upper = upper(correct)
        let choice-letter = numbering("A", choice-num)
        correct-upper == choice-letter
      } else {
        false
      }
    } else {
      false
    }
    
    // Apply emphasis to correct answer if printing answers
    let content = if print-answers and is-correct {
      if correct-emphasis == "bold" {
        strong(item)
      } else if correct-emphasis == "italic" {
        emph(item)
      } else if correct-emphasis == "underline" {
        underline(item)
      } else if correct-emphasis == "bold-italic" {
        strong(emph(item))
      } else {
        strong(item)  // Default to bold
      }
    } else {
      item
    }
    
    // Display the choice
    [#choice-label #h(0.5em) #content]
    v(0.2em)
  }
  
  v(0.3em)
}

// Vertical list of checkboxes
#let checkboxes(
  correct: none,
  checkbox-char: none,
  checked-char: none,
  emphasis: none,
  ..items
) = context {
  // Get global settings
  let print-answers = global-print-answers.get()
  let checkbox = if checkbox-char != none { checkbox-char } else { global-checkbox-char.get() }
  let checked = if checked-char != none { checked-char } else { global-checked-char.get() }
  let correct-emphasis = if emphasis != none { emphasis } else { global-correct-choice-emphasis.get() }
  
  // Convert items to array
  let choice-items = items.pos()
  
  v(0.3em)
  
  // Display each checkbox choice
  for (idx, item) in choice-items.enumerate() {
    let choice-num = idx + 1
    
    // Check if this is the correct answer
    let is-correct = if correct != none {
      if type(correct) == int {
        choice-num == correct
      } else if type(correct) == str {
        let correct-upper = upper(correct)
        let choice-letter = numbering("A", choice-num)
        correct-upper == choice-letter
      } else {
        false
      }
    } else {
      false
    }
    
    // Determine which checkbox to show
    let box-char = if print-answers and is-correct {
      checked
    } else {
      checkbox
    }
    
    // Apply emphasis to correct answer if printing answers
    let content = if print-answers and is-correct {
      if correct-emphasis == "bold" {
        strong(item)
      } else if correct-emphasis == "italic" {
        emph(item)
      } else if correct-emphasis == "underline" {
        underline(item)
      } else if correct-emphasis == "bold-italic" {
        strong(emph(item))
      } else {
        strong(item)  // Default to bold
      }
    } else {
      item
    }
    
    // Display the checkbox choice
    [#box-char #h(0.5em) #content]
    v(0.2em)
  }
  
  v(0.3em)
}

// Inline (one-paragraph) choices
#let oneparchoices(
  correct: none,
  label-style: none,
  emphasis: none,
  ..items
) = context {
  // Get global settings
  let print-answers = global-print-answers.get()
  let choice-label-style = if label-style != none { label-style } else { global-choice-label-style.get() }
  let correct-emphasis = if emphasis != none { emphasis } else { global-correct-choice-emphasis.get() }
  
  // Convert items to array
  let choice-items = items.pos()
  
  v(0.3em)
  
  // Build inline choices
  let inline-content = ()
  
  for (idx, item) in choice-items.enumerate() {
    let choice-num = idx + 1
    let choice-label = if choice-label-style == "A." {
      numbering("A.", choice-num)
    } else if choice-label-style == "A)" {
      numbering("A)", choice-num)
    } else if choice-label-style == "(A)" {
      "(" + numbering("A", choice-num) + ")"
    } else if choice-label-style == "a." {
      numbering("a.", choice-num)
    } else if choice-label-style == "a)" {
      numbering("a)", choice-num)
    } else if choice-label-style == "(a)" {
      "(" + numbering("a", choice-num) + ")"
    } else {
      numbering("A.", choice-num)
    }
    
    // Check if this is the correct answer
    let is-correct = if correct != none {
      if type(correct) == int {
        choice-num == correct
      } else if type(correct) == str {
        let correct-upper = upper(correct)
        let choice-letter = numbering("A", choice-num)
        correct-upper == choice-letter
      } else {
        false
      }
    } else {
      false
    }
    
    // Apply emphasis to correct answer if printing answers
    let content = if print-answers and is-correct {
      if correct-emphasis == "bold" {
        strong(item)
      } else if correct-emphasis == "italic" {
        emph(item)
      } else if correct-emphasis == "underline" {
        underline(item)
      } else if correct-emphasis == "bold-italic" {
        strong(emph(item))
      } else {
        strong(item)
      }
    } else {
      item
    }
    
    // Add to inline content
    inline-content.push([#choice-label #h(0.3em) #content])
  }
  
  // Join with spacing
  inline-content.join(h(1.5em))
  
  v(0.3em)
}

// Inline (one-paragraph) checkboxes
#let oneparcheckboxes(
  correct: none,
  checkbox-char: none,
  checked-char: none,
  emphasis: none,
  ..items
) = context {
  // Get global settings
  let print-answers = global-print-answers.get()
  let checkbox = if checkbox-char != none { checkbox-char } else { global-checkbox-char.get() }
  let checked = if checked-char != none { checked-char } else { global-checked-char.get() }
  let correct-emphasis = if emphasis != none { emphasis } else { global-correct-choice-emphasis.get() }
  
  // Convert items to array
  let choice-items = items.pos()
  
  v(0.3em)
  
  // Build inline checkboxes
  let inline-content = ()
  
  for (idx, item) in choice-items.enumerate() {
    let choice-num = idx + 1
    
    // Check if this is the correct answer
    let is-correct = if correct != none {
      if type(correct) == int {
        choice-num == correct
      } else if type(correct) == str {
        let correct-upper = upper(correct)
        let choice-letter = numbering("A", choice-num)
        correct-upper == choice-letter
      } else {
        false
      }
    } else {
      false
    }
    
    // Determine which checkbox to show
    let box-char = if print-answers and is-correct {
      checked
    } else {
      checkbox
    }
    
    // Apply emphasis to correct answer if printing answers
    let content = if print-answers and is-correct {
      if correct-emphasis == "bold" {
        strong(item)
      } else if correct-emphasis == "italic" {
        emph(item)
      } else if correct-emphasis == "underline" {
        underline(item)
      } else if correct-emphasis == "bold-italic" {
        strong(emph(item))
      } else {
        strong(item)
      }
    } else {
      item
    }
    
    // Add to inline content
    inline-content.push([#box-char #h(0.3em) #content])
  }
  
  // Join with spacing
  inline-content.join(h(1.5em))
  
  v(0.3em)
}


// ============================================================================
// Grading Table Functions
// ============================================================================

// Vertical grade table by questions
#let grade_table_vertical(
  include_bonus: false,
  cell_width: auto,
  row_height: auto
) = context {
  let qpoints = question-points.get()
  
  // Sort question numbers
  let qnums = qpoints.keys().sorted(key: k => int(k))
  
  if qnums.len() == 0 {
    return [_No questions with points found_]
  }
  
  // Build table data
  let headers = ([Question], [Points], [Score])
  let rows = (headers,)
  
  // Add regular questions
  for qnum in qnums {
    let qdata = qpoints.at(qnum)
    if not qdata.bonus or include_bonus {
      let pts = qdata.points
      rows.push((
        [#qnum],
        [#pts],
        []  // Empty score cell
      ))
    }
  }
  
  // Add total row
  let total = total-points.get()
  let bonus = total-bonus-points.get()
  
  if include_bonus and bonus > 0 {
    rows.push((
      strong([Total]),
      strong([#total]),
      []
    ))
    rows.push((
      strong([Bonus]),
      strong([#bonus]),
      []
    ))
  } else {
    rows.push((
      strong([Total]),
      strong([#total]),
      []
    ))
  }
  
  // Create table
  v(1em)
  table(
    columns: 3,
    stroke: 0.5pt + black,
    align: center + horizon,
    inset: 8pt,
    ..rows.flatten()
  )
  v(1em)
}

// Horizontal grade table by questions
#let grade_table_horizontal(
  include_bonus: false,
  cell_width: auto,
  row_height: auto
) = context {
  let qpoints = question-points.get()
  
  // Sort question numbers
  let qnums = qpoints.keys().sorted(key: k => int(k))
  
  if qnums.len() == 0 {
    return [_No questions with points found_]
  }
  
  // Build headers
  let question_headers = ()
  let point_values = ()
  let score_cells = ()
  
  // Add regular questions
  for qnum in qnums {
    let qdata = qpoints.at(qnum)
    if not qdata.bonus or include_bonus {
      question_headers.push([#qnum])
      point_values.push([#qdata.points])
      score_cells.push([])  // Empty score cell
    }
  }
  
  // Add total column
  let total = total-points.get()
  let bonus = total-bonus-points.get()
  
  question_headers.push(strong([Total]))
  point_values.push(strong([#total]))
  score_cells.push([])
  
  if include_bonus and bonus > 0 {
    question_headers.push(strong([Bonus]))
    point_values.push(strong([#bonus]))
    score_cells.push([])
  }
  
  // Build table rows
  let num_cols = question_headers.len()
  let rows = (
    ([Question], ..question_headers),
    ([Points], ..point_values),
    ([Score], ..score_cells)
  )
  
  // Create table
  v(1em)
  table(
    columns: num_cols + 1,
    stroke: 0.5pt + black,
    align: center + horizon,
    inset: 8pt,
    ..rows.flatten()
  )
  v(1em)
}

// Vertical point table (no score column)
#let point_table_vertical(
  include_bonus: false,
  cell_width: auto,
  row_height: auto
) = context {
  let qpoints = question-points.get()
  
  // Sort question numbers
  let qnums = qpoints.keys().sorted(key: k => int(k))
  
  if qnums.len() == 0 {
    return [_No questions with points found_]
  }
  
  // Build table data
  let headers = ([Question], [Points])
  let rows = (headers,)
  
  // Add regular questions
  for qnum in qnums {
    let qdata = qpoints.at(qnum)
    if not qdata.bonus or include_bonus {
      let pts = qdata.points
      rows.push((
        [#qnum],
        [#pts]
      ))
    }
  }
  
  // Add total row
  let total = total-points.get()
  let bonus = total-bonus-points.get()
  
  if include_bonus and bonus > 0 {
    rows.push((
      strong([Total]),
      strong([#total])
    ))
    rows.push((
      strong([Bonus]),
      strong([#bonus])
    ))
  } else {
    rows.push((
      strong([Total]),
      strong([#total])
    ))
  }
  
  // Create table
  v(1em)
  table(
    columns: 2,
    stroke: 0.5pt + black,
    align: center + horizon,
    inset: 8pt,
    ..rows.flatten()
  )
  v(1em)
}

// Horizontal point table (no score column)
#let point_table_horizontal(
  include_bonus: false,
  cell_width: auto,
  row_height: auto
) = context {
  let qpoints = question-points.get()
  
  // Sort question numbers
  let qnums = qpoints.keys().sorted(key: k => int(k))
  
  if qnums.len() == 0 {
    return [_No questions with points found_]
  }
  
  // Build headers
  let question_headers = ()
  let point_values = ()
  
  // Add regular questions
  for qnum in qnums {
    let qdata = qpoints.at(qnum)
    if not qdata.bonus or include_bonus {
      question_headers.push([#qnum])
      point_values.push([#qdata.points])
    }
  }
  
  // Add total column
  let total = total-points.get()
  let bonus = total-bonus-points.get()
  
  question_headers.push(strong([Total]))
  point_values.push(strong([#total]))
  
  if include_bonus and bonus > 0 {
    question_headers.push(strong([Bonus]))
    point_values.push(strong([#bonus]))
  }
  
  // Build table rows
  let num_cols = question_headers.len()
  let rows = (
    ([Question], ..question_headers),
    ([Points], ..point_values)
  )
  
  // Create table
  v(1em)
  table(
    columns: num_cols + 1,
    stroke: 0.5pt + black,
    align: center + horizon,
    inset: 8pt,
    ..rows.flatten()
  )
  v(1em)
}

// Main grading table dispatcher function
#let grade_table(
  orientation: "vertical",
  table_type: "grade",
  include_bonus: false,
  index_by: "questions"
) = {
  // For now, only support index-by questions (page indexing is complex)
  if index_by != "questions" {
    return [_Page-indexed grading tables not yet implemented_]
  }
  
  // Dispatch to appropriate table function
  if table_type == "grade" {
    if orientation == "vertical" {
      grade_table_vertical(include_bonus: include_bonus)
    } else {
      grade_table_horizontal(include_bonus: include_bonus)
    }
  } else if table_type == "point" {
    if orientation == "vertical" {
      point_table_vertical(include_bonus: include_bonus)
    } else {
      point_table_horizontal(include_bonus: include_bonus)
    }
  } else {
    [_Unknown table type_]
  }
}

// Convenience functions for common table types
#let gradetable(orientation: "vertical", include_bonus: false) = {
  grade_table(orientation: orientation, table_type: "grade", include_bonus: include_bonus)
}

#let pointtable(orientation: "vertical", include_bonus: false) = {
  grade_table(orientation: orientation, table_type: "point", include_bonus: include_bonus)
}

// ============================================================================
// Header/Footer Utility Functions
// ============================================================================

// Get current page number
#let current_page() = context {
  counter(page).display()
}

// Get total number of pages
#let num_pages() = context {
  counter(page).final().first()
}

// Check if on first page
#let is_first_page() = context {
  counter(page).get().first() == 1
}

// Check if on last page
#let is_last_page() = context {
  counter(page).get().first() == counter(page).final().first()
}

// Check if on odd page
#let is_odd_page() = context {
  calc.odd(counter(page).get().first())
}

// Check if on even page
#let is_even_page() = context {
  calc.even(counter(page).get().first())
}

// ============================================================================
// Main Exam Template Function
// ============================================================================

#let exam(
  title: none,
  author: none,
  date: none,
  
  // Point configuration
  add-points: true,
  point-name: "points",
  bonus-point-name: "bonus points",
  point-position: "inline",
  point-format: "parentheses",
  
  // Solution configuration
  print-answers: false,
  solution-style: "framed",
  solution-color: rgb("#e0e0e0"),
  solution-title: "Solution:",
  
  // Multiple choice configuration
  choice-label-style: "A.",
  checkbox-char: "☐",
  checked-char: "☑",
  correct-choice-emphasis: "bold",
  
  // Page configuration
  paper-size: "us-letter",
  margin: 1in,
  
  // Basic header and footer configuration
  header-left: none,
  header-center: none,
  header-right: none,
  footer-left: none,
  footer-center: none,
  footer-right: none,
  
  // First page header/footer (Phase 6)
  first-page-header-left: none,
  first-page-header-center: none,
  first-page-header-right: none,
  first-page-footer-left: none,
  first-page-footer-center: none,
  first-page-footer-right: none,
  
  // Running page header/footer (Phase 6)
  running-header-left: none,
  running-header-center: none,
  running-header-right: none,
  running-footer-left: none,
  running-footer-center: none,
  running-footer-right: none,
  
  // Header/footer rules (Phase 6)
  header-rule: false,
  footer-rule: false,
  running-header-rule: none,
  running-footer-rule: none,
  
  // Extra height configuration (Phase 6)
  extra-head-height: 0pt,
  extra-foot-height: 0pt,
  
  // Document body
  body
) = {
  // Set global configuration states
  global-point-name.update(point-name)
  global-bonus-point-name.update(bonus-point-name)
  global-point-position.update(point-position)
  global-point-format.update(point-format)
  
  // Set solution configuration states
  global-print-answers.update(print-answers)
  global-solution-style.update(solution-style)
  global-solution-color.update(solution-color)
  global-solution-title.update(solution-title)
  
  // Set multiple choice configuration states
  global-choice-label-style.update(choice-label-style)
  global-checkbox-char.update(checkbox-char)
  global-checked-char.update(checked-char)
  global-correct-choice-emphasis.update(correct-choice-emphasis)
  
  // Set document metadata
  // Note: We don't set document metadata here because title and author
  // come as content from Quarto, not strings. Typst will handle this automatically.
  
  
  // Set page configuration with advanced header/footer support
  set page(
    paper: paper-size,
    margin: (
      top: margin + extra-head-height,
      bottom: margin + extra-foot-height,
      left: margin,
      right: margin
    ),
    
    // Header with first page vs running page support
    header: context {
      let on-first-page = counter(page).get().first() == 1
      
      // Determine which header to use
      let use-first-page-header = (first-page-header-left != none or
                                   first-page-header-center != none or
                                   first-page-header-right != none)
      
      let use-running-header = (running-header-left != none or
                               running-header-center != none or
                               running-header-right != none)
      
      let use-basic-header = (header-left != none or
                             header-center != none or
                             header-right != none)
      
      // Build header content
      let header-content = if on-first-page and use-first-page-header {
        // First page header
        grid(
          columns: (1fr, 1fr, 1fr),
          align: (left, center, right),
          if first-page-header-left != none { first-page-header-left } else { [] },
          if first-page-header-center != none { first-page-header-center } else { [] },
          if first-page-header-right != none { first-page-header-right } else { [] },
        )
      } else if not on-first-page and use-running-header {
        // Running page header
        grid(
          columns: (1fr, 1fr, 1fr),
          align: (left, center, right),
          if running-header-left != none { running-header-left } else { [] },
          if running-header-center != none { running-header-center } else { [] },
          if running-header-right != none { running-header-right } else { [] },
        )
      } else if use-basic-header {
        // Basic header (all pages)
        grid(
          columns: (1fr, 1fr, 1fr),
          align: (left, center, right),
          if header-left != none { header-left } else { [] },
          if header-center != none { header-center } else { [] },
          if header-right != none { header-right } else { [] },
        )
      } else {
        none
      }
      
      // Add header rule if requested
      if header-content != none {
        // Determine which rule setting to use
        let should-show-rule = if on-first-page {
          // On first page, use header-rule (not running-header-rule)
          header-rule
        } else {
          // On running pages, use running-header-rule if set, else header-rule
          if running-header-rule != none {
            running-header-rule
          } else {
            header-rule
          }
        }
        
        if should-show-rule {
          [
            #header-content
            #v(-0.5em)
            #line(length: 100%, stroke: 0.5pt)
          ]
        } else {
          header-content
        }
      } else {
        none
      }
    },
    
    // Footer with first page vs running page support
    footer: context {
      let on-first-page = counter(page).get().first() == 1
      
      // Determine which footer to use
      let use-first-page-footer = (first-page-footer-left != none or
                                   first-page-footer-center != none or
                                   first-page-footer-right != none)
      
      let use-running-footer = (running-footer-left != none or
                               running-footer-center != none or
                               running-footer-right != none)
      
      let use-basic-footer = (footer-left != none or
                             footer-center != none or
                             footer-right != none)
      
      // Helper function to add page numbers to footer content
      let add-page-numbers(content) = {
        if content == none {
          return none
        }
        // Add page number after the content
        [#content #counter(page).display() of #counter(page).final().first()]
      }
      
      // Build footer content
      let footer-content = if on-first-page and use-first-page-footer {
        // First page footer
        grid(
          columns: (1fr, 1fr, 1fr),
          align: (left, center, right),
          if first-page-footer-left != none { first-page-footer-left } else { [] },
          if first-page-footer-center != none { first-page-footer-center } else { [] },
          if first-page-footer-right != none { first-page-footer-right } else { [] },
        )
      } else if not on-first-page and use-running-footer {
        // Running page footer - add page numbers if center content exists
        grid(
          columns: (1fr, 1fr, 1fr),
          align: (left, center, right),
          if running-footer-left != none { running-footer-left } else { [] },
          if running-footer-center != none { add-page-numbers(running-footer-center) } else { [] },
          if running-footer-right != none { running-footer-right } else { [] },
        )
      } else if use-basic-footer {
        // Basic footer (all pages)
        grid(
          columns: (1fr, 1fr, 1fr),
          align: (left, center, right),
          if footer-left != none { footer-left } else { [] },
          if footer-center != none { footer-center } else { [] },
          if footer-right != none { footer-right } else { [] },
        )
      } else {
        // Default footer with page numbers
        align(center)[Page #counter(page).display() of #counter(page).final().first()]
      }
      
      // Add footer rule if requested
      if footer-content != none {
        // Determine which rule setting to use
        let should-show-rule = if on-first-page {
          // On first page, use footer-rule (not running-footer-rule)
          footer-rule
        } else {
          // On running pages, use running-footer-rule if set, else footer-rule
          if running-footer-rule != none {
            running-footer-rule
          } else {
            footer-rule
          }
        }
        
        if should-show-rule {
          [
            #line(length: 100%, stroke: 0.5pt)
            #v(-0.5em)
            #footer-content
          ]
        } else {
          footer-content
        }
      } else {
        none
      }
    }
  )
  
  // Set text defaults
  set text(font: "New Computer Modern", size: 11pt)
  
  // Set paragraph defaults
  set par(justify: false, leading: 0.65em)
  
  // Display title if provided
  if title != none {
    align(center)[
      #text(size: 16pt, weight: "bold")[#title]
    ]
    v(0.5em)
  }
  
  // Display author if provided
  if author != none {
    align(center)[
      #text(size: 12pt)[#author]
    ]
    v(0.3em)
  }
  
  // Display date if provided
  if date != none {
    align(center)[
      #text(size: 11pt)[#date]
    ]
    v(1em)
  }
  
  // Display the document body
  body
  
  // Display total points at the end (for Phase 1)
  if add-points {
    v(1em)
    line(length: 100%, stroke: 0.5pt)
    v(0.5em)
    context {
      let total = total-points.get()
      let bonus = total-bonus-points.get()
      
      if total > 0 or bonus > 0 {
        text(weight: "bold")[
          Total Points: #total
          #if bonus > 0 [
            \ Total Bonus Points: #bonus
          ]
        ]
      }
    }
  }
}
// Typst show file for exam format
// This file invokes the exam template with metadata from YAML

#show: exam.with(
  title: [Comprehensive Exam Format Demonstration],
  author: [Exam Format Extension],
  date: [2026-02-01],
  add-points: true,
  point-name: "points",
  bonus-point-name: "bonus points",
  point-position: "right-margin",
  point-format: "parentheses",
  solution-style: "framed",
  solution-color: rgb("#e0e0e0"),
  solution-title: "Solution:",
  choice-label-style: "A.",
  checkbox-char: "☐",
  checked-char: "☑",
  correct-choice-emphasis: "bold",
  first-page-header-left: [DEMO EXAM],
  first-page-header-center: [Comprehensive Feature Test],
  first-page-header-right: [Winter 2026],
  first-page-footer-left: [Name: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_],
  first-page-footer-right: [Student ID: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_],
  running-header-left: [Demo Exam],
  running-header-right: [Winter 2026],
  running-footer-center: [Page],
  running-header-rule: true,
  running-footer-rule: true,
  extra-head-height: 0.5cm,
  extra-foot-height: 0.5cm,
)


= Exam Instructions
<exam-instructions>
#fullwidth[
#strong[IMPORTANT]: This exam demonstrates all features of the Quarto Exam Format extension. Read all instructions carefully. You have 3 hours to complete this exam. Show all work for partial credit.

]
== Grading Table
<grading-table>
#grade_table(orientation: "horizontal", table_type: "grade", include_bonus: false, index_by: "questions")
\

= Section 1: Basic Question Hierarchy
<section-1-basic-question-hierarchy>
This section demonstrates the four-level question hierarchy using #strong[sequential syntax].

#question(
  points: 10,
)[
What is the derivative of $f \( x \) = x^2 + 3 x + 2$?

]
#solutionorlines(
  height: 1.5in,
  spacing: 0.5cm,
)[
$f' \( x \) = 2 x + 3$

]
#question(
  points: 20,
)[
Solve the following multi-part problem about the Pythagorean theorem.

]
#part(
  points: 5,
)[
State the Pythagorean theorem.

]
#solutionorbox(
  height: 1in,
)[
In a right triangle, $a^2 + b^2 = c^2$, where $c$ is the hypotenuse.

]
#part(
  points: 15,
)[
Provide a proof of the theorem.

]
#subpart(
  points: 7,
)[
Draw a diagram showing a right triangle with sides labeled.

]
#solutionorgrid(
  height: 2in,
  spacing: 0.5cm,
)[
\[Diagram would be drawn here\]

]
#subpart(
  points: 8,
)[
Complete the algebraic steps of the proof.

]
#subsubpart(
  points: 3,
)[
Show that $a^2 + b^2 = c^2$ using similar triangles.

]
#block[
#emph[Solution]. Using similar triangles, we can show that the areas relate such that $a^2 + b^2 = c^2$.

]
#subsubpart(
  points: 5,
)[
Explain why this relationship holds only for right triangles.

]
#solutionordottedlines(
  height: 1.5in,
  spacing: 0.6cm,
)[
The relationship depends on the 90-degree angle, which creates the specific geometric properties needed for the proof.

]
= Section 2: Point System Features
<section-2-point-system-features>
This section demonstrates point positioning, formatting, and bonus points.

#question(
  points: 7.5,
)[
This question demonstrates half-point support. Calculate $15 / 2$.

]
#answer_lines(1in, spacing: 0.5cm)
#question(
  points: 1,
)[
This question has exactly 1 point (singular form test).

]
#question(
  points: 10,
  bonus: true,
)[
#strong[Bonus Question]: What is the airspeed velocity of an unladen swallow?

]
#block[
#emph[Solution]. African or European? (Approximately 11 meters per second for European swallow)

]
= Section 3: Multiple Choice Questions
<section-3-multiple-choice-questions>
This section demonstrates various multiple choice formats.

#question(
  points: 5,
)[
Which of the following is the capital of France?

#choices(
  correct: 2,
  [
London
],
  [
Paris
],
  [
Berlin
],
  [
Madrid
],
)
]
#question(
  points: 5,
)[
Select all prime numbers (checkbox format):

#checkboxes(
  correct: 3,
  [
4
],
  [
6
],
  [
7
],
  [
9
],
)
]
#question(
  points: 5,
)[
Inline choices: Which is a vowel?

#oneparchoices(
  correct: "A",
  [
A
],
  [
B
],
  [
C
],
  [
D
],
)
]
#question(
  points: 5,
)[
Inline checkboxes: Select the correct answer.

#oneparcheckboxes(
  correct: 2,
  [
Incorrect
],
  [
Correct
],
  [
Incorrect
],
  [
Incorrect
],
)
]
#question(
  points: 10,
)[
Multiple choice with mathematical content:

#choices(
  correct: "C",
  [
$integral x thin d x = x^2 + C$
],
  [
$frac(d, d x) \( x^2 \) = x$
],
  [
$lim_(x arrow.r 0) frac(sin x, x) = 1$
],
  [
$e^(i pi) = 1$
],
)
]
= Section 4: Solution Environments
<section-4-solution-environments>
This section demonstrates different solution styles and answer spaces.

#question(
  points: 10,
)[
What is the integral of $f \( x \) = 2 x$?

]
#block[
#emph[Solution]. $integral 2 x thin d x = x^2 + C$

]
#question(
  points: 10,
)[
Explain the concept of limits.

]
#block[
#emph[Solution]. A limit describes the value that a function approaches as the input approaches some value. It's fundamental to calculus.

]
#question(
  points: 10,
)[
Describe three types of chemical bonds.

]
#block[
#emph[Solution]. 

+ #strong[Ionic bonds]: Transfer of electrons
+ #strong[Covalent bonds]: Sharing of electrons
+ #strong[Metallic bonds]: Sea of electrons

]
#question(
  points: 15,
)[
Solve the system of equations:

$ {2 x + 3 y = 7\
x - y = 1 $

]
#solutionorbox(
  height: 2.5in,
)[
From the second equation: $x = y + 1$

Substituting: $2 \( y + 1 \) + 3 y = 7$

$2 y + 2 + 3 y = 7$

$5 y = 5$

$y = 1$, therefore $x = 2$

]
#question(
  points: 10,
)[
Write a short paragraph about photosynthesis.

]
#answer_box(2in)
= Section 5: Titled Questions
<section-5-titled-questions>
This section demonstrates the titled question feature (Phase 7, Feature 1).

#question(
  points: 15,
  title: [The Fundamental Theorem of Calculus],
  label: <q:ftc>,
)[
State the Fundamental Theorem of Calculus and explain its significance.

]
#solutionorlines(
  height: 2in,
  spacing: 0.5cm,
)[
The FTC states that differentiation and integration are inverse operations. If $F' \( x \) = f \( x \)$, then $integral_a^b f \( x \) thin d x = F \( b \) - F \( a \)$.

]
#question(
  points: 12,
  title: [Newton's Method],
)[
Use Newton's method to approximate $sqrt(2)$ to three decimal places.

]
#solutionorbox(
  height: 2.5in,
)[
Starting with $x_0 = 1.5$, iterate: $x_(n + 1) = x_n - frac(f \( x_n \), f' \( x_n \))$ where $f \( x \) = x^2 - 2$.

]
#question(
  points: 20,
  bonus: true,
  title: [Challenge Problem],
)[
Prove that there are infinitely many prime numbers.

]
#block[
#emph[Solution]. #strong[Euclid's proof]: Assume finitely many primes $p_1 \, p_2 \, dots.h \, p_n$. Consider $N = p_1 dot.op p_2 dots.h.c p_n + 1$. This number is not divisible by any of the primes, so either it's prime itself or divisible by a prime not in our list. Contradiction.

]
= Section 6: Uplevel and Fullwidth
<section-6-uplevel-and-fullwidth>
This section demonstrates uplevel (instructions within questions) and fullwidth (exam-wide notices).

#fullwidth[
#strong[SECTION NOTICE]: Questions 10-12 require the use of the formula sheet provided on the last page.

]
#question(
  points: 25,
)[
Solve the following differential equations.

]
#uplevel[
#strong[Available methods]: - Separation of variables - Integrating factor - Characteristic equation

Choose the most appropriate method for each problem.

]
#part(
  points: 12,
)[
Solve: $frac(d y, d x) = y / x$

]
#solutionorbox(
  height: 2in,
)[
Separating variables: $frac(d y, y) = frac(d x, x)$

Integrating: $ln \| y \| = ln \| x \| + C$

Solution: $y = K x$ where $K = e^C$

]
#part(
  points: 13,
)[
Solve: $y'' + 4 y' + 4 y = 0$

]
#solutionorbox(
  height: 2in,
)[
Characteristic equation: $r^2 + 4 r + 4 = 0$

$\( r + 2 \)^2 = 0$, so $r = - 2$ (repeated root)

Solution: $y = \( C_1 + C_2 x \) e^(- 2 x)$

]
#question(
  points: 20,
)[
Linear algebra problem.

]
#uplevel[
#strong[Given]: Matrix $A = mat(delim: "[", 1, 2; 3, 4)$

]
#part(
  points: 10,
)[
Find the eigenvalues of $A$.

]
#solutionorlines(
  height: 1.5in,
  spacing: 0.5cm,
)[
$det \( A - lambda I \) = \( 1 - lambda \) \( 4 - lambda \) - 6 = lambda^2 - 5 lambda - 2 = 0$

$lambda = frac(5 plus.minus sqrt(33), 2)$

]
#part(
  points: 10,
)[
Find the determinant of $A$.

]
#block[
#emph[Solution]. $det \( A \) = 1 dot.op 4 - 2 dot.op 3 = - 2$

]
= Section 7: Advanced Features
<section-7-advanced-features>
This section demonstrates additional advanced features.

#question(
  points: 15,
)[
Essay question: Discuss the impact of calculus on modern science.

]
#part(
  points: 5,
)[
Introduction and thesis.

]
#answer_lines(1.5in, spacing: 0.5cm)
#part(
  points: 7,
)[
Supporting arguments with examples.

]
#answer_lines(2.5in, spacing: 0.5cm)
#part(
  points: 3,
)[
Conclusion.

]
#answer_lines(1in, spacing: 0.5cm)
#question(
  points: 20,
)[
True/False questions with explanations.

]
#part(
  points: 5,
)[
True or False: Every continuous function is differentiable.

]
#checkboxes(
  correct: 2,
  [
True
],
  [
False
],
)
#block[
#emph[Solution]. #strong[False]. Example: $f \( x \) = \| x \|$ is continuous everywhere but not differentiable at $x = 0$.

]
#part(
  points: 5,
)[
True or False: Every differentiable function is continuous.

]
#checkboxes(
  correct: 1,
  [
True
],
  [
False
],
)
#block[
#emph[Solution]. #strong[True]. Differentiability implies continuity.

]
#part(
  points: 10,
)[
Explain the relationship between continuity and differentiability.

]
#solutionorbox(
  height: 2in,
)[
Differentiability is a stronger condition than continuity. If a function is differentiable at a point, it must be continuous there. However, continuity does not guarantee differentiability.

]
= Section 9: Custom Solution Titles
<section-9-custom-solution-titles>
#question(
  points: 10,
)[
What is the limit: $lim_(x arrow.r 0) frac(sin x, x)$?

]
#block[
#emph[Solution]. The limit equals 1. This is a standard limit in calculus.

]
#question(
  points: 15,
)[
Prove the product rule for derivatives.

]
#solutionbox(
  height: 3in,
  title: "Proof:",
)[
Let $h \( x \) = f \( x \) g \( x \)$. Then:

$h' \( x \) = lim_(Delta x arrow.r 0) frac(f \( x + Delta x \) g \( x + Delta x \) - f \( x \) g \( x \), Delta x)$

Adding and subtracting $f \( x + Delta x \) g \( x \)$:

$= lim_(Delta x arrow.r 0) [frac(f \( x + Delta x \) g \( x + Delta x \) - f \( x + Delta x \) g \( x \) + f \( x + Delta x \) g \( x \) - f \( x \) g \( x \), Delta x)]$

$= lim_(Delta x arrow.r 0) [f \( x + Delta x \) frac(g \( x + Delta x \) - g \( x \), Delta x) + g \( x \) frac(f \( x + Delta x \) - f \( x \), Delta x)]$

$= f \( x \) g' \( x \) + g \( x \) f' \( x \)$ ∎

]
= Section 10: Mixed Content
<section-10-mixed-content>
#question(
  points: 25,
)[
Programming question: Write a function to compute the factorial of a number.

]
#uplevel[
#strong[Language]: Python 3. You may use recursion or iteration.

]
#part(
  points: 15,
)[
Write the recursive version.

]
#solutionorbox(
  height: 2.5in,
)[
Recursive solution: Check if n is 0 or 1 (base case), return 1. Otherwise, return n multiplied by factorial(n-1).

]
#part(
  points: 10,
)[
Write the iterative version.

]
#solutionorbox(
  height: 2in,
)[
Iterative solution: Initialize result to 1, then multiply result by each integer from 2 to n.

]
#question(
  points: 20,
)[
Statistical analysis question.

]
#uplevel[
#strong[Given data]: Sample mean $macron(x) = 100$, sample standard deviation $s = 15$, sample size $n = 25$.

]
#part(
  points: 10,
)[
Calculate the 95% confidence interval for the population mean.

]
#solutionorlines(
  height: 2in,
  spacing: 0.5cm,
)[
Using $t$-distribution with $d f = 24$: $t_0.025 approx 2.064$

$C I = macron(x) plus.minus t dot.op s / sqrt(n) = 100 plus.minus 2.064 dot.op 15 / sqrt(25) = 100 plus.minus 6.19$

$C I = \[ 93.81 \, 106.19 \]$

]
#part(
  points: 10,
)[
Interpret the confidence interval.

]
#block[
#emph[Solution]. We are 95% confident that the true population mean lies between 93.81 and 106.19.

]
= Grading Summary Tables
<grading-summary-tables>
== Vertical Grade Table
<vertical-grade-table>
#grade_table(orientation: "vertical", table_type: "grade", include_bonus: false, index_by: "questions")
\

== Horizontal Point Table (No Score Column)
<horizontal-point-table-no-score-column>
#grade_table(orientation: "horizontal", table_type: "point", include_bonus: false, index_by: "questions")
\

== Grade Table with Bonus Points
<grade-table-with-bonus-points>
#grade_table(orientation: "horizontal", table_type: "grade", include_bonus: true, index_by: "questions")
