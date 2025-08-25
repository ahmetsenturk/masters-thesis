#import "/utils/todo.typ": TODO
#import "requirements.typ": fr

#set heading(numbering: "1.1")

// Reusable “scientific” table style
#let sci-table-3col = table.with(
  columns: (auto, 1fr, auto),   // wide middle column
  inset: (x: 8pt, y: 7pt),      // padding in cells → space around rules
  align: left,
  stroke: none                  // no cell borders
)
#let sci-table-2col = table.with(
  columns: (auto, 1fr),   // wide middle column
  inset: (x: 8pt, y: 7pt),      // padding in cells → space around rules
  align: left,
  stroke: none                  // no cell borders
)
#let sci-table-4col = table.with(
  columns: (auto, 5fr, auto, auto),   // wide middle column
  inset: (x: 8pt, y: 7pt),      // padding in cells → space around rules
  align: left,
  stroke: none                  // no cell borders
)
#let toprule    = table.hline(stroke: 0.8pt)
#let midrule    = table.hline(stroke: 0.6pt)
#let bottomrule = table.hline(stroke: 0.8pt)

// If you want a touch more space *below the header rule only*,
// wrap header cells with a bit of extra bottom inset:
#let head = (
  box(inset: (bottom: 2pt))[*Number*],
  box(inset: (bottom: 2pt))[*Question*],
  box(inset: (bottom: 2pt))[*Type*],
)

#let outlined-figure(
  path,
  caption: none,
  width: auto,
  stroke: 0.5pt + gray,
  inset: 6pt,
  radius: 0pt
) = figure(
  caption: caption
)[
  #box(stroke: stroke, inset: inset, radius: radius)[
    #image(path, width: width)
  ]
]

// --- Chapter numbering like "Figure 5.4" ---


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
= User Interviews <user_interviews>

Since users are central to personalization and prioritized end-user criteria in @design-goals, we evaluated the system against usability, clarity, and perceived usefulness. The goal was to understand whether preference-driven feedback feels more helpful and aligned than the default, and how intuitive the configuration process is.

== Objectives
The interview study set out to test a single overarching claim:

#text("Does enabling students to customize feedback via preference settings result in feedback that is perceived as higher quality, more aligned with their expectations, and more personally useful?", style: "italic") 

To make that broad claim measurable, we decomposed it into five concrete objectives that map directly onto our questionnaire items and logging metrics:

#fr("O 1", "Preference Dimension Alignment", "Do students perceive the three preference dimensions (follow-up vs summary, alternative vs standard, brief vs detailed) as comprehensive and aligned with their expectations?")
#fr("O 2", "Perceived Quality of the Feedback", "Do students regard the personalized feedback as higher-quality than the default?")
#fr("O 3", "Perceived Personalization of the Feedback", "Do students perceive the personalized feedback as more aligned with their preferences?")
#fr("O 4", "Perceived Alignment of the Feedback with Preferences", "Do students perceive the personalized feedback as aligned with the preferences they set?")
#fr("O 5", "UI Usability", "Can students understand and configure the preference sliders quickly and confidently?")

== Design 
This subsection describes the participant body, the materials, questions, and the steps of the user study.


We enlisted seven volunteer students at TUM to perform user interviews. Their previous Artemis experience ranged from "none" to "weekly programming practice." We held all sessions quietly on the participants' laptops to replicate normal working conditions.

#let td(body) = table.cell(align: center + horizon)[#body]
#figure(
  sci-table-4col(
    toprule,
    table.header(td[*Student*],
    td[*Program*],
    td[*Year*],
    td[*Artemis Familiarity*]),
    midrule,

    td[S1],
  td[M.Sc. Computer Science], td[2], td[Low],
  td[S2],
  td[M.Sc. Computer Science], td[3], td[Medium],
  td[S3],
  td[M.Sc. Management & Technology], td[1], td[Low],
  td[S4],
  td[M.Sc. Information Systems], td[2], td[High],
  td[S5],
  td[M.Sc. Management & Technology], td[2], td[Low],
  td[S6],
  td[M.Sc. Computer Science], td[2], td[Medium],
  td[S7],
  td[M.Sc. Computer Science], td[3], td[High],

    bottomrule,
 ),
  caption: [Interview participants' details.],
  kind: table,                   // so it appears under "List of Tables"
) <interview-participants>
\

