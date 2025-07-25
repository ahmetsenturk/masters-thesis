#import "/utils/todo.typ": TODO

#let fr(id, title, body) = table(columns: (15mm, 1fr), stroke: none, [#id], [*#title*: #body])


= Requirements
The requirements chapter follows the Requirements Analysis Document Template proposed by Brügge and Dutoit, which emphasizes a clear separation between the application domain (problem space) and the solution domain (technology choices) @bruegge2009. All artefacts in this chapter therefore describe what the system should achieve without assuming how it will be implemented, an approach that supports traceability from stakeholder needs to design decisions.

== Overview
The proposed system extends Artemis and its Athena feedback generator with a personalised-feedback layer that employs learner profiles to tailor feedback to individual students. The scope includes mechanisms for collecting and maintaining profiles, incorporating those profiles into automated feedback generation, and presenting the resulting feedback within Artemis. Success will be measured by (i) the correctness and completeness of extracted learner attributes, (ii) the pedagogical quality of the personalised feedback, and (iii) the seamless integration into existing Artemis workflows—all assessed independently of any specific LLM vendor or database technology, in line with the abstraction principles of Brügge and Dutoit @bruegge2009.

== Existing System
Artemis (version 8.0.0) currently offers students the option to request automatically generated feedback for programming, modelling, and text exercises, provided the lecturer enables this feature. Each student may submit up to ten feedback requests per exercise. When a request is triggered, Artemis forwards the submission together with exercise metadata—problem statement, example solution, rubric, and maximum points—to Athena. Athena selects an exercise-specific feedback module that relies on an LLM prompt template and chain-of-thought reasoning to produce formative feedback aligned with the rubric. The generated feedback is returned to Artemis, which displays it in two categories: referenced feedback (anchored to specific lines or elements of the submission) and unreferenced feedback.

Although this pipeline delivers timely feedback, it treats each submission in isolation and disregards longitudinal evidence such as prior attempts, engagement metrics, or expressed preferences. Consequently, the generated feedback is uniform across students with diverse backgrounds and learning trajectories.

== Proposed System
The envisioned extension introduces learner profiles as a first-class artefact. A learner profile is a structured representation of a student's competencies, progress, and feedback preferences. Profiles will be populated automatically from submission traces, engagement data, and explicit preference settings, and will be updated incrementally after each new interaction. During feedback generation, Athena will retrieve the relevant profile and supply it—together with the current submission and grading rubric—to an LLM-driven pipeline. The LLM will be prompted to produce feedback that explicitly references profile attributes, thereby aligning the feedback with the student's needs and preferred style.

=== Functional Requirements

#fr("FR 1", "Configure Feedback Preferences", "The system shall allow students to specify their preferred feedback granularity and tone through an intuitive interface.")

#fr("FR 2", "Extract Competencies", "The system shall identify the competencies required for each exercise by analysing the provided metadata.")

#fr("FR 3", "Assess Competency Status", "For every new submission, the system shall classify the student's mastery of each required competency using a recognised taxonomy such as Bloom's Taxonomy.")

#fr("FR 4", "Track Submission History", "The system shall maintain a history of submissions and feedback to support longitudinal reasoning.")

#fr("FR 5", "Utilise Engagement Data", "The system shall incorporate engagement signals (e.g., forum posts, chat logs) into the learner profile.")

#fr("FR 6", "Generate Learner Profiles", "The system shall automatically construct learner profiles from the collected data sources.")

#fr("FR 7", "Update Learner Profiles", "The system shall refine learner profiles after each submission and feedback cycle.")

#fr("FR 8", "Generate Personalised Feedback", "Given a submission and its learner profile, the system shall generate feedback that reflects both the student's competencies and their stated preferences.")

#fr("FR 9", "Feedback Format", "Generated feedback shall include concrete suggestions and next-step guidance.")


=== Quality Attributes
#fr("QA 1", "Feedback Interface", "The feedback interface shall clearly indicate performance gaps, using Artemis design conventions for colour and layout.")

#fr("QA 2", "Preference Interface", "The preference-setting workflow shall be easy to understand and complete.")

#fr("QA 3", "Integration", "All data exchanges shall conform to public Artemis APIs and data formats.")

#fr("QA 4", "Documentation", "User and developer documentation shall accompany the system.")

#fr("QA 5", "Fault Tolerance", "In case personalised feedback generation fails, the system shall degrade gracefully, allowing manual assessment to continue.")

#fr("QA 6", "Feedback Quality", "Personalised feedback shall be at least as accurate and actionable as existing generic feedback.")

#fr("QA 7", "Latency", "Feedback generation shall complete within 15 seconds per submission under normal load.")

#fr("QA 8", "Scalability", "The system shall sustain increased load without significant performance degradation.")

=== Constraints

#fr("C 1", "Artemis Integration", "The solution shall integrate with Artemis via its official API.")

#fr("C 2", "Scalability", "The architecture shall handle large classes and complex exercises.")

#fr("C 3", "Fault Tolerance", "Graceful degradation shall be provided when feedback generation fails.")

#fr("C 4", "Documentation", "Comprehensive technical and user documentation shall be delivered.")

