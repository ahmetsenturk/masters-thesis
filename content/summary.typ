#import "/utils/todo.typ": TODO

// --- Chapter numbering like "Figure 5.4" ---
#set heading(numbering: "1.1")

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
= Summary <summary>
This chapter concludes this thesis with the status update regarding the requirements, underlines the contributions, and provides an outlook on possible directions for future work.


== Status
@fr-status summarizes the status according to the functional requirements. We discuss the realized and open goals in detail in the following subsections.

#let status(kind) = {
  // Use a bigger, consistent size for all glyphs
  let size = 12pt

  let glyph = if kind == "done" {
    "●"    // complete
  } else if kind == "wip" {
    "◐"    // in progress (try ◑ or ◒ if you prefer)
  } else if kind == "plan" {
    "⚬"    // planned
  } else {
    "•"    // fallback
  }

  // Per-glyph visual compensation
  let k = if kind == "done" { 1.50 }          // looks largest already
    else if kind == "wip"  { 1.50 }           // half circle renders smaller
    else if kind == "plan" { 1.50 }           // outline looks smaller
    else { 1.00 }

  text(size: size * k)[#glyph]
}

#figure(
  caption: [Functional requirements' status overview.],
  table(
    columns: (auto, 1fr, auto),
    inset: (x: 9pt, y: 5pt),
    stroke: none,

    table.hline(stroke: 0.8pt),
    [*FR*], [*Functional Requirement*], [*Status*],
    table.hline(stroke: 0.5pt),

    [FR 1], [Configure Feedback Preferences],       [#status("done")],
    [FR 2], [Utilize Competencies],         [#status("done")],
    [FR 3], [Extract Competencies],                 [#status("done")],
    [FR 4], [Assess Student's Competency Status], [#status("done")],
    [FR 5], [Utilize Feedback Preferences],           [#status("done")],
    [FR 6], [Utilize Submission History],           [#status("done")],
    [FR 7], [Utilize Engagement Data],           [#status("plan")],
    [FR 8], [Generate Learner Profiles],           [#status("done")],
    [FR 9], [Update Learner Profiles],           [#status("wip")],
    [FR 10], [Request Personalized Feedback],           [#status("done")],
    [FR 11], [Generate Personalized Feedback],           [#status("done")],
    [FR 12], [View Personalized Feedback],           [#status("done")],

    table.hline(stroke: 0.8pt),
    [],
    grid(
  columns: (auto, auto, auto),
  gutter: 16pt,
  align: left + horizon,
  [#status("done") Completed],
  [#status("wip") Partially Completed],
  [#status("plan") Open],
)
  )
) <fr-status>


#set text(size: 12pt)
=== Realized Goals
The first objective—profiling university students on LMSs—was mostly realized (FR 1, FR 2, FR 4, FR 6, and FR 8). We designed a learner profile schema to capture competencies, progress, and explicit feedback preferences. We implemented this schema within the existing Athena pipeline to ensure compatibility with the current infrastructure, meeting the maintainability and reusability expectations defined in QA 3 and C 2. During the integration, we leveraged structured LLM prompts to extract competency status and incorporated preference data, ensuring consistency and accuracy while minimizing additional system complexity (QA 8 and QA 9). We also tested the feedback preference configuration workflow with user interviews to ensure that the experience felt intuitive for students. Based on their input, we iterated over the design to make it more user-friendly (QA 2).

The second objective—generating personalized feedback utilizing the profile—was completed (FR 3, FR 5, FR 10, and FR 11). This work extended the feedback generation pipeline by designing a multi-stage workflow that dynamically injects competency status and preference tokens into the prompts. This approach allowed the feedback to adapt to each learner's needs while preserving response quality and latency within the thresholds specified in QA 6 and QA 7. Careful integration with existing assessment modules ensured a seamless extension of Athena without disrupting its core services, aligning with QA 9 on extensibility and C 1 on cost-efficiency.

The third objective—delivering the personalized feedback through Artemis—was realized by introducing an actionable and understandable feedback component (FR 12, QA 1, and QA 2). Iterative design and user testing ensured that the interface met usability and clarity requirements, and the integration with the Artemis client and server architecture maintained compliance with performance and reliability constraints.

=== Open Goals <open-goals>
Despite these achievements, a few aspects remain open or partially realized, predominantly due to time constraints. In this section, we discuss the open goals in detail.

The first aspect we have not realized is the use of engagement data (FR 7). When analyzing the problem and envisioning the solution through literature research and experiments, engagement data (e.g., forum posts, chats with AI assistants) was a potential input source for the learner profile to which we personalized the feedback. However, this complex problem required a detailed end-to-end implementation plan, from filtering the data, making meaning out of it, such as student struggles, and integrating it into the learner profile. Integration requires some attention, as every student uses these tools differently, the system needs to be smart enough to prioritize this data.  

The other part we could not address was updating the learner profile (FR 9). The current state of the implementation generates the _Student Competency Status_ on the fly and persists the data. Even though the system can understand the student's progress by analyzing the previous and the current submissions, keeping a track of the _Student Competency Status_, therefore the _Learner Profile_, might increase the accuracy of the personalization and the reference to the student's progress.

== Contributions
This thesis set out to bridge the gap between automated feedback systems, which scale well but lack personalization, and manual feedback, which is highly individualized but not scalable. The proposed profile-aware feedback architecture successfully addresses this challenge. It introduces a scalable learner profiling framework for Artemis and Athena, a personalized feedback generation pipeline that tailors responses based on a student's profile, and user interface components that make the system accessible and intuitive for students.

The evaluation, conducted through user interviews, confirmed that the personalized feedback was perceived as more relevant and valuable than the default version. Participants highlighted that the ability to configure feedback preferences provided a sense of ownership and improved their engagement with the system. These findings demonstrate that personalization can enhance the quality and usability of automated feedback in large-scale learning environments, paving the way for more adaptive and student-centered educational technologies.

#pagebreak()
== Future Work
After addressing the immediate next steps outlined in @open-goals, several directions could further extend and improve the system. These directions range from refining the personalization mechanisms for the preference configuration to broadening the use of learner profiles across the LMS.

=== Pairwise Preference Elicitation for Feedback Tuning
The current implementation models feedback preferences using predefined dimensions with fixed prompt tokens. Students select a value for a dimension, and a static prompt expressing this dimension is used to generate the feedback. While this approach is practical for an initial deployment, it does not adapt to individual variations in how students perceive and value feedback styles, since it assigns students to predefined categories. Future work could explore pairwise preference elicitation methods, such as Bayesian optimization or probabilistic models, to dynamically infer each student's preferences based on their choices. By allowing students to iteratively compare different feedback styles—similar to recommendation systems—these methods could fine-tune the level of detail, tone, or structure of the feedback in a data-driven way. This adaptive approach would create a more personalized feedback experience.

=== Integrating Lecture Material into the Feedback Generation
Another promising extension is incorporating lecture and exercise materials into the feedback generation process. A retrieval-augmented generation (RAG) pipeline could retrieve relevant material like lecture slides and surface them in the feedback response. This integration would enable the system to refer students to the right material to improve their answer and directly point them to authoritative resources to close their knowledge gaps. For example, feedback could include actionable references such as "Revisit Section 3 of Lecture 5" or "Review the example in Exercise 2," bridging the gap between automated assessment and targeted remediation. Implementing such a system would also align with feedback clarity and actionability quality attributes.

=== Expanding the Use of Learner Profiles
The learner profile developed in this thesis is a versatile artifact that could support personalization well beyond feedback generation. For instance, the profile could be leveraged to generate personalized study plans, exercise recommendations, or exam preparation materials that align with a student's competency status and progress trajectory. This expansion would amplify the value of the profiling framework and promote a more adaptive learning environment within the LMS. Over time, such applications could create a cohesive ecosystem where every interaction—from practice exercises to assessments—is informed by the student's evolving profile, fostering a more individualized and efficient learning journey.