Participants interacted with the feedback preferences setup integrated into the exercise workflow. The target task was a short, text-based machine learning question chosen to be conceptually accessible to all participants. Each session followed a seven-step script (see @interview-steps). Participants were encouraged to think aloud throughout the interaction.

#figure(
  sci-table-2col(
    toprule,
    table.header(td[*Step*],
    td[*Description*]),
    midrule,

    td[1],
  td[Introduce the student to the evaluation study and what they will do],
  td[2],
  td[Show the exercise. Let them read (and optionally solve) it.],
  td[3],
  td[They submit their solution and get the default AI feedback (without preferences)],
  td[4],
  td[Explain the preference system, and walk through each dimension],
  td[5],
  td[Let them configure their personalized learner profile],
  td[6],
  td[They submit again and receive personalized feedback],
  td[7],
  td[Conduct a short interview to gather insights],

    bottomrule,
 ),
  caption: [Interview steps with explanation about the activities in each step.],
  kind: table,                   // so it appears under "List of Tables"
) <interview-steps>
\
Following the interaction, a seven-item questionnaire was administered (four Likert items, three open-ended questions; see @interview-questions). 


#figure(
  sci-table-3col(
    toprule,
    table.header(td[*Number*],
    td[*Question*],
    td[*Type*],),
    midrule,

    td[Q 1],
    td[When you heard you'd be able to set your feedback preferences, what kind of customization did you expect?],
    td[Free text],

    td[Q 2],
    td[Do you feel the three preference dimensions covered your expectations?],
    td[Likert scale],

    td[Q 3],
    td[If something was missing or unclear, what would you have liked to adjust instead?],
    td[Free text],

    td[Q 4],
    td[Was it easy to understand what each setting (attribute) does?],
    td[Likert scale],

    td[Q 5],
    td[Was the feedback aligned with the preferences you selected?],
    td[Likert scale],

    td[Q 6],
    td[Overall, how satisfied were you with the personalized feedback you received?],
    td[Likert scale],

    td[Q 7],
    td[Extra comments about the preferences system?],
    td[Free text],

    bottomrule,
 ),
  caption: [User study questionnaire.],
  kind: table,                   // so it appears under "List of Tables"
) <interview-questions>
\
Quantitative measures included perceived coverage of dimensions, ease of understanding, alignment with selected preferences, and overall satisfaction. Log data provided configuration time and interaction effort.

== Results

We will present the results of the user study in two subsections: (i) quantitative results, and (ii) qualitative results.

=== Quantitative Results
@evaluation_graph summarises the Likert-scale findings. Students rated alignment with their chosen preferences and overall satisfaction at a solid M = 4.0,  confirming that they perceived the personalized version as relevant and valuable. Coverage of the three preference dimensions was judged adequate (M = 3.7), but ease of understanding the settings lagged (M = 3.4). 


#figure(caption: [User study results of the Likert scale questions, based on the answers of the participants (n = 7). Blue line represents the average rating of the participants (M for mean), shaded area represents the standard deviation.], )[
  #image("../figures/likert_graph.png", width: 100%)
] <evaluation_graph>

\
Log data reinforce this impression: the time to complete the preference setup was higher than expected (expected 1 minute, average > 4 minutes). 

=== Qualitative Results
Qualitative results discuss the results of the open-ended questions. Considering the small number of interviewees, we analyzed the answers manually. The results complement the quantitative results and yield themes that align with the numeric trends:
\
#text("Adjustability was beyond expectations.", weight: "bold") Five of seven participants mentioned that they were expecting to set up less than what is currently provided—e.g., #text("... was not expecting much control", style: "italic") (P5).
\
#text("Terminology confusion.", weight: "bold") Five of seven participants struggled with at least one label—most often alternative—e.g., #text("Alternative was not too clear, I would need to try it a bit to understand what it means.", style: "italic") (P2), #text("The dimensions were unclear by name, still not sure what some of them actually mean, and how different they are in action", style: "italic") (P7).



