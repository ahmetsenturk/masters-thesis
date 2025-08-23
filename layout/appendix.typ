// --- Chapter numbering like "Figure 5.4" ---
#set heading(numbering: "1.")

// Reset per-chapter counters at level-1 headings
#show heading.where(level: 1): it => {
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: raw)).update(0)
  it
}

// Prefix the figure counter with the current chapter number.
#set figure(numbering: (..num) =>
  numbering("1.1", counter(heading).get().first(), num.pos().first())
)

// Use "Figure" in captions (default), left-aligned, small, with a colon.
#show figure: it => {
  show figure.caption: cap => context block(
    above: 4pt,
    width: 100%,
    grid(
      columns: (auto, 1fr),
      gutter: 6pt,
      align: left + top,          // <-- force left alignment in both cells
      [
        #set text(size: 12pt)
        #text(weight: "bold")[#cap.supplement #cap.counter.display():]
      ],
      [
        #set text(size: 12pt)
        #par(justify: true)[#cap.body]   // ragged-right
      ],
    ),
  )
  it
}

- Rate limiting exercise
- User personas
- Full interview table

#figure(caption: "Inline Text Feedback Component. This version has a custom title and does not have a reference part as it is directly under the referenced part.")[
  #image("../figures/feedback-component/text.png", width: 100%)
] <text-feedback-component>

#figure(caption: "Modeling Feedback Component. This version has a custom title and does not have a reference part as it is directly under the referenced part.")[
  #image("../figures/feedback-component/modeling.png", width: 100%)
] <modeling-feedback-component>


#figure(
  box(
    fill: rgb("#fdfdfd"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```json

    {
      "competency": {
        "description": "Explain at least two different strategies for implementing a rate limiter.", 
        "blooms_level": "Understand", 
        "grading_instruction_id": 2
      }, 
      "status": "Not Attempted", 
      "evidence": "", 
      "line_start": 0, 
      "line_end": 1
    }
    ```
    ]
  ),
  caption: [Student's submission analysis with Bloom's taxonomy, where student has not attempted a part of the exercise. The competencies are linked to the exercise and the student's submission is analysed according to the Bloom's taxonomy competencies.],
  supplement: "Figure",
) <blooms-not-attempted>


#figure(
  box(
    fill: rgb("#fdfdfd"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```json

    {
      "competency": {
        "description": "Explain what a rate limiter is and why it is necessary in distributed systems.", 
        "blooms_level": "Understand", 
        "grading_instruction_id": 1
      }, 
      "status": "Partially Correct", 
      "evidence": "A rate limiter is for stopping too many requests.", 
      "line_start": 0, 
      "line_end": 1
    }
    ```
    ]
  ),
  caption: [Student's submission analysis with Bloom's taxonomy, where student's answer is partially correct. The competencies are linked to the exercise and the student's submission is analysed according to the Bloom's taxonomy competencies.],
  supplement: "Figure",
) <blooms-partially-correct>


#figure(
  box(
    fill: rgb("#fdfdfd"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```json

    {
      "competency": {
        "description": "Explain what a rate limiter is and why it is necessary in distributed systems.", 
        "blooms_level": "Understand", 
        "grading_instruction_id": 1
      }, 
      "status": "Correct", 
      "evidence": "A rate limiter is a mechanism that restricts the number of operations (usually requests) a client can perform within a specified period of time. It’s critical in distributed systems for protecting shared resources, ensuring fair usage across clients, and preventing denial-of-service attacks or accidental overloads.", 
      "line_start": 0, 
      "line_end": 1, 
      "changes": [
        {
          "type": "Modified", 
          "is_positive": true, 
          "description": "The student has improved their explanation of what a rate limiter is and why it is necessary in distributed systems, mentioning protection of shared resources and prevention of denial-of-service attacks.", 
          "line_start": 0, 
          "line_end": 1, 
          "grading_instruction_id": 1
        }
      ]
    }
    ```
    ]
  ),
  caption: [Student's submission analysis with Bloom's taxonomy, where student has enhanced a part of the submission. The competencies are linked to the exercise and the student's submission is analysed according to the Bloom's taxonomy competencies.],
  supplement: "Figure",
) <blooms-improved>