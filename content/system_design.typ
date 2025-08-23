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


= Architecture <architecture>

This section describes the design of our system according to the System Design Document Template by Bruegge and Dutoit @bruegge2009 and based on the requirements and system models presented in the previous chapter. We start with an overview, followed by the design goals derived from the quality attributes and constraints, subsystem decomposition, hardware software mapping, persistent data management, global software control, and boundary conditions, respectively.

== Overview
Aiming to enhance the feedback generation process and make it personalized for the students, we propose to develop a system that first utilizes and updates the existing components and services from Artemis and Athena, and extends their capabilities. We analyze the current system and identify the components and services that can be reused and extended. We also identify the components and services that we need to develop.

== Design Goals <design-goals>

Per the quality attributes and constraints specified in @quality-attributes and @constraints, we define the design goals that will direct the development of the proposed system. The design goals listed are then prioritized, considering the conflicting goals and trade-offs. To conduct a systematic evaluation, we utilize the design criteria classification established by Bruegge and Dutoit @bruegge2009, organizing our design objectives into five categories: Performance, Dependability, Cost, Maintenance, and End-user criteria.
\
\
#text(weight: "bold")[Performance.] The key performance criteria for our proposed system are latency (QA 7) and scalability (QA 8). Firstly, the system should be able to generate feedback in a reasonable time frame for students to take immediate action, ideally not more than 20 seconds per submission under normal load. Secondly, the system should handle many students and submissions without significant performance degradation. 
\
\
#text(weight: "bold")[Dependability.] The key dependability criteria are the fault tolerance (QA 5) and the system's feedback quality (QA 6). In case of a failure, the system should degrade gracefully, allowing tutors and assistants to provide manual feedback to the students, if necessary. The feedback quality should also be high enough to guide the students to improve their work.
\
\
#text(weight: "bold")[Cost.] The key cost criterion is the cost efficiency (C 1). The proposed system should not drastically increase costs by personalizing the feedback. It should optimize the cost-generating operations, since Artemis and Athena are open-source projects with limited funding; the system should be cost-efficient. 
\
\
#text(weight: "bold")[Maintenance.] The key maintenance criteria are the reusability (QA 3), documentation (QA 4), and extensibility (QA 9) of the system. First and foremost, the proposed system should use existing components and services from Artemis and Athena to avoid making the current system more complex and harder to maintain. The development should use the same conventions as the current development and extend the system's capabilities. We will design the features to allow for easy extension and modification of the existing codebase. Finally, the proposed system should be documented in detail to allow future developers who work on Artemis and Athena to understand the system and how to extend and/or maintain it.
\
\
#text(weight: "bold")[End-user.] The key end-user criteria are the feedback interface (QA 1) and the preference interface (QA 2), which would guide the proposed system implementation regarding design and usability. The feedback interface should indicate what the student did well and what they could improve, adhering to Artemis design conventions. The preference interface should be easy to understand and complete. It should be intuitive to use and should not take more than 1 minute for students to configure. Interface should adhere to Artemis design conventions. Additionally, the system considers data protection and GDPR compliance using Azure services in the European Union (C 4).
\
\
#text(weight: "bold")[Prioritization and Trade-offs.] When prioritizing the design goals, we consider the conflicting goals and trade-offs. End-user criteria are the top priorities since these represent the first contact point for the user with the platform. Following the end-user criteria, the dependability criteria prioritization is necessary, since the system should be reliable and available before it is personalized. Cost, performance, and maintenance closely follow dependability.

While some goals are conflicting, some can support each other. For example, dependability conflicts with cost and performance since creating a resilient system would require more resources and time. We must compromise on the performance and/or cost to increase the dependability. At the same time, dependability and maintainability are closely related, since a system is more likely to be reliable and available.

We prioritised the design goals so that this prioritisation would ensure the proposed system's intuitive design and dependability while accommodating other goals (i.e., cost, performance, and maintainability).


== Subsystem Decomposition

Under this subsection, we will decompose the overall architecture into subsystems. This decomposition helps us understand which parts of the current system can be reused and extended, and which are currently missing. We present three main subsystems: _Athena_, _Text Assessment Module_, and _Artemis_.


=== Athena 

For the proposed system, _Athena_ is the core subsystem that generates the personalized feedback. The current version of Athena (v1.3.0) provides an automated feedback generation service to LMSs and is currently connected to Artemis. The proposed system aims to extend this automated feedback generation service to personalized automated feedback generation. As presented in @sd, _Athena_ provides the _Feedback Generation Service_ to _Artemis Server_ and utilizes the _LLM Completion Service_ to generate the feedback. As a subsystem, _Athena_ also contains the _Assessment Module Manager_ component, assessment modules for three different exercise types: _Programming Assessment Module_, _Text Assessment Module_, and _File Assessment Module_, and finally the _LLM Module_.