== Discussion

The evaluation demonstrates that students perceived the personalized feedback as high-quality and well-aligned with their expectations, validating the core objectives of O2 (perceived quality) and O3 (perceived personalization). Overall satisfaction and alignment ratings averaged M = 4.0 (Q5 and Q6 in @evaluation_graph), confirming the value of preference-driven personalization. This supports the overarching claim that allowing students to customize feedback results in more relevant and actionable outputs.

At the same time, the study highlighted friction in the configuration process. While students appreciated the concept of customization, they found the terminology unintuitive and the interface less intuitive than expected. This is reflected in the M = 3.7 score for preference coverage (Q2) and the M = 3.4 score for ease of understanding (Q4). Qualitative results backed these findings, with participants expressing confusion and uncertainty about specific dimensions.

These insights indicate that the personalization concept is sound, but the delivery mechanism requires refinement. To meet QA 2 (preference interface usability) and support a more intuitive and easier user experience, the configuration process needs to be clearer, faster, and more intuitive without reducing the sense of control that students valued. The following section builds on these findings, describing the design iterations introduced to address these pain points and enhance the user experience.


== Design Iterations Informed by the Study

As discussed in the previous section, the initial prototype used in the study (see @preference-v1) was not sufficiently intuitive for the students. In response, we introduced a more precise entry point with a dedicated setup button (see @preference-v2_1) that opens an onboarding modal.
 

#outlined-figure(
  "../figures/preference-component/preference_v1.png",
  caption: [First version of the feedback preferences setup with segmented button components.],
  width: 100%,
  stroke: 0.5pt + black,
  radius: 3pt
) <preference-v1>

#outlined-figure(
  "../figures/preference-component/preference_v2_1.png",
  caption: [Second version of the feedback preferences setup - initial screen with a setup button.],
  width: 100%,
  stroke: 0.5pt + black,
  radius: 3pt
) <preference-v2_1>

The onboarding wizard is the most significant change we introduced compared to the first version, which works as a "guided tour" for students to understand each dimension of the preference configuration (see @preference-v2_2). The guided onboarding wizard walks students through each preference dimension step-by-step, providing examples for every option. This aims to reduce the cognitive load of first-time configuration and supports users in making informed choices, which aligns with FR 1 and QA 2.

#outlined-figure(
  "../figures/preference-component/preference_v2_2.png",
  caption: [Second version of the feedback preferences setup - onboarding modal with a step-by-step wizard, where students can see examples of the different feedback styles on each step.],
  width: 100%,
  stroke: 0.5pt + black,
  radius: 3pt
) <preference-v2_2>
\
After setting up their preferences, students can see the final screen with the selected preferences (see @preference-v2_4), which summarizes their preferences, reusing the same design as the first version.

We also simplified terminology and labels to use language that more closely matched participants' expectations. Feedback revealed that terms like _alternative_ and _summary_ were confusing and did not clearly convey their impact on the feedback output. This change made the configuration process more intuitive and reduced the risk of misconfiguration due to misunderstanding.

Finally, we streamlined the number of preference dimensions from three to two, focusing on _detail_ and _tone_. This change also aims to reduce the complexity of the configuration process and make it more intuitive for the students. 

#outlined-figure(
  "../figures/preference-component/preference_v2_4.png",
  caption: [Second version of the feedback preferences setup - final screen with the selected preferences.],
  width: 100%,
  stroke: 0.5pt + black,
  radius: 3pt
) <preference-v2_4>





== Limitations
Generalizability is limited by the small, homogeneous sample drawn from a single institution and restricted to master's students. The task domain focused on a single, text-only machine-learning exercise; outcomes may differ for code-centric, mathematical, or multimodal tasks. Construct validity may be affected by reliance on self-reported Likert items and the absence of blinded comparisons. Procedure effects are possible due to the think-aloud protocol, researcher presence, and learning effects between default and personalized submissions.