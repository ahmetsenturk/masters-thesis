#import "/utils/todo.typ": TODO

#let fr(id, title, body) = table(columns: (15mm, 1fr), stroke: none, [#id], [*#title*: #body])

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
= Requirements <requirements>
The requirements chapter follows the Requirements Analysis Document Template proposed by Brügge and Dutoit, emphasizing a clear separation between the application domain (problem space) and the solution domain (technology choices and implementation details) @bruegge2009. Therefore, all artefacts in this chapter describe what the system should achieve without assuming implementation details, an approach that supports traceability from stakeholder needs to design decisions.

== Overview
The proposed system extends Artemis and Athena automated feedback generation with a personalization integration that utilizes learner profiles to tailor feedback to individual students. The scope includes mechanisms for building and maintaining profiles, incorporating those profiles into automated feedback generation, and presenting the resulting feedback within Artemis. We will measure by (i) the correctness and completeness of extracted learner attributes, (ii) the pedagogical quality of the personalized feedback, and (iii) the seamless integration into existing Artemis workflows—all assessed independently of any specific LLM vendor or database technology, in line with the abstraction principles of Brügge and Dutoit @bruegge2009.

== Existing System
Artemis (version 8.3.4) currently allows students to request automatically generated feedback for programming, modelling, and text exercises, provided the lecturer enables this feature. Each student may submit up to ten feedback requests per exercise, and each feedback request maps to a single submission. When a request is triggered, Artemis forwards the submission and exercise metadata—problem statement, example solution, rubric, and maximum points—to Athena. Athena selects an exercise-specific feedback module that relies on an LLM prompt template and chain-of-thought reasoning to produce formative feedback aligned with the rubric. Athena sends the generated feedback back to Artemis, which displays it in two categories: referenced feedback (anchored to specific lines or elements of the submission) and unreferenced feedback.

Although this pipeline delivers timely feedback, it treats each submission in isolation and disregards longitudinal evidence such as prior attempts, engagement metrics, or expressed preferences. Consequently, the generated feedback is uniform across students with diverse backgrounds and learning trajectories.

== Proposed System
The envisioned extension introduces learner profiles as the foundation artefact. A learner profile is a structured representation of a student's competencies, progress, and feedback preferences. Profiles will be populated automatically from submission traces, engagement data, and explicit preference settings and updated incrementally after each new interaction. During feedback generation, Athena will retrieve the relevant profile and supply it with the current submission and grading rubric to an LLM-driven pipeline. The LLM will be prompted to produce feedback that explicitly references profile attributes, thereby aligning the feedback with the student's needs and preferred style and generating feedback that respects the following aspects: (i) competency status, (ii) progress, and (iii) preferences.

=== Functional Requirements <functional-requirements>

#fr("FR 1", "Configure Feedback Preferences", "The system should allow students to specify their preferred feedback granularity and tone through an intuitive interface.") 

#fr("FR 2", "Utilize Competencies", "The system should utilize the competencies set by the lecturers that are linked to an exercise when assessing the student's competency status.")

#fr("FR 3", "Extract Competencies", "The system should identify the competencies required for each exercise by analysing the provided metadata using a recognized taxonomy such as Bloom's Taxonomy - when the lecturer does not provide them through the LMS.")

#fr("FR 4", "Assess Student's Competency Status", "For every new submission, the system should classify the student's mastery of each required competency linked to the exercise. The assessment should contain evidence from students' submissions.")

#fr("FR 5", "Utilize Feedback Preferences", "The system should utilize the feedback preferences of the student regarding the feedback granularity and tone to generate personalized feedback.")

#fr("FR 6", "Utilize Submission History", "The system should make use of the submission history (i.e., previous submissions) to understand the student's progress when assessing the student's competency status.")

#fr("FR 7", "Utilize Engagement Data", "The system should incorporate engagement signals (i.e., forum posts, chat logs), extract the insights about where the student is struggling when assessing the competency status.")

#fr("FR 8", "Generate Learner Profiles", "The system should construct a learner profile from the student's competency status (which encapsulates competencies and progress of the student) and explicit preference settings.")

#fr("FR 9", "Update Learner Profiles", "The system should refine the learner profile after changes in competency status and explicit preference settings. These changes can be triggered when a student submits a new submission, engages with the platform's chatbot, or changes their feedback preferences.")

