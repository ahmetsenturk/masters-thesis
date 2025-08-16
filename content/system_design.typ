#import "/utils/todo.typ": TODO

#pagebreak()

= Architecture
#TODO[
  This chapter follows the System Design Document Template in @bruegge2004object. You describe in this chapter how you map the concepts of the application domain to the solution domain. Some sections are optional, if they do not apply to your problem. Cite @bruegge2004object several times in this chapter.
]
This section describes the design of our system according to the System Design Document Template by Bruegge and Dutoit @bruegge2009 and based on the requirements and system models presented in the previous chapter. We start with an overview, followed by the design goals which are derived from the quality attributes and constraints, subsystem decomposition, hardware software mapping, persistent data management, global software control, and boundary condition, respectively.

== Overview
#TODO[
  Provide a brief overview of the software architecture and references to other chapters (e.g. requirements), references to existing systems, constraints impacting the software architecture..
]
Aiming to enhance the feedback generation process and making it personlised for the students, we propose to develop a system that first utilises and updates the existing components and services from Artemis and Athena and extend their capabilities. We analyse the current system and identify the components and services that can be reused and extended. We also identify the components and services that need to be developed.

== Design Goals
#TODO[
  Derive design goals from your quality attributes and constraints, prioritize them (as they might conflict with each other) and describe the rationale of your prioritization. Any trade-offs between design goals (e.g., build vs. buy, memory space vs. response time), and the rationale behind the specific solution should be described in this section
]

In accordance with the quality attributes and constraints specified in Section 3.3.2 and 3.3.3, we define the design goals that will direct the development of the proposed system. The design goals listed are then prioritized considering the conflicting goals and trade-offs. To conduct a systematic evaluation, we utilize the design criteria classification established by Bruegge and Dutoit @bruegge2009, organizing our design objectives into five categories: Performance, Dependability, Cost, Maintenance, and End-user criteria.
\
\
#text(weight: "bold")[Performance.] The key performance criteria are latency (QA 7) and scalability (QA 8) for our proposed system. Firstly, the system should be able to generate feedback in a reasonable time frame for students to take immediate action, ideally not more than 20 seconds per submission under normal load. Secondly, the system should be able to handle a large number of students and submissions without significant performance degradation. Since some courses have a large number of students, the system should be able to handle this load.
\
\
#text(weight: "bold")[Dependability.] The key dependability criteria are the fault tolerance (QA 5) and the feedback quality (QA 6) of the system. In case of a failure, the system should degrade gracefully, allowing tutors and assistants to provide manual feedback to the students, if they deem necessary. Additionally, the feedback quality should be high enough to guide the students to improve their work.
\
\
#text(weight: "bold")[Cost.] The key cost criterion is the cost efficiency (C 1). Proposed system should not increase the costs drastically by making the feedback personalised. It should optimize the cost-generating operations, since Artemis and Athena are open-source projects with limited funding, the system should be cost-efficient. 
\
\
#text(weight: "bold")[Maintenance.] The key maintenance criteria are the reusability (QA 3), documentation (QA 4) and extensibility (QA 9) of the system. The proposed system, first and foremost, should make use of existing components and services from Artemis and Athena to avoid making the current system more complex and harder to maintain. The development on Athena and Artemis should use the same approach as the current development and should be in the matter of extending the current capabilites of the system. The features that will be added on top of the existing system should be designed in a way that allows for easy extension and modification of the existing codebase. Finally, the proposed system should be documented in detail to allow future developers who work on Artemis and Athena to understand the system and how to extend and/or maintain the system.
\
\
#text(weight: "bold")[End-user.] The key end-user criteria are the feedback interface (QA 1) and the preference interface (QA 2), which would guide the proposed system implementation in terms of design and usability. The feedback interface should clearly indicate what the student did well and what they could improve, adhering to Artemis design conventions. The preference interface should be easy to understand and complete. It should be intuitive to use and shouldn't take more than 1 minute for students to configure. Interface should adhere to Artemis design conventions. Additionally, the system considers the data protection and GDPR compliance, by making use of the Azure services that lie in European Union and that are compliant with the GDPR by not utilising personal data to train their models (C 4).
\
\
#text(weight: "bold")[Prioritization and Trade-offs] When prioritizing the design goals, we consider the conflicting goals and trade-offs. End-user criteria are prioritised the most, since these represent the first contact point of the user with the platform. Following the end-user criteria, the dependability criteria are prioritised, since the system should be reliable and available for [TODO: Continue here] Dependability is closely followed by cost, performance, and maintance.

While some goals are conflicting, some can support each other. For example, dependability is conflicting with cost and performance, since creating a resilient system would require more resources and time which would mean that if we want to increase the dependability, we would have to compromise on the performance and/or cost. [TODO: Continue here]

We prioritised the design goals in a way that this prioritisation would ensure the proposed system's intuitive design and dependability while accommodating other goals (i.e., cost, performance, and maintainability).


== Subsystem Decomposition
#TODO[
  Describe the architecture of your system by decomposing it into subsystems and the services provided by each subsystem. Use UML class diagrams including packages / components for each subsystem.
]
Under this subsection we will decompose the overall architecture into subsystems. This decomposition helps us to understand which parts of the current system can be reused, to be extended, and which parts are currently missing. We present three main subsystems: _Athena_, _Text Assessment Module_, and _Artemis_.


=== Athena 

