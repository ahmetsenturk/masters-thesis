#import "/utils/todo.typ": TODO

#let fr(id, title, body) = table(columns: (15mm, 1fr), stroke: none, [#id], [*#title*: #body])

#pagebreak()
= Requirements
The requirements chapter follows the Requirements Analysis Document Template proposed by Brügge and Dutoit, which emphasizes a clear separation between the application domain (problem space) and the solution domain (technology choices and implementation details) @bruegge2009. All artefacts in this chapter therefore describe what the system should achieve without assuming how it will be implemented, an approach that supports traceability from stakeholder needs to design decisions.

== Overview
The proposed system extends Artemis and Athena automated feedback generation with a personalisation layer that employs learner profiles to tailor feedback to individual students. The scope includes mechanisms for collecting and maintaining profiles, incorporating those profiles into automated feedback generation, and presenting the resulting feedback within Artemis. Success will be measured by (i) the correctness and completeness of extracted learner attributes, (ii) the pedagogical quality of the personalised feedback, and (iii) the seamless integration into existing Artemis workflows—all assessed independently of any specific LLM vendor or database technology, in line with the abstraction principles of Brügge and Dutoit @bruegge2009.

== Existing System
Artemis (version 8.3.4) currently offers students the option to request automatically generated feedback for programming, modelling, and text exercises, provided the lecturer enables this feature. Each student may submit up to ten feedback requests per exercise. When a request is triggered, Artemis forwards the submission together with exercise metadata—problem statement, example solution, rubric, and maximum points—to Athena. Athena selects an exercise-specific feedback module that relies on an LLM prompt template and chain-of-thought reasoning to produce formative feedback aligned with the rubric. The generated feedback is returned to Artemis, which displays it in two categories: referenced feedback (anchored to specific lines or elements of the submission) and unreferenced feedback.

#TODO[
  I can put a small activity diagram here to show how the current system works
]

Although this pipeline delivers timely feedback, it treats each submission in isolation and disregards longitudinal evidence such as prior attempts, engagement metrics, or expressed preferences. Consequently, the generated feedback is uniform across students with diverse backgrounds and learning trajectories.

== Proposed System
The envisioned extension introduces learner profiles as a first-class artefact. A learner profile is a structured representation of a student's competencies, progress, and feedback preferences. Profiles will be populated automatically from submission traces, engagement data, and explicit preference settings, and will be updated incrementally after each new interaction. During feedback generation, Athena will retrieve the relevant profile and supply it—together with the current submission and grading rubric—to an LLM-driven pipeline. The LLM will be prompted to produce feedback that explicitly references profile attributes, thereby aligning the feedback with the student's needs and preferred style.

#TODO[
  Again here, I can visually support putting the learner profile to the diagram above
]

=== Functional Requirements

#fr("FR 1", "Configure Feedback Preferences", "The system should allow students to specify their preferred feedback granularity and tone through an intuitive interface.") 

#fr("FR 2", "Utilise Competencies", "The system should utilise the competencies set by the lecturers that are linked to an exercise when assessing the student's competency status.")

#fr("FR 3", "Extract Competencies", "The system should identify the competencies required for each exercise by analysing the provided metadata using a recognised taxonomy such as Bloom's Taxonomy - when they are not provided by the lecturer through the LMS.")

#fr("FR 4", "Assess Student's Competency Status", "For every new submission, the system should classify the student's mastery of each required competency linked to the exercise. The assessment should contain an evidence from student's submissions.")

#fr("FR 5", "Utilise Feedback Preferences", "The system should utilise the feedback preferences of the student regarding the feedback granularity and tone to generate personalised feedback.")

#fr("FR 6", "Utilise Submission History", "The system should make use of the submission history (i.e., previous submissions) to understand the student's progress when assessing the student's competency status.")

#fr("FR 7", "Utilise Engagement Data", "The system should incorporate engagement signals (i.e., forum posts, chat logs) extract the insights about where student is struggling when assessing the competency status.")

#fr("FR 8", "Generate Learner Profiles", "The system should construct a learner profile from the student's competency status (which encapsulate competencies and progress of the student) and explicit preference settings.")

#fr("FR 9", "Update Learner Profiles", "The system should refine the learner profile after changes in competency status and explicit preference settings. These changes can be triggered when student submits a new submission, engages with platform's chatbot, or when the student changes their feedback preferences.")

#fr("FR 10", "Request Personalised Feedback", "The system should allow students to request personalised feedback on their submission. After each submission, students should be able to request personalised feedback.") 

