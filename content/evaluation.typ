#import "/utils/todo.typ": TODO
#import "requirements.typ": fr

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
#TODO[
  If you did an evaluation / case study, describe it here.
]
Given that users are central to personalization—and that we prioritized end-user criteria in @design-goals—we evaluated the system against usability, clarity, and perceived usefulness. The goal was to understand whether preference-driven feedback feels more helpful and aligned than the default, and how intuitive the configuration process is.

== Design 
#TODO[
  We have conducted a user study with university students to evaluate the usability and accessibility of the feedback preferences setup - which allows students to configure their feedback preferences. The participants were introduced to the setup and were asked to use the newly developed system. Finally, we have conducted a short interview to gather insights about the participants' experience with the system.
]
This subsection describes the participant body, the materials, questions, and the steps of the user study.

=== Participants
Seven volunteer students at TUM were enlisted to perform user interviews. Previous Artemis experience varied from "none" to "weekly programming practice". All sessions were held in a quiet place using the participant's own laptop to replicate normal working conditions.


#figure(
  sci-table-4col(
    toprule,
    table.header([*Student*],
    [*Program*],
    [*Year*],
    [*Artemis Familiarity*]),
    midrule,

    [S1],
  [M.Sc. Computer Science], [2], [Low],
  [S2],
  [M.Sc. Computer Science], [3], [Medium],
  [S3],
  [M.Sc. Management & Technology], [1], [Low],
  [S4],
  [M.Sc. Information Systems], [2], [High],
  [S5],
  [M.Sc. Management & Technology], [2], [Low],
  [S6],
  [M.Sc. Computer Science], [2], [Medium],
  [S7],
  [M.Sc. Computer Science], [3], [High],

    bottomrule,
  ),
  caption: [Interview Participants.],
  kind: table,                   // so it appears under “List of Tables”
) <interview-participants>

=== Materials
Participants interacted with the feedback preferences setup integrated into the exercise workflow. The target task was a short, text-based machine learning question chosen to be conceptually accessible to all participants. 

=== Procedure
Each session followed a seven-step script (see @interview-steps). Participants were encouraged to think aloud throughout the interaction.

#figure(
  sci-table-2col(
    toprule,
    table.header([*Step*],
    [*Description*]),
    midrule,

    [1],
  [Introduce the student to the evaluation study and what they will do],
  [2],
  [Show the exercise. Let them read (and optionally solve) it.],
  [3],
  [They submit their solution and get the default AI feedback (without preferences)],
  [4],
  [Explain the preference system, and walk through each dimension],
  [5],
  [Let them configure their personalized learner profile],
  [6],
  [They submit again and receive personalized feedback],
  [7],
  [Conduct a short interview to gather insights],

    bottomrule,
  ),
  caption: [Interview questionnaire used in the user study.],
  kind: table,                   // so it appears under “List of Tables”
) <interview-steps>

=== Instruments and Measures
Following the interaction, a seven-item questionnaire was administered (four Likert items, three open-ended questions; see @interview-questions). Quantitative measures included perceived coverage of dimensions, ease of understanding, alignment with selected preferences, and overall satisfaction. Log data provided configuration time and interaction effort.


#figure(
  sci-table-3col(
    toprule,
    table.header([*Number*],
    [*Question*],
    [*Type*],),
    midrule,

    [Q 1],
    [When you heard you'd be able to set your feedback preferences, what kind of customization did you expect?],
    [Free text],

    [Q 2],
    [Do you feel the three preference dimensions covered your expectations?],
    [Likert scale],

    [Q 3],
    [If something was missing or unclear, what would you have liked to adjust instead?],
    [Free text],

    [Q 4],
    [Was it easy to understand what each setting (attribute) does?],
    [Likert scale],

    [Q 5],
    [Was the feedback aligned with the preferences you selected?],
    [Likert scale],

    [Q 6],
    [Overall, how satisfied were you with the personalized feedback you received?],
    [Likert scale],

    [Q 7],
    [Extra comments about the preferences system?],
    [Free text],

    bottomrule,
  ),
  caption: [Interview questionnaire used in the user study.],
  kind: table,                   // so it appears under “List of Tables”
) <interview-questions>

#pagebreak()

== Objectives
#TODO[
  Derive concrete objectives / hypotheses for this evaluation from the general ones in the introduction.
]
The interview study set out to test a single overarching claim:

#text("Does enabling students to customize feedback via preference settings result in feedback that is perceived as higher quality, more aligned with their expectations, and more personally useful?", style: "italic") 

To make that broad claim measurable, we decomposed it into four concrete objectives that map directly onto our questionnaire items and logging metrics:

#fr("O 1", "Preference Dimension Alignment", "Do students perceive the three preference dimensions (follow-up vs summary, alternative vs standard, brief vs detailed) as comprehensive and aligned with their expectations?")
#fr("O 2", "Perceived Quality of the Feedback", "Do students regard the personalised feedback as higher-quality than the default?")
#fr("O 3", "Perceived Personalisation of the Feedback", "Do students perceive the personalised feedback as more aligned with their preferences?")
#fr("O 4", "Perceived Alignment of the Feedback with Preferences", "Do students perceive the personalised feedback as aligned with the preferences they set?")
#fr("O 5", "UI Usability", "Can students understand and configure the preference sliders quickly and confidently?")

