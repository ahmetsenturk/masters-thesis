#import "/utils/todo.typ": TODO


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
    above: 4pt,        // space between figure and caption
    width: 100%,
    align(left)[
      #set text(size: 12pt)
      #text(weight: "bold")[#cap.supplement #cap.counter.display()#text(weight: "bold")[: ]] #cap.body
    ],
  )
  it
}



#pagebreak()

= Implementation <implementation>
In this chapter, we will describe the implementation of the proposed system. We will explain this objective by objective, referring to @objectives. For each objective, we will explain the implementation details, the relation with the previous chapters, our decision and why, and the implementation results.


== Profiling University Students on LMSs
Profiling university students and creating a learner profile is our first objective in this master's thesis. We wanted to create a learner profile that would respect the following three aspects: (i) competency status of the student, (ii) progress of the student, and (iii) the preferences of the student. Under this subsection, we explain what steps we take to achieve this objective.
\

=== Learner Profile Schema
As mentioned in the introduction, we defined personalized feedback as feedback that respects the following three aspects of the student: (i) competency status, (ii) progress, and (iii) preferences. Our goal with defining the learner profile was to create a schema that would allow us to capture these three aspects. The following subsections will discuss how we profiled these three aspects.

==== Competencies & Progress
Competencies and progress are closely related, so we discuss them together. Our goal is to build a student profile that lets the system generate feedback that respects what students can already do and how far they have progressed. To do this, we first needed a schema that could reliably capture these two aspects.

The literature suggests that effective feedback should address both mastery and process. In other words, it should tell students where they stand and how they are moving forward @lohr2024. We began with a quick pilot to test whether LLMs can meaningfully vary feedback based on simple student types. We defined three personas—high achiever, average student, and struggling student—listed their typical needs, and wrote a prompt variant for each. Using a common exercise, we compared the feedback produced for these three personas and checked whether it matched our defined needs.


Since the pilot produced clearly different and appropriate feedback across personas, we moved to a more detailed and personalized method that does not rely on fixed categories. We used an LLM-as-a-profiler approach: instead of assigning a student to a predefined persona, the LLM analyzes a submission to extract strengths and weaknesses directly from the text. We developed this iteratively, starting with a simple prompt that identifies what the student did well and what needs work, then refining the output into a structured schema.

#TODO[
  Reference to LLM-as-profiler
  One example outfit with SOLO taxonomy.
]

Next, we explored a structured way to represent competencies using the SOLO taxonomy. SOLO is designed to describe how a learner's understanding grows in complexity, which fits our aim of modeling both level and development over time @biggs1982. We asked the LLM to map evidence from the student's submission to SOLO levels and to justify the mapping with short evidence spans.

#TODO[
  Also to following paragraph:
  In this work, we explored various methods for using LLMs to identify gaps in students' self-explanations of specific instructional material, such as explanations for code examples.
  @oli2024
]

After the SOLO experiments, we transitioned to Bloom's taxonomy. This shift was natural for two reasons: Bloom's is widely used in the literature, and Artemis already supports it by letting instructors define Bloom-type competencies and link them to exercises. Since the nature of the two taxonomies is different, while SOLO assesses students' understanding of the subject, Bloom's categorizes the educational goals, our analysis also changed focus: rather than asking the LLM to infer students' understanding, we asked it to assess the submission against the specific Bloom-linked competencies already defined for the exercise. See @blooms-partially-correct for a "Partially Correct" case and @blooms-not-attempted for a "Not Attempted" case on the same exercise. To keep Athena portable to other LMSs, we also implemented a fallback to extract competencies from exercise metadata when an explicit mapping is unavailable.


#figure(
  box(
    fill: rgb("#f8f8f8"),   // light gray background
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
  supplement: "Listing",
) <blooms-partially-correct>

#figure(
  box(
    fill: rgb("#f8f8f8"),   // light gray background
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
  caption: [Student's submission analysis with Bloom's taxonomy, where student has not attempted a part of the exercise. The competencies are linked to the exercise and the student's submission is analysed according to the Bloom's taxonomy competencies.]
) <blooms-not-attempted>


Finally, we extended the schema to capture the student's progress. The system compares the current submission with the previous one for each competency and records changes (i.e., added, removed, modified, or unchanged). This produces a compact "before-and-after" view at the competency level. As in @blooms-improved, the schema stores a positive change with a short description and line span. The result is feedback that can show where the student is and how they moved between attempts, which better supports process-focused guidance.


