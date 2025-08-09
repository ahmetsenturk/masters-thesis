#import "/utils/todo.typ": TODO
#import "requirements.typ": fr

#pagebreak()
= User Interviews
#TODO[
  If you did an evaluation / case study, describe it here.
]
Given that users are key to personalization, it was essential to validate our developed system. This assessment seeks to measure and comprehend the system's efficacy and accessibility.

== Design 
#TODO[
  Describe the design / methodology of the evaluation and why you did it like that. e.g. what kind of evaluation have you done (e.g. questionnaire, personal interviews, simulation, quantitative analysis of metrics), what kind of participants, what kind of questions, what was the procedure?
]

=== Participants
Seven volunteer students at TUM were enlisted to perform user interviews. Previous Artemis experience varied from "none" to "weekly programming practice". All sessions were held in a quiet place using the participant's own laptop to replicate normal working conditions.
#figure(caption: "Interview Participants")[
#table(
  columns: 4,
  table.header(
    [Student],
    [Program],
    [Year],
    [Artemis Familiarity],
  ),
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
)
]

=== Procedure
Each session was directed by a seven-step script. Participants were encouraged to verbalize their thoughts during the interaction.
Subsequent to the interactive session, a six-item questionnaire (comprising four 5-point Likert scale items and three open-ended questions) was administered verbally. Sessions ended with a short debriefing and agreement for the use of anonymized quotations.
#figure(caption: "Detailed Interview Steps")[
#table(
  columns: 2,
  table.header(
    [Step],
    [Description],
  ),
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
)
]

#figure(caption: "Interview Questions")[
#table(
  columns: 3,
  table.header(
    [Number],
    [Question],
    [Type],
  ),
  [1],
  [When you heard you'd be able to set your feedback preferences, what kind of customization did you expect?],
  [Free text],
  [2],
  [Do you feel the three preference dimensions covered your expectations?],
  [Likert scale],
  [3],
  [If something was missing or unclear, what would you have liked to adjust instead?],
  [Free text],
  [4],
  [Was it easy to understand what each setting (attribute) does?],
  [Likert scale],
  [5],
  [Was the feedback aligned with the preferences you selected?],
  [Likert scale],
  [6],
  [Overall, how satisfied were you with the personalized feedback you received?],
  [Likert scale],
  [7],
  [Extra comments about the preferences system?],
  [Free text],
)
]

== Objectives
#TODO[
  Derive concrete objectives / hypotheses for this evaluation from the general ones in the introduction.
]
The interview study set out to test a single overarching claim:

#text("Does enabling students to customise feedback via preference settings result in feedback that is perceived as higher quality, more aligned with their expectations, and more personally useful?", style: "italic") 

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
=== Quantitative Results
Table 1 summarises the Likert-scale findings. Students rated alignment with their chosen preferences and overall satisfaction at a solid M = 4.0, confirming that the personalised version was perceived as both relevant and useful. Coverage of the three preference dimensions was judged adequate (M = 3.7), but ease of understanding the settings lagged behind (M = 3.4). Log data reinforce this impression: the time to complete the preference setup was observed to be higher than expected. Taken together, the figures indicate high satisfaction with the outcome of personalisation but reveal friction in the configuration process.

#figure(caption: "Likert-scale Results")[
#table(
  columns: 3,
  table.header(
    [Question],
    [Mean],
    [Standard Deviation],
  ),
  [2],
  [3.7],
  [XXX],
  [4],
  [3.4],
  [XXX],
  [5],
  [4.0],
  [XXX],
  [6],
  [4.0],
  [XXX],
  
)
]

=== Qualitative Results
Qualitative results discuss the results of the open-ended questions. Considering the small number of interviewees, the answers manually analysed. The results complement the quantitative results an yield themes that align with the numeric trends:
\
#text("Adjustability was beyond expectations.", weight: "bold") Five of seven participants mentioned that they were expecting to setup less than what's currently provided—e.g., #text("“...wasn't expecting much control”", style: "italic") (P5).
\
#text("Terminology confusion.", weight: "bold") Five of seven participants struggled with at least one label—most often alternative—e.g., #text("“Alternative wasn't too clear, I would need to try it a bit to understand what it means.”", style: "italic") (P2), #text("“The dimensions were unclear by name, still not sure what some of them actually means, and how different they are in action”", style: "italic") (P7).

The qualitative insights clarify low usability scores: students appreciated the concept of customisation but found the current terminology unintuitive. Their positive remarks regarding alignment and utility validate the elevated satisfaction scores, reinforcing the argument for preference-driven personalization after the user interface is optimised.

#TODO[
  == Findings
  Interpret the results and conclude interesting findings
]

== Discussion
#TODO[
  Discuss the findings in more detail and also review possible disadvantages that you found
]
Observing that the students mostly satisfied with the personalised feedback, we think that the system is a success. However, we need to improve the configuration process to make it more intuitive and user-friendly.

Interpreting the results in more detail, we thought that the configuration process needed a rework. Easier terminology and a more intuitive interface would help students to configure the preferences more easily.

== Limitations
#TODO[
  Describe limitations and threats to validity of your evaluation, e.g. reliability, generalizability, selection bias, researcher bias
]