== Results & Findings
#TODO[
  Summarize the most interesting results of your evaluation (without interpretation). Additional results can be put into the appendix.
]
We will present the results of the user study in two subsections: (i) quantitative results, and (ii) qualitative results.

=== Quantitative Results
@evaluation_graph summarises the Likert-scale findings. Students rated alignment with their chosen preferences and overall satisfaction at a solid M = 4.0, confirming that the personalised version was perceived as both relevant and useful. Coverage of the three preference dimensions was judged adequate (M = 3.7), but ease of understanding the settings lagged behind (M = 3.4). 


#figure(caption: "Likert-scale Results.")[
  #image("../figures/likert_graph.png", width: 100%)
] <evaluation_graph>


Log data reinforce this impression: the time to complete the preference setup was observed to be higher than expected (expexted 1 minute, average > 4 minutes). 

=== Qualitative Results
Qualitative results discuss the results of the open-ended questions. Considering the small number of interviewees, the answers manually analyzed. The results complement the quantitative results and yield themes that align with the numeric trends:
\
#text("Adjustability was beyond expectations.", weight: "bold") Five of seven participants mentioned that they were expecting to setup less than what's currently provided—e.g., #text("“...wasn't expecting much control”", style: "italic") (P5).
\
#text("Terminology confusion.", weight: "bold") Five of seven participants struggled with at least one label—most often alternative—e.g., #text("“Alternative wasn't too clear, I would need to try it a bit to understand what it means.”", style: "italic") (P2), #text("“The dimensions were unclear by name, still not sure what some of them actually mean, and how different they are in action”", style: "italic") (P7).


== Findings

Taken together, qualitative and quantitative results indicate high satisfaction with the outcome of personalisation but reveal friction in the configuration process. While quantitative results show that ease of understanding the settings lagged behind (M = 3.4), the qualitative insights clarify low usability score: students appreciated the concept of customisation but found the current terminology unintuitive. Their positive remarks regarding alignment and utility validate the elevated satisfaction scores, reinforcing the argument for preference-driven personalization after the user interface is optimised.





#TODO[
  We might reference the pair-wise preference elicitation techniques here.
]

== Design Iterations Informed by Findings

The initial mockup used in the study was not sufficiently intuitive, and terminology contributed to misunderstandings. The first version is shown in @preference-v1.

#outlined-figure(
  "../figures/preference-component/preference_v1.png",
  caption: [First version of the feedback preferences setup mockup. It provides the segmented button components to allow students to select the feedback style on three dimensions (i) follow-up vs summary, (ii) alternative vs standard, and (iii) brief vs detailed).],
  width: 100%,
  stroke: 0.5pt + black,
  radius: 3pt
) <preference-v1>

In response, we introduced a clearer entry point with a dedicated setup button (see @preference-v2_1) that opens an onboarding modal.

#TODO[
  We might reference the pair-wise preference elicitation techniques here.
]

#outlined-figure(
  "../figures/preference-component/preference_v2_1.png",
  caption: [Initial screen of the second version of the feedback preferences setup mockup. Students welcomed with a setup button.],
  width: 100%,
  stroke: 0.5pt + black,
  radius: 3pt
) <preference-v2_1>

The onboarding wizard is the biggest change we introduced comparing to the first version, which works a "guided tour" for students to understand the each dimension of the preference configuration (see @preference-v2_2). 

#outlined-figure(
  "../figures/preference-component/preference_v2_2.png",
  caption: [Onboarding modal of the second version of the feedback preferences setup mockup. Students are guided through the setup process with a step-by-step wizard, where they can see examples of the different feedback styles on each step.],
  width: 100%,
  stroke: 0.5pt + black,
  radius: 3pt
) <preference-v2_2>
After setting up their preferences, students are shown the final screen with the selected preferences (see @preference-v2_4) which is a summary of the preferences they have set reusing the same design with the first version.

We also iterated over the feedback preferences dimensions to make them more intuitive. Even though we introduced the onboarding wizard, some dimensions were still not clear with examples. Therefore, we have reduced the number of dimensions from three, by removing follow-up vs summary and alternative vs standard and adding a new dimension on feedback style, to two and made them more intuitive.

#outlined-figure(
  "../figures/preference-component/preference_v2_4.png",
  caption: [Final screen of the second version of the feedback preferences setup mockup. Students can see the selected preferences and update them. The preference dimensions are also updated to make them more intuitive.],
  width: 100%,
  stroke: 0.5pt + black,
  radius: 3pt
) <preference-v2_4>


== Discussion

The results indicate that personalized feedback is perceived as both aligned with user preferences and of high quality, whereas first-time configuration imposes a noticeable cognitive cost. The design changes target precisely this pain point. Clearer labels, example-based onboarding, and progressive disclosure are expected to reduce configuration time and increase comprehension without reducing perceived control.


== Limitations
Generalizability is limited by the small, homogeneous sample drawn from a single institution and restricted to master's students. The task domain focused on a single, text-only machine-learning exercise; outcomes may differ for code-centric, mathematical, or multimodal tasks. Construct validity may be affected by reliance on self-reported Likert items and by the absence of blinded comparisons. Procedure effects are possible due to the think-aloud protocol and researcher presence, as well as learning effects between default and personalized submissions.