#fr("FR 10", "Request Personalized Feedback", "The system should allow students to request personalized feedback on their submission. After each submission, students should be able to request personalized feedback.") 

#fr("FR 11", "Generate Personalized Feedback", "Given a submission and the student's learner profile, the system should generate feedback that respects the learner profile.") 

#fr("FR 12", "View Personalized Feedback", "The system should display the personalized feedback to the student in a way that makes it easy to understand what the feedback is about, and what the next steps are to improve.")


=== Quality Attributes <quality-attributes>

#fr("QA 1", "Feedback Interface", "The feedback interface should indicate what the student did well, what they could improve, and what the following steps are to improve, adhering to Artemis design conventions.")

#fr("QA 2", "Preference Interface", "The feedback preference-setting workflow should be easy to understand and complete. It should be intuitive to use, should not take more than 1 minute for students to configure, and should adhere to Artemis design conventions.")

#fr("QA 3", "Reusability", "The developed system should make use of existing components and services from Artemis and Athena to avoid making the current system more complex and more challenging to maintain. The development on the Athena side should use the same approach as the current development and should extend the current capabilities of the system.")

#fr("QA 4", "Documentation", "User and developer documentation should accompany the system. Users should be able to understand the functionalities and how to use them, while developers should be able to understand the system and how to extend it.")

#fr("QA 5", "Fault Tolerance", "In case personalized feedback generation fails, the system should degrade gracefully, allowing tutors and assistants to provide manual feedback to the students.")

#fr("QA 6", "Feedback Quality", "Personalized feedback should be at least as accurate and actionable as existing automated feedback.")

#fr("QA 7", "Latency", "Feedback generation should be completed within a reasonable time frame for students to take immediate action, not more than 20 seconds per submission under normal load.")

#fr("QA 8", "Scalability", "The system should sustain increased load (e.g., large number of students asking for feedback on complicated exercises) without significant performance degradation.")

#fr("QA 9", "Extensibility", "The system should be extensible to support new features and functionalities. The system should be designed in a way that allows for easy extension and modification of the existing codebase.")



=== Constraints <constraints>

#fr("C 1", "Cost", "Running the proposed system should not increase the computing costs of the Artemis and Athena systems too much, not more than 1%.")

#fr("C 2", "Maintainability", "The system should be maintainable with every additional feature and development in the future.")

#fr("C 3", "Data Protection", "The system should be compliant with the GDPR and protect the personal data of the students.")

#pagebreak()


== System Models

This section contains the system models for the requirements. First, we present the scenarios for the proposed system, followed by the use case models to detail the scenarios. The dynamic and the analysis object models give more details regarding the proposed system's inner dynamics and how we represent the objects. Finally, we present the initial mockups for the proposed system's user interface. The diagrams in this section adhere to Unified Modeling Language (UML) to set a standard for modeling demonstrations.

=== Scenarios
A scenario describes a sequence of interactions from the system's user's viewpoint. It is written in an informal tone and helps to understand the system from a user's perspective @bruegge2009. We aim to show the proposed system's achievable potential with the scenarios. 
\
\
#text(weight: "bold")[Preference Configuration and Iterative Adaptation.] Before solving the rate-limiter exercise, Anna, a first-semester student, visits the newly deployed Feedback Preferences page on Artemis, where an interactive onboarding wizard previews different styles with example feedback. She selects brief and formal as her feedback style. The system stores these choices in her learner profile.
Anna submits her initial answer and requests AI-generated feedback. She sees that the generated feedback is a direct sentence—"Definition lacks discussion of rate-limiting strategies"—followed by a next step: mention two different rate-limiting strategies. The style matches her brief-formal preference.
Curious about how different guidance might look, Anna reopens the preference panel, sets the detail level to detail, and switches the tone to friendly. She revises her answer and requests feedback again. This time, the feedback begins with an encouraging summary of her improvements with a friendly tone backed up by emojis, explains why sliding-window algorithms handle burst traffic differently, and provides a real-world example from a CDN. A final paragraph suggests adding further metrics for throughput under peak load.
Anna finds the elaborate explanation helpful, so she decides to keep the detail-friendly setting for future exercises. The scenario demonstrates that students can dynamically adjust feedback depth and tone to fit their learning stage. 
\
\
#text(weight: "bold")[History-Aware Feedback.] Ben, a master's student who has already taken a few courses in networking, submits his first response to the same rate-limiter exercise. His answer covers the rate limiter explanation and one strategy, but lacks the second strategy and a comparison between the strategies. The feedback he receives acknowledges his clear explanation and one strategy, flags the missing strategy, and the missing comparison. All feedback has the next steps for Ben on what to do to achieve better results.
Ben edits his answer, adds a second rate-limiting strategy, and submits it again. The second-round feedback opens with "Good job adding the second strategy," and another feedback, "Strategy comparison is still missing," indicating that the system considers the submission history when generating the feedback. The scenario demonstrates that feedback generation can be personalized by incorporating their progress.