#fr("FR 11", "Generate Personalised Feedback", "Given a submission and the student's learner profile, the system should generate feedback that respects the learner profile.") 

#fr("FR 12", "View Personalised Feedback", "The system should display the personalised feedback to the student in a way that is easy to understand what the feedback is about, and what are the next steps to improve.")


=== Quality Attributes

#fr("QA 1", "Feedback Interface", "The feedback interface should clearly indicate what the student did well, what they could improve, and what are the next steps to improve, adhering to Artemis design conventions.")

#fr("QA 2", "Preference Interface", "The feedbackpreference-setting workflow should be easy to understand and complete. It should be intuitive to use and shouldn't take more than 1 minute for students to configure. Interface should adhere to Artemis design conventions.")

#fr("QA 3", "Reusability", "The developed system should make use of existing components and services from Artemis and Athena to avoid making the current system more complex and harder to maintain. The development on Athena side should use the same approach as the current development and should be in the matter of extending the current capabilites of the system.")

#fr("QA 4", "Documentation", "User and developer documentation should accompany the system. Users should be able to understand the functionalities and how to use them, while developers should be able to understand the system and how to extend it.")

#fr("QA 5", "Fault Tolerance", "In case personalised feedback generation fails, the system should degrade gracefully, allowing tutors and assistants to provide manual feedback to the students.")

#fr("QA 6", "Feedback Quality", "Personalised feedback should be at least as accurate and actionable as existing automated feedback.")

#fr("QA 7", "Latency", "Feedback generation should be completed within a reasonable time frame for students to take immediate action, ideally not more than 20 seconds per submission under normal load.")

#fr("QA 8", "Scalability", "The system should sustain increased load (e.g., large number of students asking for a feedback on complicated exercises) without significant performance degradation.")

#fr("QA 9", "Extensibility", "The system should be extensible to support new features and functionalities. The system should be designed in a way that allows for easy extension and modification of the existing codebase.")



=== Constraints

#fr("C 1", "Cost", "The system should be cost-efficient.")

#fr("C 2", "Maintainability", "The system should be maintainable.")

#fr("C 3", "Extensibility", "The system should be extensible.")

#fr("C 4", "Data Protection", "The system should be compliant with the GDPR and protect the personal data of the students.")




== System Models
#TODO[
  This section includes important system models for the requirements.
]
This section contains the system models for the requirements. First, the scenarios are presented for the proposed system, followed by the use case models to detail the scenarios. The dynamic model and the analysis object model give a more detail regarding the inner dynamics of the proposed system and how the objects are represented. Finally, the user interface mockups for the proposed system are presented. The diagrams in this section adhere to Unified Modeling Language (UML) to set a standard to model demonstration.

=== Scenarios
A scenario describes a sequence of interactions from the system's user's viewpoint, it is written in an informal tone and helps to understand the system from a user's perspective @bruegge2009. With the visionary scenarios, we aim to show the future potential of this domain, while the demo scenarios are more concrete and show the achievable potential of the proposed system. 
\
#text(weight: "bold")[Demo Scenarios] \
#text(weight: "bold")[Preference Configuration and Iterative Adaptation.] Anna, a first-semester student, often gets distracted reading long paragraphs. Before starting to solve the rate-limiter exercise, she visits the newly deployed Feedback Preferences page, where an interactive wizard previews different styles. She selects brief and formal as her feedback style. The system stores these choices in her learner profile.
Anna submits her initial answer and requests AI-generated feedback. She sees that the generated feedback is a direct sentence—“Definition lacks discussion of sliding-window algorithms”—followed by two numbered next steps: (1) compare token bucket with sliding-window log; (2) address trade-offs between memory and accuracy. The style matches her brief-formal preference.
Curious how richer guidance might look, Anna reopens the preference panel, sets the detail level to detail, and switches the tone to friendly. She revises her answer and requests feedback again. This time, the feedback begins with an encouraging summary of her improvements with a friendly tone backed-up by emojis, explains why sliding-window algorithms handle burst traffic differently, and provides a real-world example from a CDN. A final paragraph suggests adding further metrics for throughput under peak load.
Anna finds the expanded explanation helpful, as she feels like this can be her personal exercise coach, so she decides to keep the detail-friendly setting for future exercises. The scenario demonstrates that students can dynamically modulate feedback depth and tone to fit their learning stage, reducing cognitive overload when skimming and offering depth during consolidation. 

