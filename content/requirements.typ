#import "/utils/todo.typ": TODO

= Requirements
#TODO[
  This chapter follows the Requirements Analysis Document Template in @bruegge2004object. Important: Make sure that the whole chapter is independent of the chosen technology and development platform. The idea is that you illustrate concepts, taxonomies and relationships of the application domain independent of the solution domain! Cite @bruegge2004object several times in this chapter.

]

== Overview
#TODO[
  Provide a short overview about the purpose, scope, objectives and success criteria of the system that you like to develop.
]

== Existing System
#TODO[
  This section is only required if the proposed system (i.e. the system that you develop in the thesis) should replace an existing system.
]
#TODO[
  Here we should talk about the current Athena feedback generation pipeline and what kind of data it takes into account when generating feedback. Also the approaches that it follows when generating the feedback, how they utilize the LLMs, chain-of-thoughts, prompting, etc.
  Then Artemis, how it displays the feedback.
]
- Current Athena feedback generation pipeline
- The inputs currently being used, what is the output, what is the process - what technology is being used, which LLMs
- How it is different for different exercise types (?)

== Proposed System
#TODO[
  If you leave out the section “Existing system”, you can rename this section into “Requirements”.
]
- How do we want to achieve the goal of personalized feedback?
- We want to generate a learner profile
- What is the learner profile
- What sort of data do we need to generate the learner profile?
- How do we want to incorporate the learner profile into the feedback generation?

=== Functional Requirements
#TODO[
  List and describe all functional requirements of your system. Also mention requirements that you were not able to realize. The short title should be in the form “verb objective”

  - FR1 Short Title: Short Description. 
  - FR2 Short Title: Short Description. 
  - FR3 Short Title: Short Description.
]
*Personalization & Profile Management*
#terms(
  ("FR P.1 Configure Feedback Preferences:" , "Allow students to configure their individual feedback preferences such as detail level, feedback style, and focus."),
  ("FR P.2 Generate Learner Profiles:" , "Automatically create learner profiles for students based on their submission data and feedback history."),
  ("FR P.3 Update Learner Profiles:" , "Continuously refine learner profiles based on each new submission and feedback interaction.")
)

*Competency Analysis*
#terms(
  ("FR C.1 Extract Competencies:" , "Extract required competencies for each exercise based on provided metadata."),
  ("FR C.2 Assess Competency Status:" , "Analyze the student's performance on the required competencies and classify their mastery using Bloom's taxonomy.")
)

*Feedback Generation*
#terms(
  ("FR F.1 Generate Personalized Feedback:" , "Generate individualized feedback that incorporates both the learner profile and the student's configured preferences."),
  ("FR F.2 Generate Context-Aware Feedback:" , "Generate feedback that accounts for the student's submission history and previous feedback interactions."),
  ("FR F.3 Suggest Next Actions:" , "Provide concrete suggestions and next steps to guide the student's further learning.")
)


*Usability & Integration*
#terms(
  ("FR U.1 Provide Intuitive Interface:" , "Deliver a user-friendly interface for students to view their feedback, adjust preferences, and track progress."),
  ("FR U.2 Integrate with Artemis:" , "Expose APIs and data formats that enable seamless integration with the Artemis platform.")
)

*Data & History Management*
#terms(
  ("FR D.1 Track Submission History:" , "Track and store submission history and generated feedback for context-aware feedback generation."),
  ("FR D.2 Log Feedback Generation:" , "Log the feedback generation process to support transparency, debugging, and research.")
)


=== Quality Attributes
#TODO[
  List and describe all quality attributes of your system. All your quality attributes should fall into the URPS categories mentioned in @bruegge2004object. Also mention requirements that you were not able to realize.

  - QA1 Category: Short Description. 
  - QA2 Category: Short Description. 
  - QA3 Category: Short Description.

]

=== Constraints

#TODO[
  List and describe all pseudo requirements of your system. Also mention requirements that you were not able to realize.

  - C1 Category: Short Description. 
  - C2 Category: Short Description. 
  - C3 Category: Short Description.

]

