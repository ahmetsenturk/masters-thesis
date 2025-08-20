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


= Architecture <architecture>

This section describes the design of our system according to the System Design Document Template by Bruegge and Dutoit @bruegge2009 and based on the requirements and system models presented in the previous chapter. We start with an overview, followed by the design goals derived from the quality attributes and constraints, subsystem decomposition, hardware software mapping, persistent data management, global software control, and boundary conditions, respectively.

== Overview
Aiming to enhance the feedback generation process and make it personalized for the students, we propose to develop a system that first utilises and updates the existing components and services from Artemis and Athena, and extends their capabilities. We analyse the current system and identify the components and services that can be reused and extended. We also identify the components and services that need to be developed.

== Design Goals <design-goals>

Per the quality attributes and constraints specified in Sections 3.3.2 and 3.3.3, we define the design goals that will direct the development of the proposed system. The design goals listed are then prioritized, considering the conflicting goals and trade-offs. To conduct a systematic evaluation, we utilize the design criteria classification established by Bruegge and Dutoit @bruegge2009, organizing our design objectives into five categories: Performance, Dependability, Cost, Maintenance, and End-user criteria.
\
\
#text(weight: "bold")[Performance.] The key performance criteria for our proposed system are latency (QA 7) and scalability (QA 8). Firstly, the system should be able to generate feedback in a reasonable time frame for students to take immediate action, ideally not more than 20 seconds per submission under normal load. Secondly, the system should handle many students and submissions without significant performance degradation. Since some courses have many students, the system should be able to handle this load.
\
\
#text(weight: "bold")[Dependability.] The key dependability criteria are the fault tolerance (QA 5) and the system's feedback quality (QA 6). In case of a failure, the system should degrade gracefully, allowing tutors and assistants to provide manual feedback to the students, if necessary. The feedback quality should also be high enough to guide the students to improve their work.
\
\
#text(weight: "bold")[Cost.] The key cost criterion is the cost efficiency (C 1). The proposed system should not drastically increase costs by personalizing the feedback. It should optimize the cost-generating operations, since Artemis and Athena are open-source projects with limited funding; the system should be cost-efficient. 
\
\
#text(weight: "bold")[Maintenance.] The key maintenance criteria are the reusability (QA 3), documentation (QA 4), and extensibility (QA 9) of the system. First and foremost, the proposed system should use existing components and services from Artemis and Athena to avoid making the current system more complex and harder to maintain. The development on Athena and Artemis should use the same approach as the current development and should extend the system's current capabilities. The features that will be added to the existing system should be designed in a way that allows for easy extension and modification of the existing codebase. Finally, the proposed system should be documented in detail to allow future developers who work on Artemis and Athena to understand the system and how to extend and/or maintain it.
\
\
#text(weight: "bold")[End-user.] The key end-user criteria are the feedback interface (QA 1) and the preference interface (QA 2), which would guide the proposed system implementation regarding design and usability. The feedback interface should clearly indicate what the student did well and what they could improve, adhering to Artemis design conventions. The preference interface should be easy to understand and complete. It should be intuitive to use and should not take more than 1 minute for students to configure. Interface should adhere to Artemis design conventions. Additionally, the system considers data protection and GDPR compliance by making use of Azure services that lie in the European Union and are compliant with the GDPR by not utilising personal data to train their models (C 4).
\
\
#text(weight: "bold")[Prioritization and Trade-offs.] When prioritizing the design goals, we consider the conflicting goals and trade-offs. End-user criteria are prioritised the most, since these represent the first contact point of the user with the platform. Following the end-user criteria, the dependability criteria are prioritised, since the system should be reliable and available before it's personalised. Dependability is closely followed by cost, performance, and maintenance.

While some goals are conflicting, some can support each other. For example, dependability conflicts with cost and performance since creating a resilient system would require more resources and time, which means that if we want to increase the dependability, we would have to compromise on the performance and/or cost. At the same time, dependability and maintainability are closely related, since a system is more likely to be reliable and available.

We prioritised the design goals so that this prioritisation would ensure the proposed system's intuitive design and dependability while accommodating other goals (i.e., cost, performance, and maintainability).


== Subsystem Decomposition

Under this subsection, we will decompose the overall architecture into subsystems. This decomposition helps us understand which parts of the current system can be reused and extended, and which are currently missing. We present three main subsystems: _Athena_, _Text Assessment Module_, and _Artemis_.


=== Athena 

For the proposed system, _Athena_ is the core subsystem that generates the personalised feedback. The current version of Athena (TODO: Version) provides an automated feedback generation service to LMSs and is currently connected to Artemis. The proposed system aims to extend this automated feedback generation service to personalized automated feedback generation. As presented in @sd, _Athena_ provides the _Feedback Generation Service_ to _Artemis Server_ and utilises the _LLM Completion Service_ to generate the feedback. As a subsystem, _Athena_ also contains the _Assessment Module Manager_ component, assessment modules for three different exercise types: _Programming Assessment Module_, _Text Assessment Module_, and _File Assessment Module_, and finally the _LLM Module_.

