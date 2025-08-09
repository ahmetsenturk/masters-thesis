#import "/utils/todo.typ": TODO

#pagebreak()

= Architecture
#TODO[
  This chapter follows the System Design Document Template in @bruegge2004object. You describe in this chapter how you map the concepts of the application domain to the solution domain. Some sections are optional, if they do not apply to your problem. Cite @bruegge2004object several times in this chapter.
]
This sections describes the design of our system according to the System Design Document Template by Bruegge and Dutoit @bruegge2009 and based on the requirements and system models presented in the previous chapter. We start with an overview, followed by the design goals which are derived from the quality attributes and constraints, subsystem decomposition, hardware software mapping, persistent data management, global software control, and boundary condition, respectively.

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
#text(weight: "bold")[Performance.] 7 - 8
\
\
#text(weight: "bold")[Dependability.] 5 - 6
\
\
#text(weight: "bold")[Cost.]
\
\
#text(weight: "bold")[Maintenance.] 3 - 4 - 9
\
\
#text(weight: "bold")[End-user.] 1 - 2
\
\
#text(weight: "bold")[Prioritization and Trade-offs] 
Mention here that high quality feedback would conflict with latency.


== Subsystem Decomposition
#TODO[
  Describe the architecture of your system by decomposing it into subsystems and the services provided by each subsystem. Use UML class diagrams including packages / components for each subsystem.
]
Here mention that as the system is built on top of Artemis and Athena, we will reuse and extend the existing components and services from Artemis and Athena. We will also develop new components and services that are specific to the proposed system. Therefore it's necessary to decompose the system into subsystems and services provided by each subsystem and analyse current system to identify the components and services that can be reused and extended.

We can follow these steps:
- Give the overall picture, how Artemis and Athena are connected. The system is Athena Assessment Service.
- Then the where the personalisation is happening, so Athena Text Assessment Service.
- Finally the Artemis side - show here the Artemis client as well. 

== Hardware Software Mapping
#TODO[
  This section describes how the subsystems are mapped onto existing hardware and software components. The description is accompanied by a UML deployment diagram. The existing components are often off-the-shelf components. If the components are distributed on different nodes, the network infrastructure and the protocols are also described.
]

== Persistent Data Management
#TODO[
  Optional section that describes how data is saved over the lifetime of the system and which data. Usually this is either done by saving data in structured files or in databases. If this is applicable for the thesis, describe the approach for persisting data here and show a UML class diagram how the entity objects are mapped to persistent storage. It contains a rationale of the selected storage scheme, file system or database, a description of the selected database and database administration issues.
]


== Global Software Control
#TODO[
  Optional section describing the control flow of the system, in particular, whether a monolithic, event-driven control flow or concurrent processes have been selected, how requests are initiated and specific synchronization issues
]

== Boundry Conditions
#TODO[
  Optional section describing the use cases how to start up the separate components of the system, how to shut them down, and what to do if a component or the system fails.
]