#figure(
  box(
    fill: rgb("#f8f8f8"),   // light gray background
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
  caption: [Student's submission analysis with Bloom's taxonomy, where student has enhanced a part of the submission. The competencies are linked to the exercise and the student's submission is analysed according to the Bloom's taxonomy competencies.]
) <blooms-improved>

#TODO[
  Reference the SOLO and Bloom's taxonomy here. 
]


#TODO[
  Continue here
]

==== Preferences
The third part of the learner profile is preferences—how a student wants to receive feedback. Preferences are the dimensions that students can set themselves. We used a hybrid approach to find these dimensions: (i) a short literature review to see common patterns, and (ii) small experiments with intuitive options that matter for feedback.

We began with the same three personas as before and set different preferences for each. The feedback generated for each persona matched these preferences, so we moved to a student-level representation instead of persona-level.

Next, we turned preferences into explicit dimensions that students can set. Our first list had four: (i) detail of feedback, (ii) practicality of feedback, (iii) hint style, and (iv) ending of feedback. We modeled each as two ends of a spectrum (boolean). After experiments, more literature review, and user interviews (see Section @user_interviews), we found that some dimensions were confusing in practice. We therefore simplified to two dimensions that students understood well and that changed the feedback in a clear way: detail and tone/formality. The complete evolution—from initial candidates to the final selection—is summarized in @pref-dimensions.

For implementation, each selected dimension maps to a small prompt token injected at generation time. For the Detail dimension, the injected text varies from brief to detailed (see Figure @detail-tokens). For the Tone/Formality dimension, the token adjusts the register from formal to friendly (see Figure @formality-tokens). Both dimensions use a 3-point scale (1–3). A value of 2 means “neutral,” which injects no extra token and falls back to the base prompt. This keeps the system simple while still giving students real control over length and tone.

Together, these two dimensions cover most of the visible variation students expect: how much to say and how to say it. They also work well with competency- and progress-aware feedback from the previous subsection, since tokens can be combined with the detected competency state without conflicts.

#figure(
  caption: [Dimensions explored and final selection],
  table(
    columns: (auto, auto, auto, auto),
    inset: 6pt,
    stroke: 0.5pt,
    fill: luma(100%),

    // header
    [*Dimension*], [*Representation*], [*Value labels / scale*], [*Description*],
    table.hline(),

    // group: initial candidates (pilots)
    table.cell(colspan: 4)[*Initial candidates (used in evaluation, later revised)*],
    table.hline(),

    [Detail of feedback],
    [Boolean (two ends)],
    [Brief ↔ Detailed],
    [Controls the depth/length of feedback text.],

    [Practicality of feedback],
    [Boolean (two ends)],
    [Practical ↔ Theoretical],
    [Actionable tips vs. conceptual/justificatory focus.],

    [Hint style],
    [Boolean (two ends)],
    [Alternative ↔ Standard],
    [Style of hints; often conflated with course/lecturer hint policies.],

    [Ending of feedback],
    [Boolean (two ends)],
    [Summary ↔ Follow-up question],
    [Whether feedback ends by summarizing or by prompting the next step.],

    table.hline(),

    // group: final dimensions (used in implementation/evaluation)
    table.cell(colspan: 4)[*Final dimensions (currently used in implementation)*],
    table.hline(),

    [Detail of feedback],
    [3-point scale (int)],
    [1 Brief … 3 Detailed],
    [Sets brevity vs. elaboration; maps to injected *Detail* token.],

    [Tone / Formality],
    [3-point scale (int)],
    [1 Formal … 3 Friendly],
    [Sets register and warmth; maps to injected *Formality* token.]),
  ) <pref-dimensions>




#figure(
  caption: [Feedback Detail tokens],
  table(
    columns: (auto, auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt,
    fill: luma(98%),
    [*Dimension*], [*Value*], [*Injected prompt text*],

    table.cell(rowspan: 3)[feedback_detail], [1 (Brief)],
     box(
    fill: rgb("#f8f8f8"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```
Keep the feedback short and direct — ideally 1 to 2 sentences.
Example 1: Add an index on the user_id column to improve performance.
Example 2: Clarify your thesis statement in the introduction to strengthen your argument.
```
    ]
  ),

    [2 (Neutral)],
    [No token injected (defaults to base prompt).],

    [3 (Detailed)],
    box(
    fill: rgb("#f8f8f8"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```
Give detailed feedback with multiple sentences, examples, and background reasoning where relevant.
Example 1: Adding an index on user_id improves query speed by allowing the database to locate relevant rows efficiently without scanning the entire table, which is crucial for scaling.
Example 2: Introducing your main argument clearly in the essay's opening not only frames the reader's expectations but also strengthens your persuasiveness, a technique often recommended in academic writing.
```
    ]
  ),
  )
) <detail-tokens>

