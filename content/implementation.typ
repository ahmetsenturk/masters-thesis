#import "/utils/todo.typ": TODO
#import "evaluation.typ": outlined-figure

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



#pagebreak()

= Implementation <implementation>
In this chapter, we will describe the implementation of the proposed system objective by objective, referring to @objectives. For each objective, we will explain the implementation details, the relation with the previous chapters, our decision and why, and the implementation results.


== Profiling University Students on LMSs
Profiling university students and creating a learner profile is our first objective in this master's thesis. We wanted to create a learner profile that would respect the following three aspects: (i) competency status of the student, (ii) progress of the student, and (iii) the preferences of the student. Under this subsection, we explain what steps we take to achieve this objective.
\


=== Competencies & Progress
Our goal is to build a student profile that lets the system generate feedback that respects what students can already do and how far they have progressed, as literature suggests that effective feedback should address both mastery and process. In other words, it should tell students where they stand and how they are moving forward @lohr2024. To do this, we first needed a schema that could reliably capture these two aspects.

We began with a quick pilot to test whether LLMs can meaningfully vary feedback based on different student types. We defined three personas—high achiever, average student, and struggling student—listed their typical needs, and wrote a prompt variant for each. Using a common exercise, we compared the feedback produced for these three personas and checked whether it matched our defined needs.


Since the pilot produced clearly different and appropriate feedback across personas, we moved to a more detailed and personalized method that does not rely on fixed categories. We used an LLM-as-a-profiler approach: instead of assigning a student to a predefined persona, the LLM analyzes a submission to extract strengths and weaknesses directly from the submission. We developed this iteratively, starting with a simple prompt that identifies what the student did well and what needs work, then refining the output into a structured schema.

Next, we explored a structured way to represent competencies using the SOLO taxonomy. SOLO is designed to describe how a learner's understanding grows in complexity, which fits our aim of modeling both level and development over time @biggs1982. We prompted the LLM to map evidence from the student's submission to SOLO levels and to justify the mapping with short evidence spans.

#TODO[
  Also to following paragraph:
  In this work, we explored various methods for using LLMs to identify gaps in students' self-explanations of specific instructional material, such as explanations for code examples.
  @oli2024
]

After the SOLO experiments, we transitioned to Bloom's taxonomy. This shift was natural for two reasons: Bloom's is widely used in the literature, and Artemis already supports it by letting instructors define Bloom-type competencies and link them to exercises. Since Bloom's categorizes the educational goals rather than the student's understanding, our analysis also changed focus: rather than prompting the LLM to infer students' understanding, we prompted it to assess the submission against the specific Bloom-linked competencies already defined for the exercise @bloom1956. @student-analysis-prompt shows the prompt we used to extract the student's competency status from the submission according to Bloom's taxonomy. We defined 4 different statuses for the student's competency status: _Correct_, _Partially Correct_, _Not Attempted_, and _Not Attempted Correctly_.

#figure(
  box(
    fill: rgb("#fdfdfd"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```json
You are an educational evaluator reviewing a student's progress on an exercise.
 
1. Evaluate the student's CURRENT SUBMISSION:
    - For each required competency, assess how well the student demonstrates it using:
        - CORRECT
        - PARTIALLY_CORRECT
        - ATTEMPTED INCORRECTLY
        - NOT ATTEMPTED
    - Provide short evidence from the current submission (quote/paraphrase) and line numbers if possible.

2. Compare the PREVIOUS SUBMISSION to the CURRENT SUBMISSION:
    - Identify if the competency was improved, added, weakened, or removed.
    - For each change, specify:
        - Type: added / removed / modified / unchanged
        - Is_positive: true (improvement), false (regression), or null
        - A short description of the change and its grading relevance
        - Related grading_instruction_id if applicable
        - Line numbers in current submission if possible

Problem Statement:
{problem_statement}

Sample Solution:
{example_solution}

Grading Instructions:
{grading_instructions}

Required Competencies:
{competencies}

Student's PREVIOUS submission (with line numbers):
{previous_submission}

Student's CURRENT submission (with line numbers):
{submission}
    ```
    ]
  ),
  caption: [System prompt for LLM to generate _Student Competency Status_.],
  supplement: "Prompt",
) <student-analysis-prompt>

