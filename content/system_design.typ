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
Here mention that as the system is built on top of Artemis and Athena, we will reuse and extend the existing components and services from Artemis and Athena. We will also develop new components and services that are specific to the proposed system. Therefore it's necessary to decompose the system into subsystems and services provided by each subsystem and analyse current system to identify the components and services that can be reused and extended.

We can follow these steps:
- Give the overall picture, how Artemis and Athena are connected. The system is Athena Assessment Service.

=== Artemis & Athena Subsystem
#figure(caption: "Artemis & Athena Subsystem Decomposition. ", )[
  #image("../figures/sd.png", width: 100%)
] <figure8>

Here we talk about how Athena and Artemis are connected, how assessment module manager manages the requests to redirect them to correct service with necessary information.

Then how different modules are connected to LLM core module of the Athena, and then how it is connected to 3rd party LLM chat completion service providers

=== Text Assessment Module



Here we should mention that we chose to test our approach with text exercises since they were the easiest to test to. We still implemented this in a way that the approach can be easily extended to other exercise types. But one should carefullycheck the results of the evaluation with other exercise types.

=== Artemis Client & Server
- Finally the Artemis side - show here the Artemis client as well for the newly designed feedback component and how it is being used in different parts of the system.

#figure(caption: "Artemis Client & Server Subsystem Decomposition. ", )[
  #image("../figures/artemis-sd.png", width: 100%)
] <figure9>

How Artemis is based on a client-server architecture, and how the client is the Artemis client, and the server is the Artemis server. What kind of technologies we use - Angular, Java etc. Maybe frameworks as well.



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
- Additional 3 columns for the learner profile
- Potentially -> Feedback type and next/suggested action

Mention hat in order to reduce the database migration and etc., re incorprated our decisions accordingly

== Boundry Conditions
#TODO[
  Optional section describing the use cases how to start up the separate components of the system, how to shut them down, and what to do if a component or the system fails.
]