For the proposed system, _Athena_ is the core subsystem that generates the personalised feedback. Current version of Athena (TODO: Version) provides automated feedback generation service to LMSs and currently is connected to Artemis, the proposed system is aiming to extend this automated feedback generation service to personalised automated feedback generation. As presented in @sd, _Athena_ provides the _Feedback Generation Service_ to _Artemis Server_ and utilises the _LLM Completion Service_ to generate the feedback. As a subsystem, _Athena_ also contains of the _Assessment Module Manager_ component, assessment modules for three different exercise types: _Programming Assessment Module_, _Text Assessment Module_, and _File Assessment Module_, and finally the _LLM Module_.

#figure(caption: "Athena Subsystem Decomposition. ", )[
  #image("../figures/sd.png", width: 100%)
] <sd>

The _Assessment Module Manager_ component orchestrates the incoming feedback requests through a REST API from LMSs, in our case Artemis, and redirects them to the corect assessment module based on the exercise type. 

Feedback is then generated by the related assessment modules, namely _Programming Assessment Module_, _Text Assessment Module_, or _Modeling Assessment Module_. These modules are responsible for generating the feedback for the related exercise type using the _LLM Completion Service_ through the _LLM Module_. 



=== Text Assessment Module

Now we will focus on the _Text Assessment Module_ subsystem which resides in the _Athena_ subsystem and is responsible for generating the feedback for text exercises. 
The reason we chose to develop our approach with text exercises is that they were the easiest to test and evaluate with the students. We implemented the personalisation pipeline into the _Text Assessment Module_ in a way that this can be easily replicated to other exercise types. 

#figure(caption: "Text Assessment Module Subsystem Decomposition. ", )[
  #image("../figures/athena-sd.png", width: 100%)
] <athena-sd>


As @athena-sd displays, _Text Assessment Module_ contains the following components: _Personalised Feedback Generation_, _Prompt Management_, _Competency Extraction_, and _Student Status Analysis_. 

_Personalised Feedback Generation_ acts as an orchestrator and is responsible for generating the personalised feedback using the input data which is provided by the _Assessment Module Manager_ and communicating with _Prompt Management_, _Competency Extraction_, and _Student Status Analysis_ components.

_Prompt Management_ is responsible for managing the prompts for the personalised feedback generation. It contains the directives for the different levels of feedback preferences (see _FeedbackPrefences_ in @aom) and automatically injects the corresponding directives into the feedback generation prompt for the personalised feedback generation based on the learner profile which is provided by the _Assessment Module Manager_.

_Competency Extraction_ is responsible for extracting the competencies from the Exercise object (see _Exercise_ in @aom). It is being called by the _Personalised Feedback Generation_ component when the competencies are not provided by the LMS to _Assessment Module Manager_.

_Student Status Analysis_ is responsible for analysing the student's status and providing the necessary information to the _Personalised Feedback Generation_ component. It creates a Student Status Anlysis object (see _StudentStatusAnalysis_ in @aom) which is then being used by the _Personalised Feedback Generation_ component to personalise the feedback.


=== Artemis
Lastly we decompose the Artemis subsystem for the proposed system. Artemis is the LMS that is built in a client-server architecture. On the client side, Angular#footnote[https://angular.dev/] is being used as a framework, and on the server side, Spring Boot#footnote[https://spring.io/projects/spring-boot] is being used.

#figure(caption: "Artemis Client & Server Subsystem Decomposition. ", )[
  #image("../figures/artemis-sd.png", width: 100%)
] <artemis-sd>

@artemis-sd displays the Artemis side of the proposed system. We will focus two further subsystems inside _Artemis Client_, namely _Learner Profile Module_ and _Feedback Module_.

_Learner Profile Module_ is responsible for managing the learner profile interaction between the student and the LMS. It contains the newly introduced _Feedback Preferences Onboarding Component_ which is responsible for guiding the student through the feedback preferences configuration process. It also displays the learner profile to the student and allows them to configure the feedback preferences using _Learner Profile Attribute Configure Component_.

 _Feedback Module_ contains the newly developed _Feedback Component_ which is responsible for displaying the feedback. This component is then being used in the different exercise type feedback components to display the feedback to the student, namely, _Programming Feedback Component_, _Text Feedback Component_, and _Modeling Feedback Component_.

 Both modules are connected to the Artemis Server through REST API calls. _Learner Profile Module_ uses _Learner Profile Service_ to fetch the learner profile and to update the learner profile. _Feedback Module_ uses _Feedback Service_ to request for a feedback.

 _Artemis Server_ is connected to _Athena_, as displayed in @sd as well, to fetch the feedback.


== Hardware Software Mapping
#TODO[
  This section describes how the subsystems are mapped onto existing hardware and software components. The description is accompanied by a UML deployment diagram. The existing components are often off-the-shelf components. If the components are distributed on different nodes, the network infrastructure and the protocols are also described.
]

#figure(caption: "Hardware Software Mapping. Showcases the mapping of the subsystems onto existing hardware and software components.", )[
  #image("../figures/hw-sw-mapping.png", width: 100%)
] <figure7>

== Persistent Data Management
#TODO[
  Optional section that describes how data is saved over the lifetime of the system and which data. Usually this is either done by saving data in structured files or in databases. If this is applicable for the thesis, describe the approach for persisting data here and show a UML class diagram how the entity objects are mapped to persistent storage. It contains a rationale of the selected storage scheme, file system or database, a description of the selected database and database administration issues.
]
_Learner Profile_ table was previouslyh introduced by a colleague as a blackboard pattern but without any columns. With our proposed system, we introduce 3 new columns to the table: _feedbackDetail_, _feedbackFormality_, and _hasSetupFeedbackPreferences_. 


#figure(caption: "Learner Profile Table. Showcases the new columns introduced to the learner profile table.", )[
  #image("../figures/learnerProfile.png", width: 25%)
] <learner-profile-table>