=== Use Case Model
This subsection outlines the use case model for the proposed system, derived from the scenarios detailed in the preceding section. It illustrates the actions that students can undertake, as use case models define the features of a system that its users can activate @bruegge2009.

In @figure1, we present the use cases of a student. A student can #text(style: "italic")[configure their feedback preferences], which allows students to explicitly specify their preferences regarding the feedback style dimensions (FR1). A student can also #text(style: "italic")[request a personalized feedback] (FR9) on their submission, which will trigger the #text(style: "italic")[generate personalized feedback] (FR10) use case. Generating the personalized feedback, since the personalized feedback respects the learner profile, includes the #text(style: "italic")[generating or updating learner profiles] (FR7) and (FR8), and consequently #text(style: "italic")[assess competency status] (FR3). This would include #text(style: "italic")[utilize feedback preferences] (FR4), #text(style: "italic")[utilize submission history] (FR5), #text(style: "italic")[utilize engagement data] (FR6). After the generation of the personalized feedback is complete, the student can #text(style: "italic")[view the personalized feedback] (FR11).

#figure(caption: "UML Use Case Diagram. Showcases the scenarios a student can initiate.", )[
  #image("../figures/use_case.svg", width: 100% ,format: "svg")
] <figure1>
\

=== Analysis Object Model

To provide a high-level abstraction of the problem domain and how we initially modelled it, we use the Analysis Object Model (AOM). AOM covers the application domain's crucial objects, attributes, methods, and relations that would guide the system's design throughout the implementation @bruegge2009. In this section, we present the AOM for the proposed system, as seen in @aom.

In the AOM, #text(weight: "bold")[Feedback Preferences] encapsulates the explicit, student-defined parameters that shape the feedback style. Its attributes - #text(style: "italic")[detail] and #text(style: "italic")[formality] - record the desired level of detail (i.e., brief explanation vs. detailed explanation) and rhetorical tone (i.e., formal vs. friendly), while the operation #text(style: "italic")[configure()] persists any change and notifies dependent services.

#figure(caption: "UML Class Diagram for the Analysis Object Model. Illustrates the objects and their relationships that are necessary to model the proposed system. ")[
  #image("../figures/aom.svg", width: 100% ,format: "svg")
] <aom>
\
  #text(weight: "bold")[Engagement Data] captures a complementary, implicit layer of information drawn from each learner's #text(style: "italic")[chatMessages] and #text(style: "italic")[forumPosts]. Together with #text(weight: "bold")[Student Competency Status]—which stores the evolving #text(style: "italic")[progress] for every required competency and records #text(style: "italic")[evidence] from student's submission results—these three classes aggregate into the overarching #text(weight: "bold")[Learner Profile]. 


#text(weight: "bold")[Student Competency Status] maintains a running estimate of each learner's mastery for every required concept. #text(style: "italic")[Progress] classifies the status of the students regarding the Competency, while #text(style: "italic")[evidence] links to concrete evidence from students' submissions. The operation #text(style: "italic")[assess()] recalculates the mastery level whenever new feedback is requested. A solid association ties the class to #text(weight: "bold")[Competency], signalling that each status record corresponds to one instructional target extracted from the exercise specification.

#text(weight: "bold")[Competency] stores the #text(style: "italic")[description], the #text(style: "italic")[bloomsLevel], and the reference to a #text(style: "italic")[gradingInstruction]. #text(style: "italic")[extract()] parses the #text(weight: "bold")[Exercise] metadata—#text(style: "italic")[title], #text(style: "italic")[problemStatement], #text(style: "italic")[exampleSolution], and #text(style: "italic")[gradingInstructions]—to enumerate learning goals. The many-to-many link between Exercise and Competency acknowledges that a single task can address multiple outcomes and that the same outcome may reappear across assignments.