Since Athena can work with any LMS, we also implemented a fallback to extract competencies from exercise metadata when an explicit mapping is unavailable. @competency-extraction-prompt shows the prompt we used to extract the competencies from the exercise metadata.

#figure(
  box(
    fill: rgb("#fdfdfd"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```json
0. Analyze the problem statement, sample solution, and grading instructions to extract core competencies required to solve the task.
    - For each competency, define the expected cognitive level 
      (i.e., Recall, Understand, Apply, Analyze, Evaluate, Create).
    - Reference the grading_instruction_id if relevant.
    ```
    ]
  ),
  caption: [System prompt for LLM to extract competencies linked to an exercise. It is appended in to the @student-analysis-prompt when the competencies are not provided by the instructor via LMS.],
  supplement: "Prompt",
) <competency-extraction-prompt>
\

@profiling-schemas shows the detailed UML class diagram of the _Student Competency Status_ schema, the output of the LLM call with the prompt @student-analysis-prompt. We present example _Student Competency Status_ outputs in the Appendix (@blooms-partially-correct, @blooms-not-attempted, and @blooms-improved).


#figure(caption: [UML class diagram of _Student Competency Status_.], )[
  #image("../figures/profiling_schemas.svg", width: 73% ,format: "svg")
] <profiling-schemas>

=== Preferences
The third part of the learner profile is preferences—how a student wants to receive feedback. We used a hybrid approach to find these dimensions: (i) a short literature review to see common patterns, and (ii) small experiments with intuitive options that matter for feedback. First, we explored four dimensions: (i) detail of feedback, (ii) practicality of feedback, (iii) hint style, and (iv) ending of feedback. We modeled each as two ends of a spectrum (boolean). 

#figure(
  caption: [Explored preference dimensions, their representations, and explanations. The highlighted rows represent the final selection of dimensions used currently.],
  table(
    columns: (0.22fr,0.25fr, 0.25fr),
    inset: (x: 9pt, y: 5pt),
    stroke: none,            // no vertical borders

    // top rule
    table.hline(stroke: 0.8pt),

    // header
    [*Dimension*],  [*Value labels*], [*Description*],

    // midrule under header
    table.hline(stroke: 0.5pt),

    // group: initial candidates
    table.cell(colspan: 3, align: left)[_Initial candidates, represented as boolean (used in evaluation, later revised)_],
    table.hline(stroke: 0.4pt),

    [Detail of feedback], [Brief ↔ Detailed],
    text(hyphenate: true)[Controls the depth of the feedback text.],

    [Practicality of feedback], [Practical ↔ Theoretical],
    text(hyphenate: true)[Actionable tips vs. conceptual focus.],

    [Hint style], text(hyphenate: false)[Alternative ↔ Standard],
    [Whether feedback hints de-facto solution or alternative ways.],

    [Ending of feedback], [Summary ↔ Follow-up],
    [Whether feedback ends with a summary or by prompting the next step.],

    // rule between groups
    table.hline(stroke: 0.5pt),

    // group: final dimensions
    table.cell(colspan: 3, align: left)[_Final dimensions, represented as 3-point scale integer (currently used in implementation)_],
    table.hline(stroke: 0.4pt),

    table.cell(fill: rgb("#c5dff6"))[Detail of feedback], table.cell(fill: rgb("#c5dff6"))[1 Brief ↔ 3 Detailed],
    table.cell(fill: rgb("#c5dff6"))[Controls the depth of the feedback text; maps to injected *Detail* prompt.],

    table.cell(fill: rgb("#c5dff6"))[Tone of feedback], table.cell(fill: rgb("#c5dff6"))[1 Formal ↔ 3 Friendly],
    table.cell(fill: rgb("#c5dff6"))[Sets register and warmth; maps to injected *Formality* prompt.],

    // bottom rule
    table.hline(stroke: 0.8pt),
  )
) <pref-dimensions>