\
#text(weight: "bold")[History-Aware Feedback Leveraging Forum Activity.] Ben, a master's student who has already taken a few courses in networking, submits his first response to the same rate-limiter exercise. His answer covers token and leaky buckets but omits fixed-window counters. The feedback he receives acknowledges his clear abuse-prevention rationale, flags the missing strategy, and recommends covering distributed clock-sync issues. The closing section lists a sequential plan: research fixed-window counters, then discuss consistency.
Ben remains unsure why fixed-window counters can outperform token buckets. He posts a short question in the course forum: “Why opt for fixed window instead of token bucket despite the risk of bursts?” The forum post is automatically incorporated into his learner profile.
After reading peer replies, Ben edits his answer and submits it again. The second-round feedback opens with “Good job integrating fixed-window counters” and skips basic definitions, focusing instead on the nuance of time-skew mitigation. It explicitly references his forum question—“As you asked about burst risk...”—and elaborates on burst absorption under varying window sizes. Because Ben followed the earlier plan quickly, the system adds a Rapid Improver badge and logs his trajectory for instructor analytics.

=== Use Case Model
Under this subsection, we present the use case model for the proposed system, which is based on the scenarios presented in the previous section. It showcases the actions that can be initiated by the student - as use case models present the functionalities of a system that can be initiated by the users of the system @bruegge2009.

#figure(caption: "Use Case Model. Showcases the scenarios can be iniated by the student.", )[
  #image("../figures/use_case.png", width: 100%)
] <figure1>

In @figure1, we present the use cases of a student. A student can #text(style: "italic")[configure their feedback preferences] which allows students to specify their preferences regarding the feedback style dimensions (FR1). A student can also #text(style: "italic")[request a personalised feedback] (FR9) on their submission, which will trigger the #text(style: "italic")[generate personalised feedback] (FR10) use case. Generating the personalised feedback, since the personalised feedback respects the learner profile, includes the #text(style: "italic")[generating or updating learner profiles] (FR7) and (FR8), #text(style: "italic")[assess competency status] (FR3), #text(style: "italic")[utilise feedback preferences] (FR4), #text(style: "italic")[utilise submission history] (FR5), #text(style: "italic")[utilise engagement data] (FR6). After the generation of the personalised feedback is completed, the student can #text(style: "italic")[view the personalised feedback] (FR11).
\



=== Analysis Object Model
#TODO[
  This subsection should contain a UML Class Diagram showing the most important objects, attributes, methods and relations of your application domain including taxonomies using specification inheritance (see @bruegge2004object). Do not insert objects, attributes or methods of the solution domain. *Important:* Make sure to describe the analysis object model thoroughly in the text so that readers are able to understand the diagram. Also write about the rationale how and why you modeled the concepts like this.

]
#figure(caption: "Analysis Object Model")[
  #image("../figures/aom.png", width: 100%)
] <aom>

To provide a high-level abstraction of the problem domain, and how we initally modelled it, we use the Analysis Object Model (AOM). AOM covers the crucial objects, attributes, methods and relations of the application domain that would guide the design of the system throughout the implementation @bruegge2009. In this section, we present the AOM for the proposed system, as can be seen in @aom.

In the AOM, #text(weight: "bold")[Feedback Preferences] encapsulates the explicit, student-defined parameters that shape the feedback style.  Its attributes - #text(style: "italic")[feedbackDetail] and #text(style: "italic")[feedbackFormality] - record the desired level of detail (i.e., brief explanation vs. detailed explanation) and rhetorical tone (i.e., formal vs. friendly), while the operation #text(style: "italic")[configureFeedbackPreferences()] persists any change and notifies dependent services.  #text(weight: "bold")[Engagement Data] captures a complementary, implicit layer of information drawn from each learner's #text(style: "italic")[chatMessages] and #text(style: "italic")[forumPosts;] through #text(style: "italic")[utiliseEngagementData()] these traces become inputs when updating the learner's mastery estimates.  Together with #text(weight: "bold")[Student Competency Status]—which stores the evolving #text(style: "italic")[progress] for every required competency and records #text(style: "italic")[evidence] from student's submission results—both classes are aggregated into the overarching #text(weight: "bold")[Learner Profile].  The aggregation relationship expresses that the profile acts as an authoritative container.

 More detailly, #text(weight: "bold")[Student Competency Status] maintains a running estimate of each learner's mastery for every required concept. #text(style: "italic")[Progress] classify the status of the student's regarding the competency, while #text(style: "italic")[evidence] links to concrete evidence from student's submissions. The operation #text(style: "italic")[assessCompetencyStatus()] recalculates the mastery level whenever a new feedback is requested; #text(style: "italic")[utiliseSubmissionHistory()] makes sure that the previous submissions are taken into account when the competency status is assessed. A solid association ties the class to #text(weight: "bold")[Competency], signalling that each status record corresponds to one instructional target extracted from the exercise specification.