== System Models
#TODO[
  This section includes important system models for the requirements.
]
This section contains the system models for the requirements. First, the scenarios are presented for the proposed system, followed by the use case models to detail the scenarios. The dynamic model and the analysis object model give a more detail regarding the inner dynamics of the proposed system and how the objects are represented. Finally, the user interface mockups for the proposed system are presented. The diagrams in this section adhere to Unified Modeling Language (UML) to set a standard to model demonstration.

=== Scenarios
A scenario describes a sequence of interactions from the system's user's viewpoint, it is written in an informal tone and helps to understand the system from a user's perspective @bruegge2009. With the visionary scenarios, we aim to show the future potential of this domain, while the demo scenarios are more concrete and show the achievable potential of the proposed system. 

\ 
#text(weight: "bold")[Demo Scenarios] \
#text(weight: "bold")[Preference Configuration and Iterative Adaptation.] Anna, a first-semester student, often gets distracted reading long paragraphs. Before starting to solve the rate-limiter exercise, she visits the newly deployed Feedback Preferences page, where an interactive wizard previews different styles. She selects brief detail, a formal tone, and opts out of illustrative anecdotes. The system stores these choices in her learner profile.
Anna submits her initial answer and requests AI-generated feedback. She sees that the generated feedback is a direct sentence—“Definition lacks discussion of sliding-window algorithms”—followed by two numbered next steps: (1) compare token bucket with sliding-window log; (2) address trade-offs between memory and accuracy. The style matches her brief-formal preference.
Curious how richer guidance might look, Anna reopens the preference pane, sets the detail level to “elaborate,” and switches the tone to friendly. She revises her answer and requests feedback again. This time, the feedback begins with an encouraging summary of her improvements, explains why sliding-window algorithms handle burst traffic differently, and provides a real-world example from a CDN. A final paragraph suggests adding further metrics for throughput under peak load.
Anna finds the expanded explanation helpful, as she feels like this can be her personal exercise coach, so she decides to keep the elaborate-supportive setting for future exercises. The scenario demonstrates that students can dynamically modulate feedback depth and tone to fit their learning stage, reducing cognitive overload when skimming and offering depth during consolidation. 

\
#text(weight: "bold")[History-Aware Feedback Leveraging Forum Activity.] Ben, a master's student who has already taken a few courses in networking, submits his first response to the same rate-limiter exercise. His answer covers token and leaky buckets but omits fixed-window counters. The feedback he receives acknowledges his clear abuse-prevention rationale, flags the missing strategy, and recommends covering distributed clock-sync issues. The closing section lists a sequential plan: research fixed-window counters, then discuss consistency.
Ben remains unsure why fixed-window counters can outperform token buckets. He posts a short question in the course forum: “Why opt for fixed window instead of token bucket despite the risk of bursts?” The forum post is automatically incorporated into his learner profile.
After reading peer replies, Ben edits his answer and submits it again. The second-round feedback opens with “Good job integrating fixed-window counters” and skips basic definitions, focusing instead on the nuance of time-skew mitigation. It explicitly references his forum question—“As you asked about burst risk...”—and elaborates on burst absorption under varying window sizes. Because Ben followed the earlier plan quickly, the system adds a Rapid Improver badge and logs his trajectory for instructor analytics.

=== Use Case Model
#TODO[
  This subsection should contain a UML Use Case Diagram including roles and their use cases. You can use colors to indicate priorities. Think about splitting the diagram into multiple ones if you have more than 10 use cases. *Important:* Make sure to describe the most important use cases using the use case table template (./tex/use-case-table.tex). Also describe the rationale of the use case model, i.e. why you modeled it like you show it in the diagram.
]
#figure(caption: "Use Case Model")[
  #image("../figures/use_case_model.svg", width: 100%)
]


=== Analysis Object Model
#TODO[
  This subsection should contain a UML Class Diagram showing the most important objects, attributes, methods and relations of your application domain including taxonomies using specification inheritance (see @bruegge2004object). Do not insert objects, attributes or methods of the solution domain. *Important:* Make sure to describe the analysis object model thoroughly in the text so that readers are able to understand the diagram. Also write about the rationale how and why you modeled the concepts like this.

]
#figure(caption: "Analysis Object Model")[
  #image("../figures/aom.svg", width: 100%)
]

=== Dynamic Model
#TODO[
  This subsection should contain dynamic UML diagrams. These can be a UML state diagrams, UML communication diagrams or UML activity diagrams.*Important:* Make sure to describe the diagram and its rationale in the text. *Do not use UML sequence diagrams.*
]
#figure(caption: "Dynamic Model 1")[
  #image("../figures/dynamic_model_1.svg", width: 100%)
]

#figure(caption: "Dynamic Model 2")[
  #image("../figures/dynamic_model_2.svg", width: 100%)
]


 
=== User Interface
#TODO[
  Show mockups of the user interface of the software you develop and their connections / transitions. You can also create a storyboard. *Important:* Describe the mockups and their rationale in the text.
]
#figure(caption: "Feedback Preferences Setup Mockup")[
  #image("../figures/mockup_1.png", width: 100%)
]

#figure(caption: "Feedback Component Mockup")[
  #image("../figures/mockup_2.png", width: 100%)
]