After experiments, more literature review, and user interviews (see Section @user_interviews), we found that some dimensions were confusing in practice. We therefore simplified to two dimensions that students understood well and that changed the feedback in a clear way: detail and tone/formality. The complete evolution—from initial candidates to the final selection—is summarized in @pref-dimensions.

For implementation, each selected dimension maps to a small prompt token injected at generation time. For the Detail dimension, the injected text varies from brief to detailed (see @detail-tokens). For the Tone/Formality dimension, the token adjusts the register from formal to friendly (see @formality-tokens). Both dimensions use a 3-point scale (1-3). A value of 2 means “neutral,” which injects no extra token and falls back to the base prompt. This keeps the system simple while still giving students real control over length and tone.


#figure(
  caption: [Prompts for the Detail dimension. Each value of the 3-point scale injects a different prompt text explaining the required feedback detail.],
  context[
    #set par(justify: false)
    #set text(hyphenate: false)

    #let th(body) = table.cell(align: center)[*#body*]
    #let td(body) = table.cell(align: center + horizon)[#body]
    #let blurb(body) = box(
      fill: luma(98%),
      stroke: luma(85%),
      radius: 2pt,
      inset: 10pt,
      body,
    )

    #table(
      columns: (0.2fr, 0.60fr),
      stroke: none,

      // top rule
      table.hline(stroke: 0.8pt),

      // header
      th[Value], th[Injected prompt text],

      // mid rule
      table.hline(stroke: 0.5pt),



      // Row 1
      td[1 (Brief)],
      box(
    fill: rgb("#fdfdfd"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```
        Keep the feedback short and direct — ideally 1 to 2 sentences.
        
        Example 1: Add an index on the `user_id` column to improve performance.
        
        Example 2: Clarify your thesis statement in the introduction to strengthen your argument.
        ```
      ]),
      table.hline(stroke: 0.4pt),

      // Row 2
      td[2 (Neutral)],
      td[No token injected (defaults to base prompt).],

      table.hline(stroke: 0.4pt),


      // Row 3
      td[3 (Detailed)],
        box(
      fill: rgb("#fdfdfd"),   // light gray background
      stroke: rgb("#edebeb"), // subtle border (optional)
      radius: 2pt,              // rounded corners (optional)
      inset: 10pt,              // padding
      [
      ```
        Give detailed feedback with multiple sentences, examples, and background reasoning where relevant.
        
        Example 1: Adding an index on `user_id` improves query speed by allowing the database to locate relevant rows efficiently without scanning the entire table, which is crucial for scaling.
        
        Example 2: Introducing your main argument clearly in the essay’s opening not only frames the reader’s expectations but also strengthens your persuasiveness, a technique often recommended in academic writing.
        ```
      ]),

      // bottom rule
      table.hline(stroke: 0.8pt),
    )
  ]
) <detail-tokens>