#text(weight: "bold")[Competency] stores the #text(style: "italic")[requiredCompetency] descriptor, the #text(style: "italic")[requiredBloomsLevel], and the reference to a #text(style: "italic")[gradingInstructionId]. #text(style: "italic")[extractCompetency()] parses the #text(weight: "bold")[Exercise] metadata—title, problem statement, example solution and grading instructions—to enumerate learning goals. The many-to-many link between Exercise and Competency acknowledges that a single task can address multiple outcomes and that the same outcome may reappear across assignments.

Learner interaction begins with a #text(weight: "bold")[Submission], whose attribute #text(style: "italic")[content] stores the uploaded solution. The adapted operation #text(style: "italic")[requestPersonalisedFeedback()] bundles the submission with the current Learner Profile and dispatches the package to the #text(weight: "bold")[PersonlisedFeedbackGenerator]. Inside that, field slots such as #text(style: "italic")[model], #text(style: "italic")[approach] and #text(style: "italic")[parameters] capture the concrete LLM configuration. The operation #text(style: "italic")[generatePersonalizedFeedback()] returns one or more #text(weight: "bold")[PersonalizedFeedback] objects.

Each #text(weight: "bold")[PersonalizedFeedback] instance aggregates the textual #text(style: "italic")[description] with an optional rubric reference, optional #text(style: "italic")[credits] and a #text(style: "italic")[suggestedAction] crafted for the next study step. The method #text(style: "italic")[viewPersonalisedFeedback()] marks the hand-off back to the user interface, where comments are rendered. 

=== Dynamic Model
In this subsection, we present the dynamic model for the proposed system. The dynamic model shows the flow of the system, and how the objects interact with each other using UML activity diagrams.
\
\
#text(weight: "bold")[Dynamic Model 1: Student Request Personalised Feedback]
\
It starts with the student submitting a solution. After submission has been created on Artemis, the student can request personalised feedback. The submission is then bundled with the current learner profile and previous submission and dispatched to Athena. Athena first checks if the exercise related to the submission has set competencies, and generates them on the fly if not. Then, it assesses the competency status of the student and generates a student competency status. The student competency status is then used to generate personalised feedback and to update the learner profile. The personalised feedback is then returned to the user interface for the student to view.



#figure(caption: "Dynamic Model 1: Student Requests Personalised Feedback")[
  #image("../figures/dynamic_1.png", width: 95%)
]
It is essential that this process is iterative; if the student is not satisfied with the preliminary results, they can still work on the submission and request new feedback.

#text(weight: "bold")[Dynamic Model 2: Student Configures Feedback Preferences]
\
The student can configure their feedback preferences under the learner profile settings. If the student has not already set up these, the system guides the student with an onboarding process. After setting the preferences up, the system will save them to the learner profile.

#figure(caption: "Dynamic Model 2: Student Configures Feedback Preferences")[
  #image("../figures/dynamic_2.png", width: 90%)
]


 
=== User Interface
This subsection presents the necessary interfaces, both the new ones and the ones that need to be adapted to the new system, for the proposed system to meet the requirements.

@mockup1 shows the first mockup iteration for the feedback preferences setup page. Since the preferences are part of the learner profile, the user will receive the feedback preferences set up under the learner profile settings. The mockup contains explanations regarding the Learner Profile, the feedback preferences, and each dimension of the feedback preferences, together with the explanations for each end of the spectrum. The setup interface would follow a segmented toggle approach, where users can click on the toggle to change the preference.


#figure(caption: "Feedback Preferences Setup Mockup")[
  #image("../figures/mockup_1.png", width: 100%)
] <mockup1>

@mockup2 presents the first mockup iteration for the redesigned feedback component. Following FR 11, the feedback component would be redesigned to be more user-friendly,  informative, and actionable. The mockup contains the feedback component with the feedback details, the feedback credits, and the subsequent improvement steps. The key differences from the current design are the better color coding, easily detectable status indicators, and more elaborate and visible next steps to improve.


#figure(caption: "Feedback Component Mockup")[
  #image("../figures/mockup_2.png", width: 100%)
] <mockup2>