== System Models
#TODO[
  This section includes important system models for the requirements.
]

=== Scenarios
#TODO[
  If you do not distinguish between visionary and demo scenarios, you can remove the two subsubsections below and list all scenarios here.

  *Visionary Scenarios*
  Describe 1-2 visionary scenario here, i.e. a scenario that would perfectly solve your problem, even if it might not be realizable. Use free text description.

  *Demo Scenarios*
  Describe 1-2 demo scenario here, i.e. a scenario that you can implement and demonstrate until the end of your thesis. Use free text description.
]
- We can define 2-3 different student personas before explaining the scenarios, since scenarios would differ based on the persona (We can use the personas we came up with on Notion)
- I think we don't necessarily have to differentiate between visionary and demo scenarios, since we can just show the demo scenario and the visionary scenario is just a bit more detailed. Maybe we can because of the learner profile, pair-wise preference elicitation with machine learning, etc.
- Student 1: The student who is just starting out and needs a lot of guidance, but don't really like to read too much
- Student 2: The student who is already familiar with the topic and needs a bit of guidance, mostly like to learn by reading

*Visionary & Demo Scenarios*
- Both students are taking the same course, but as mentioned, they have different competencies and different learning styles - namely different preferences on how they want their feedback to look like
- From this step on, the scenario is two folded, below is the scenario for Student 1
- Student 1 preferes brief feedback, and since the learning platform allows feedback preferences to be set, student 1 sets their preferences to brief feedback
- Student 1 submits their exercise, and the learning platform generates feedback for them
- The feedback is brief, and contains only the most important information - pointing out the mistakes, missing competencies, and the next steps on how to improve
- Student 1 understands what they need to improve on, and work on improving their grade, submit another solution
- Another feedback is generated, containing a comparison of the previous and the new solution, and a suggestion on how to improve further
- Student 1 further improves their answer and submit other solutions until they are satisfied with their grade.


=== Use Case Model
#TODO[
  This subsection should contain a UML Use Case Diagram including roles and their use cases. You can use colors to indicate priorities. Think about splitting the diagram into multiple ones if you have more than 10 use cases. *Important:* Make sure to describe the most important use cases using the use case table template (./tex/use-case-table.tex). Also describe the rationale of the use case model, i.e. why you modeled it like you show it in the diagram.

]

=== Analysis Object Model
#TODO[
  This subsection should contain a UML Class Diagram showing the most important objects, attributes, methods and relations of your application domain including taxonomies using specification inheritance (see @bruegge2004object). Do not insert objects, attributes or methods of the solution domain. *Important:* Make sure to describe the analysis object model thoroughly in the text so that readers are able to understand the diagram. Also write about the rationale how and why you modeled the concepts like this.

]
Here we'll add a few things to the existing model:
- [Modified] Learner Profile: This was already there, but we added the preferences attributes.
- [Modified] Athena Feedback Request: Latest submission and the learner profile have been added to the request.,
- [Modified] Feedback Model: This was also there, but we added a few attributes to this one as well.
- [New] Competency Model: This is a new model, that is used to store the competencies that the student needs to learn. It has a few other connections to the other models.
- [New] Competency Status, Cognitive Level, Required Competencies: These are new models, that are used to store the status of the competencies that the student needs to learn.

=== Dynamic Model
#TODO[
  This subsection should contain dynamic UML diagrams. These can be a UML state diagrams, UML communication diagrams or UML activity diagrams.*Important:* Make sure to describe the diagram and its rationale in the text. *Do not use UML sequence diagrams.*
]
Two different diagrams:
- First one is to explain the process of setting up learner profile
- Second one is explaining the process of generating feedback after submission. This can contain submitting two sequential solutions, and the feedback that is generated after each submission.
 
=== User Interface
#TODO[
  Show mockups of the user interface of the software you develop and their connections / transitions. You can also create a storyboard. *Important:* Describe the mockups and their rationale in the text.
]
Here we'll add the mockups we did on Excalidraw and the ones on Notion. Figma mockups will be added to the later sections as what we have done. This more of an ideation part.