#figure(caption: "UML Component Diagram for the Top-Level Subsystem Decomposition. Adapted and existing components are marked.", )[
  #image("../figures/subsystem-decomposition/overall.svg", width: 100% ,format: "svg")
] <sd>
\
The _Assessment Module Manager_ component orchestrates the incoming feedback requests through a REST API from LMSs, in our case Artemis, and redirects them to the correct assessment module based on the exercise type. 

The related assessment modules, namely _Programming Assessment Module_, _Text Assessment Module_, or _Modeling Assessment Module_, generate feedback for the related exercise type using the _LLM Completion Service_ through the _LLM Module_. 


=== Text Assessment Module

Now we will focus on the _Text Assessment Module_ subsystem, which resides in the _Athena_ subsystem and generates the feedback for text exercises. 
We developed our approach with text exercises because they were the easiest to test and evaluate with the students. We implemented the personalization pipeline into the _Text Assessment Module_ so that the other exercise types can easily adopt it. 

As @athena-sd displays, _Text Assessment Module_ contains the following components: _Personalized Feedback Generation_, _Prompt Management_, _Competency Extraction_, and _Student Status Analysis_. 
#figure(caption: "UML Component Diagram for the Subsystem Decomposition of the Text Assessment Module.", )[
  #image("../figures/subsystem-decomposition/athena.svg", width: 100% ,format: "svg")
] <athena-sd>
\



_Personalized Feedback Generation_ acts as an orchestrator and is responsible for generating personalized feedback using the input data provided by the _Assessment Module Manager_ and communicating with _Prompt Management_, _Competency Extraction_, and _Student Status Analysis_ components.

_Prompt Management_ manages the prompts to generate personalized feedback. It contains the directives for the different levels of feedback preferences (see _FeedbackPreferences_ in @aom). It automatically injects the corresponding directives into the feedback generation prompt for the personalised feedback generation based on the learner profile, which the _Assessment Module Manager _ provides.

_Competency Extraction_ is responsible for extracting the competencies from the Exercise object (see _Exercise_ in @aom). It is being called by the _Personalised Feedback Generation_ component when the LMS does not provide the competencies to the _Assessment Module Manager_.

_Student Status Analysis_ is responsible for analysing the student's status and providing the necessary information to the _Personalized Feedback Generation_ component. It creates a Student Status Analysis object (see _StudentStatusAnalysis_ in @aom), which is then used by the _Personalized Feedback Generation_ component to personalize the feedback.


=== Artemis
Lastly, we decompose the Artemis subsystem for the proposed system. Artemis follows a client-server architecture. The client side uses the Angular#footnote[https://angular.dev/] as a framework, and the server side uses the Spring Boot#footnote[https://spring.io/projects/spring-boot].

#figure(caption: "UML Component Diagram for the Subsystem Decomposition of Artemis. New, adapted, and existing components are marked.", )[
  #image("../figures/subsystem-decomposition/artemis.svg", width: 100% ,format: "svg")
] <artemis-sd>

@artemis-sd displays the Artemis side of the proposed system. We will focus on two further subsystems inside _Artemis Client_, namely _Learner Profile Module_ and _Feedback Module_.

The _Learner Profile Module_ manages the learner profile interaction between the student and the LMS. It contains the newly introduced _Feedback Preferences Onboarding Component_, which guides the student through the configuration process for feedback preferences. It also displays the learner profile to the student and allows them to configure the feedback preferences using _Learner Profile Attribute Configure Component_.

 _Feedback Module_ contains the newly developed _Feedback Component_, responsible for displaying the feedback. This component is then used in the different exercise type feedback components to display the feedback to the student, namely, _Programming Feedback Component_, _Text Feedback Component_, and _Modeling Feedback Component_.

 Both modules are connected to the Artemis Server through REST API calls. _Learner Profile Module_ uses _Learner Profile Service_ to fetch and update the learner profile. _Feedback Module_ uses _Feedback Service_ to request for a feedback.

 _Artemis Server_ is connected to _Athena_, as displayed in @sd as well, to fetch the feedback.

#pagebreak()

== Hardware Software Mapping

This subsection describes the mapping of the subsystems onto hardware components, as can be seen in @hw-sw-mapping. Students access the Artemis application through the Artemis Client running on their device. The Artemis Client is then connected to the Artemis Server running on the University's Data Center, together with Athena. Athena is connected to a 3rd-party LLM service provider to generate the feedback, which runs on a dedicated server of the provider's choice.

#figure(caption: "UML Deployment  Diagram for the Hardware Software Mapping. Showcases the mapping of the subsystems onto existing hardware and software components.", )[
  #image("../figures/hardware.svg", width: 90% ,format: "svg")
] <hw-sw-mapping>
