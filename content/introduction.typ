#import "/utils/todo.typ": TODO

= Introduction
How can universities ensure that every student—from first-year newcomers to international postgraduates—receives personal feedback, even as enrolments swell into the tens of thousands? This challenge sits at the centre of contemporary higher education: scaling the feedback delivery to ever-growing cohorts while preserving the personal touch that transforms feedback.

Over the past decade, digital learning platforms powered by artificial intelligence (AI) have revolutionized feedback delivery, propelling a shift from teacher-centered to student-centered paradigms, such as the flipped classroom approach @monaco2007 @ozdamli2016. In this new landscape, learners engage more actively, direct their own studies proactively, and expect learning experiences that recognise their individual circumstances. 

As the center of education shifts from teacher to student, feedback today is even more critical for maintaining this evolution. When students are given take-home tasks and are expected to be proactive, they require validation and feedback on their submissions, not only in the form of a grade or correction. High-quality feedback can facilitate skill development, encourage self-reflection, and prompt self-regulated learning for students, enhancing their overall educational outcomes and reducing the discrepancies between current performance and a desired goal @hattie2007 @shute2008.

Current Learning Management Systems (LMSs) are already adopting this shift as they allow students to follow the course at their own pace, watch lectures, perform exercises, etc. Some also provide automated features that support instructors in effectively engaging many students, like automated feedback generation @turnbull2021. Artemis#footnote[https://github.com/ls1intum/Artemis] is one of these LMSs. Created at the Technical University of Munich (TUM), Artemis is an interactive learning platform offering automated feedback @krusche2018. Artemis allows lecturers to organize their courses by scheduling lectures, exercises, and quizzes. Athena#footnote[https://github.com/ls1intum/Athena], a standalone microservice that powers the feedback generation module in Artemis, automates the feedback process, providing timely, structured feedback and freeing instructors of tedious grading responsibilities @schwind2023 @dietrich2023.

This thesis focuses on expanding Artemis and Athena to provide personalized feedback to students, aggregating their competencies, submission history, and explicit feedback preferences.

== Problem <problem>

Delivering such individualized feedback manually becomes unmanageable with large student bodies. Cohorts exceed 1000 students in some courses at large universities like TUM, leaving instructors unable to craft individualized feedback for every student's submission. Even with generous teaching-assistant support, the time and cognitive load required to diagnose misconceptions, reference past performance, and suggest actionable next steps for each student are very demanding. This scalability bottleneck forces educators to rely on generic rubrics or minimal pass/fail remarks, diluting the pedagogical impact of feedback.

LMSs equipped with automated feedback modules—such as Artemis with Athena integration—solve the scalability pillar of the problem by generating feedback automatically based on students' submissions and other metadata, such as rubrics, yet they fall short on personalization. Most current pipelines treat every submission in isolation and disregard information about students' competencies, progress, and preferences. Consequently, the personalization pillar remains unutilized, overlooking the heterogeneity research deems essential for learning effectiveness. Scholars therefore advocate the creation of learner personas and profiles for students to support adaptive feedback and other personalized services @ballantyne2022 @le2009. However, practical methods for automatically deriving and integrating such profiles into feedback algorithms are still underexplored, and explicit mappings between profile data and adaptive feedback strategies are missing @maier2022.

In short, manual feedback works but does not scale; automated feedback scales but is not personal. The open problem is to deliver feedback that is both timely at scale and tailored to each learner.

== Motivation <motivation>

Personalized feedback significantly enhances learning. Research indicates engagement, satisfaction, and accomplishment improvements when feedback respects a learner's information @bulut2020 @maier2022 @hatziapostolou2010. When feedback takes into account things like what students already know, how good they are now, and their progress, how much they participate, and how they like to study best, research indicates that they are more satisfied, more engaged, and do better on tests @bulut2020 @mirmotahari2018. Maier and Klotz's assessment of 39 studies predominantly showed favorable outcomes for personalized feedback in education @maier2022. Personalized feedback helps students see their strengths, find areas where they need to improve, and decide what to do next, which helps them regulate themselves and get more involved. If TUM can reach these goals, it could help students do better on tests, get better grades in big classes, and make them feel more confident and independent.

Building a robust learner profile is the foundation for an end-to-end personalized learning flow inside LMSs. Such profiles can drive automatic recommendations aligned to competency gaps, enable adaptive pacing and scheduling, generate practice tasks calibrated to level, and power intelligent assistants—such as Iris—that use profile data to suggest resources and coach study strategies. Chun #text("et al.", style: "italic") used student inputs (e.g., motivation and prior knowledge) to build an LLM-based system that creates personalized, well-structured study plans with clear explanations and controllability through user-centered interactions. The plans include learning objectives, content selection rationales, cross-unit connections, and explanations for why to study each topic @chun2025. Results show improved usability, explainability, and controllability, suggesting real potential for personalized learning and self-directed study.

These points establish the motivation for this thesis and the following objectives.


== Objectives <objectives>
To address the previously mentioned problems in @problem, motivated by the points mentioned in @motivation, this thesis pursues three complementary research objectives that establish an end-to-end pipeline for personalized feedback in large-scale online courses.

\
=== Objective 1: Profiling University Students on LMSs. 
The first objective is to design and validate a learner-profiling method that can operate at scale within Artemis. We will (i) define a learner profile schema that respects the following three aspects: competency status, progress, and preferences - and use this schema to represent the information about the student which would later used to personalise the feedback for; (ii) identify which artefacts—such as submission history, engagement logs, forum posts, chat conversations, and previous assessments—most accurately reflect competencies, progress, and learning preferences; and (iii) compare rule-based feature engineering with large-language-model (LLM) approaches, including LLM-as-profiler pipelines that extract profile vectors from free-text evidence. The outcome will be a flexible profile schema that can be populated automatically and updated incrementally throughout a course.

\
=== Objective 2: Generate Personalized Feedback Utilising the Profile. 
Building on the learner profile and the current automated feedback generation pipeline on Athena, the second objective is to create a feedback generation pipeline that produces individualized, actionable feedback through LLMs. We will: (i) design a multi-stage workflow that feeds the learner profile, the current submission, and the grading rubric into an LLM; and (ii) explore prompting strategies—such as zero-shot and chain-of-thought prompts—to ensure that learner profile cues are effectively incorporated.
\
=== Objective 3: Delivering the Personalized Feedback. 
As a final objective, we want to complement the personalized feedback with an actionable and intuitive interface. We will design a user interface that allows students to understand the feedback easily - where they failed, what they did well, and what they could improve.
\
\
We will follow an iterative prototyping approach to implement all the objectives within Artemis and Athena, with evaluation criteria focusing on instructional relevance, computational efficiency, and stakeholder satisfaction.


== Outline
This thesis is structured as follows. @related_work, Related Work, introduces the current state-of-the-art LLM-based feedback generation and adaptive learning methods, trying to profile the students. @requirements, Requirements lists the requirements for the system and visualises the problem space with UML diagrams. @architecture, Architecture, describes the design details of the system. @implementation, Implementation, describes the implementation of the system and explains how we realized the objectives. @user_interviews, User Interviews presents the evaluation results. @summary, Summary, concludes the thesis and provides an outlook for future work.