#figure(
  caption: [Prompts for the Formality dimension. Each value of the 3-point scale injects a different prompt text adjusting the register from formal to friendly.],
  context[
    #set par(justify: false)
    #set text(hyphenate: false)

    #let th(body) = table.cell(align: center)[*#body*]
    #let td(body) = table.cell(align: center + horizon)[#body]
    #let blurb(body) = box(
      fill: luma(98%),
      stroke: luma(85%),
      radius: 2pt,
      inset: 10pt,
      body,
    )

    #table(
      columns: (0.2fr, 0.60fr),
      stroke: none,

      // top rule
      table.hline(stroke: 0.8pt),

      // header
      th[Value], th[Injected prompt text],

      // mid rule
      table.hline(stroke: 0.5pt),



      // Row 1
      td[1 (Formal)],
      box(
    fill: rgb("#fdfdfd"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```
Provide feedback in a formal and professional tone, like a teacher would, keep the neutral tone.

Example 1: Add an index on the user_id column to improve performance.

Example 2: Clarify your thesis statement in the introduction to strengthen your argument.
        ```
      ]),
      table.hline(stroke: 0.4pt),

      // Row 2
      td[2 (Neutral)],
      td[No token injected (defaults to base prompt).],

      table.hline(stroke: 0.4pt),

      // Row 3
      td[3 (Friendly)],
        box(
      fill: rgb("#fdfdfd"),   // light gray background
      stroke: rgb("#edebeb"), // subtle border (optional)
      radius: 2pt,              // rounded corners (optional)
      inset: 10pt,              // padding
      [
      ```
Provide feedback in a friendly, engaging, and encouraging tone, like a tutor would. Use at least one emoji or emoticon to make the feedback more engaging 👍👉🙌🚀🎯✏️➡️:). Motivate the learner to improve and use a friendly grammar

Example 1: 💪 Let's boost your query performance by adding an index on the user_id column! 🚀

Example 2: 👉 Introducing your main argument clearly in the essay's opening not only frames the reader's expectations but also strengthens your persuasiveness. This is a technique often recommended in academic writing :)
        ```
      ]),

      // bottom rule
      table.hline(stroke: 0.8pt),
    )
  ]
) <formality-tokens>
\
Together, these two dimensions cover most of the visible variation students expect: how much to say and how to say it. They also work well with competency- and progress-aware feedback from the previous subsection, since tokens can be combined with the detected competency state without conflicts.



== Generating Personalized Feedback Utilising the Profile

After defining the learner profile schema the next step was to integrate the profile into the feedback generation process. We followed the chain-of-thought approach, where in the first step we extracted the student's competency status using the input data and the prompt introduced in the previous section, and in the following step, making use of the student's competency status, we generated the personalized feedback, by prompting LLM with @feedback-generation-prompt. 


#figure(
  box(
    fill: rgb("#fdfdfd"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```json
You are a grading assistant. Generate high-quality, structured feedback **without revealing or hinting at the sample solution**.

[...]

Your task:
- For each core submission analysis item, create **feedback** that clearly explains the student's performance
    - description: student-facing explanation, respectful and constructive. Do not reveal the solution. {writing_style}
    - type: whether they received full points, need revision, or didn't attempt it. Do not reveal the solution
    - suggested_action: a specific next step (action) the student should take. {writing_style}

Change-handling rules:
- The feedback should reflect changes between previous and current submission, for every competency you will receive two comparison fields:
  - type: added, removed, modified, or unchanged
  - is_positive: true if the change improved quality, false or null if it degraded quality, null if neutral or unclear

[...]

Detailed Submission Analysis (contains comparison between PREVIOUS and CURRENT submission):
{submission_analysis}

Student's feedback preferences:
{feedback_preferences}
    ```
    ]
  ),
  caption: [System prompt for LLM to generate personalized feedback based on the student's competency status and progress. Only the relevant parts of the prompt are shown here (i.e., personalization according to the student's learner profile).],
  supplement: "Prompt",
) <feedback-generation-prompt>

#TODO[
  End feedback schema?
  Some closing words about our prompting strategy and all
]


== Delivering the Personalized Feedback

Displaying the personalized feedback on the LMS and delivering it to the students was our last objective, which complements the two previous objectives. Our objective was to come up with a design which would meet our requirements (FR 12 and QA 1) and to implement the new feedback component on Artemis.

Starting with the prototype design and user feedback round, we iterated over the feedback component to meet the requirements. The final version of the feedback component after integrating the feedback from the UI/UX meetings is shown in @default-feedback-component.

#figure(caption: [Default feedback component. This figure shows three default feedback types: Correct, Needs Revision, and Not Attempted. On top of the component, there is the reference to the student's submission if available. Then the feedback is displayed with the credits and a title.])[
  #image("../figures/feedback-component/default.png", width: 94%)
] <default-feedback-component>








#TODO[
  Here mention how we got to the new feedback component - what steps did we take, UI/UX meetups, cross porjects etc.
]

#TODO[
  For the implementation we should come up with some diagrams, component classes, talk a bit technical here. 
]