#figure(caption: "Athena Subsystem Decomposition. ", )[
  #image("../figures/subsystem-decomposition/overall.svg", width: 100% ,format: "svg")
] <sd>

The _Assessment Module Manager_ component orchestrates the incoming feedback requests through a REST API from LMSs, in our case Artemis, and redirects them to the correct assessment module based on the exercise type. 

Feedback is then generated by the related assessment modules, namely _Programming Assessment Module_, _Text Assessment Module_, or _Modeling Assessment Module_. These modules are responsible for generating the feedback for the related exercise type using the _LLM Completion Service_ through the _LLM Module_. 


=== Text Assessment Module

Now we will focus on the _Text Assessment Module_ subsystem, which resides in the _Athena_ subsystem and is responsible for generating the feedback for text exercises. 
We chose to develop our approach with text exercises because they were the easiest to test and evaluate with the students. We implemented the personalisation pipeline into the _Text Assessment Module_ so that this can be easily replicated to other exercise types. 

#figure(caption: "Text Assessment Module Subsystem Decomposition. ", )[
  #image("../figures/subsystem-decomposition/athena.svg", width: 100% ,format: "svg")
] <athena-sd>


As @athena-sd displays, _Text Assessment Module_ contains the following components: _Personalised Feedback Generation_, _Prompt Management_, _Competency Extraction_, and _Student Status Analysis_. 

_Personalised Feedback Generation_ acts as an orchestrator and is responsible for generating the personalised feedback using the input data, which is provided by the _Assessment Module Manager_ and communicating with _Prompt Management_, _Competency Extraction_, and _Student Status Analysis_ components.

_Prompt Management_ is responsible for managing the prompts for the personalised feedback generation. It contains the directives for the different levels of feedback preferences (see _FeedbackPreferences_ in @aom). It automatically injects the corresponding directives into the feedback generation prompt for the personalised feedback generation based on the learner profile, which the _Assessment Module Manager _ provides.

_Competency Extraction_ is responsible for extracting the competencies from the Exercise object (see _Exercise_ in @aom). It is being called by the _Personalised Feedback Generation_ component when the LMS does not provide the competencies to the _Assessment Module Manager_.

_Student Status Analysis_ is responsible for analysing the student's status and providing the necessary information to the _Personalised Feedback Generation_ component. It creates a Student Status Analysis object (see _StudentStatusAnalysis_ in @aom), which is then used by the _Personalised Feedback Generation_ component to personalise the feedback.


=== Artemis
Lastly, we decompose the Artemis subsystem for the proposed system. Artemis is the LMS that is built on a client-server architecture. On the client side, Angular#footnote[https://angular.dev/] is being used as a framework, and on the server side, Spring Boot#footnote[https://spring.io/projects/spring-boot] is being used.

#figure(caption: "Artemis Client & Server Subsystem Decomposition. ", )[
  #image("../figures/subsystem-decomposition/artemis.svg", width: 100% ,format: "svg")
] <artemis-sd>

@artemis-sd displays the Artemis side of the proposed system. We will focus on two further subsystems inside _Artemis Client_, namely _Learner Profile Module_ and _Feedback Module_.

The _Learner Profile Module_ manages the learner profile interaction between the student and the LMS. It contains the newly introduced _Feedback Preferences Onboarding Component_, which is responsible for guiding the student through the feedback preferences configuration process. It also displays the learner profile to the student and allows them to configure the feedback preferences using _Learner Profile Attribute Configure Component_.

 _Feedback Module_ contains the newly developed _Feedback Component_, which is responsible for displaying the feedback. This component is then being used in the different exercise type feedback components to display the feedback to the student, namely, _Programming Feedback Component_, _Text Feedback Component_, and _Modeling Feedback Component_.

 Both modules are connected to the Artemis Server through REST API calls. _Learner Profile Module_ uses _Learner Profile Service_ to fetch and update the learner profile. _Feedback Module_ uses _Feedback Service_ to request for a feedback.

 _Artemis Server_ is connected to _Athena_, as displayed in @sd as well, to fetch the feedback.

== Hardware Software Mapping

This subsection describes the mapping of the subsystems onto hardware components, as can be seen in @hw-sw-mapping. Students access the Artemis application through the Artemis Client running on their device. The Artemis Client is then connected to the Artemis Server running on the University's Data Center, together with Athena. Athena is connected to a 3rd-party LLM service provider to generate the feedback, which runs on a dedicated server of the provider's choice.

#figure(caption: "Hardware Software Mapping. Showcases the mapping of the subsystems onto existing hardware and software components.", )[
  #image("../figures/hardware.svg", width: 90% ,format: "svg")
] <hw-sw-mapping>


== Persistent Data Management
We followed the approach of minimal changes and migrations to the database. We made use of what was already available and did not save any unnecessary data that the proposed system would generate in the intermediate steps. We introduce three new columns to the _Learner Profile_ table that represent students' feedback preferences: _feedbackDetail_, _feedbackFormality_, and _hasSetupFeedbackPreferences_. 


#figure(caption: "Learner Profile Table. Showcases the new columns introduced to the learner profile table.", )[
  #image("../figures/learner_profile.svg", width: 25% ,format: "svg")
] <learner-profile-table>