Learner interaction begins with a #text(weight: "bold")[Submission], whose attribute #text(style: "italic")[content] stores the uploaded solution. The adapted operation #text(style: "italic")[request()] of #text(weight: "bold")[Personalized Feedback] bundles the Submission with the current Learner Profile and requests Personalized Feedback.

Each Personalized Feedback aggregates the textual #text(style: "italic")[description] with an optional rubric reference, optional #text(style: "italic")[credits], and a #text(style: "italic")[suggestedAction] crafted for the next study step. The method #text(style: "italic")[view()] marks the hand-off back to the user interface. 

=== Dynamic Model
In this subsection, we present the dynamic models for the proposed system using UML activity diagrams to show the system's flow and how the objects interact. The first dynamic model shows the feedback preference configuration workflow, while the second dynamic model shows the personalized feedback request, generation, and presentation workflow.

\
#text(weight: "bold")[Dynamic Model 1: Student Configures Feedback Preferences]
\
The first dynamic model showcases how the feedback preference configuration works. The student can access the feedback preference settings from the Artemis settings page by opening the learner profile settings. The system guides the student with an onboarding wizard if the student has not set up the feedback preferences. After setting the preferences up, the system will save them to the learner profile. The student can then see and update the saved feedback preferences if necessary.

#figure(caption: "UML Activity Diagram illustrating the feedback preference configuration workflow.")[
  #image("../figures/dynamic_2.svg", width: 80% ,format: "svg")
]

\
#text(weight: "bold")[Dynamic Model 2: Student Requests Personalized Feedback]
\
@dynamic-model-1 shows the dynamic model for the student requesting personalized feedback.
It starts with the student submitting a solution. The student can request personalized feedback after creating the submission on Artemis. The submission is then bundled with the learner profile, previous submission, and exercise and dispatched to Athena. Athena first checks if the exercise related to the submission has set competencies, and generates them on the fly if not. Then, it assesses the competency status of the student and generates a student competency status. 

#figure(caption: "UML Activity Diagram illustrating the personalized feedback request, generation, and presentation workflow.")[
  #image("../figures/dynamic_1.svg", width: 95% ,format: "svg")
] <dynamic-model-1>

The student competency status is then used to generate personalized feedback and to update the learner profile. Students can then view the personalized feedback on the Artemis interface.

It is crucial to note that the whole process is iterative. If the student is unsatisfied with the results, the student can submit another solution and request personalized feedback. Making the personalized feedback accessible can help students iteratively improve by utilizing the easily accessible feedback.


 
=== User Interface
This subsection presents the necessary interfaces, both the new ones and the ones that need to be adapted to the new system, for the proposed system to meet the requirements.

@mockup1 shows the first mockup iteration for the feedback preferences setup page. Since the preferences are part of the learner profile, the user will set the feedback preferences under the learner profile settings. The mockup contains explanations regarding the Learner Profile, the feedback preferences, and each dimension of the feedback preferences, together with the explanations for each end of the spectrum. 

#figure(caption: "Feedback preferences setup mockup. Students can set up their feedback preferences on this page by seeing the explanations of the preference dimensions and clicking on the segmented buttons.")[
  #image("../figures/preference-component/mockup.png", width: 90%)
] <mockup1>
\
The setup interface would follow a segmented toggle approach to make the workflow easy to understand and intuitive, as QA 2 states, where users can click on the toggle to change the preference. 

@mockup2 presents the first mockup iteration for the feedback component. According to Hattie and Timperley, the feedback should be actionable, understandable, and aligned with the student's needs @hattie2007. This should also apply to how to deliver feedback to the students. While the content of the feedback is essential, the way it is delivered is also important. Following FR 12 and QA 1, we defined that a feedback should be (i) actionable (i.e., students should be able to understand what is the next step they should take) and (ii) understandable (i.e., students should be able to understand what the feedback is about, where did they succeed and where did they fail). 

#figure(caption: [Feedback component mockup. Badges of different colors and titles help students quickly understand the feedback. The next section should explain the action the student should take to improve.])[
  #image("../figures/feedback-component/mockup.png", width: 89%)
] <mockup2>