#figure(
  caption: [Feedback Formality tokens],
  table(
    columns: (auto, auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt,
    fill: luma(98%),
    [*Dimension*], [*Value*], [*Injected prompt text*],

    table.cell(rowspan: 3)[feedback_formality], [1 (Formal)],
    box(
    fill: rgb("#f8f8f8"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```
Provide feedback in a formal and professional tone, like a teacher would, keep the neutral tone.
Example 1: Add an index on the user_id column to improve performance.
Example 2: Clarify your thesis statement in the introduction to strengthen your argument.
```
    ]
  ),

    [2 (Neutral)],
    [No token injected (defaults to base prompt).],

    [3 (Friendly)],
    box(
    fill: rgb("#f8f8f8"),   // light gray background
    stroke: rgb("#edebeb"), // subtle border (optional)
    radius: 2pt,              // rounded corners (optional)
    inset: 10pt,              // padding
    [
    ```
Provide feedback in a friendly, engaging, and encouraging tone, like a tutor would. Use at least one emoji or emoticon to make the feedback more engaging 👍👉🙌🚀🎯✏️➡️:). Motivate the learner to improve and use a friendly grammar
Example 1: 💪 Let's boost your query performance by adding an index on the user_id column! 🚀
Example 2: 👉 Introducing your main argument clearly in the essay's opening not only frames the reader's expectations but also strengthens your persuasiveness. This is a technique often recommended in academic writing :)
```
    ]
  ),
  )
) <formality-tokens>


== Generating Personalised Feedback Utilising the Profile

After defining the learner profile schema and the input sources for the learner profile, the next step was to integrate the profile into the feedback generation process.

We used a chain-of-thought approach, where in the first step we extracted the student's competency status using the input data, and in the following step, making use of the student's competency status, we generated the personalised feedback. 

#TODO[
  Chain-of-thought reference here.
]

#TODO[
  We can create a simple diagram for here
]

Prompting was the key for this objective. We tried many different prompts, arranging inputs differently and injecting the student's profile into the prompt in different ways.

TODO: Put the feedback generation prompt, possibly an activity diagram from Athena

#TODO[
  Put the prompts here.
]

#TODO[
  End feedback schema?
]



== Delivering the Personalised Feedback

Displaying the personalised feedback on the LMS and delivering it to the students was our last objective, which complements the two previous objectives. Since Artemis already was providing either automated or manual feedback, there was already a feedback display on the platform. Our objective was to come up with a design which would meet our requirements, to identify the problems and missing features with the current versiom comparing to our vision, and to propose & implement a new feedback component for Artemis.

=== How Should a Personalised Feedback Look Like?

According to Hattie and Timperley, the feedback should be actionable, understandable, and should be aligned with the student's needs @hattie2007. This should also apply to how feedback is delivered to the students. While the content of the feedback is important, the way it is delivered is also important. In the context of this thesis, we defined that a feedback should be delivered in a way that is (i) actionable (i.e., students should be able to understand what is the next step they should take) and (ii) understandable (i.e., students should be able to understand what the feedback is about, where did they succeed and where did they fail)

#TODO[
  Refer to FR 12 and QA 1 here
]

=== The Problem with the Current Feedback Component on Artemis

Analysing the current feedback component on Artemis, we identified the following problems which were not meeting our requirements: (i) it was hard to understand immediately the performance due to the lack of colour coding, (ii) the feedback was not very actionable, the next steps were not clear, and (iii) the feedback was not uniformed accross exercise types, each exercise type had a different design


=== The Proposed Feedback Component

We came up with a new feedback component that is more aligned with our requirements. The new component is more intuitive, more actionable, and more uniformed accross exercise types.
\
\
TODO: Put the new feedback component here.







#TODO[
  Put the new feedback component here.
]

#TODO[
  Here mention how we got to the new feedback component - what steps did we take, UI/UX meetups, cross porjects etc.
]

#TODO[
  For the implementation we should come up with some diagrams, component classes, talk a bit technical here. 
]

