#import "/utils/todo.typ": TODO

= Introduction
How can universities ensure that every student—from first-year newcomers to international postgraduates—receives personal feedback, even as enrolments swell into the tens of thousands? This challenge sits at the centre of contemporary higher education: scaling the feedback delivery to ever-growing cohorts while preserving the personal touch that makes feedback transformative.

Over the past decade, digital learning platforms powered by artificial intelligence (AI) have revolutionized feedback delivery, propelling a shift from teacher-centered to student-centered paradigms, such as the flipped classroom approach @monaco2007 @ozdamli2016. In this new landscape, learners engage more actively, direct their own studies proactively, and expect learning experiences that recognise their individual circumstances. 

As the center of education shifts from teacher to student, the role of feedback today is even more critical than before for this evolution to be maintained. When students are given take-home tasks and are expected to be proactive, they require validation and feedback on their submissions, not only in the form of a grade or correction. High-quality feedback can facilitate skill development, encourage self-reflection, and prompt self-regulated learning for students, enhancing their overall educational outcomes and reducing the discrepancies between current performance and a desired goal @hattie2007 @shute2008.

Current Learning Management Systems (LMSs) are already adopting this shift as they allow students to follow the course at their own pace, watch lectures, perform exercises, etc. Some also provide automated features that support instructors in effectively engaging many students, like automated feedback generation @turnbull2021. Artemis#footnote[https://github.com/ls1intum/Artemis] is one of these LMSs. Created at the Technical University of Munich (TUM), Artemis is an interactive learning platform offering automated feedback @krusche2018. Artemis allows lecturers to organize their courses by scheduling lectures, exercises, and quizzes. Athena#footnote[https://github.com/ls1intum/Athena], a standalone microservice that powers the feedback generation module in Artemis, automates the feedback process, providing timely, structured feedback and freeing instructors of tedious grading responsibilities @schwind2023 @dietrich2023.

This thesis focuses on expanding Artemis and Athena to provide personalised feedback to students, aggregating their competencies, submission history, and explicit feedback preferences.

== Problem <problem>

Delivering such individualized feedback manually becomes unmanageable with large student bodies. Cohorts exceed 1000 students in some courses at large universities like TUM, leaving instructors unable to craft individualised feedback for every student's submission. Even with generous teaching-assistant support, the time and cognitive load required to diagnose misconceptions, reference past performance, and suggest actionable next steps for each student are very demanding. This scalability bottleneck forces educators to rely on generic rubrics or minimal pass/fail remarks, diluting the pedagogical impact of feedback.

#TODO[ 
  The last paragraph might be reimagined.
]

LMSs equipped with automated feedback modules—such as Artemis with Athena integration—solve the scalability pillar of the problem by generating feedback automatically based on students' submissions and other metadata, such as rubrics, yet they fall short on personalization. Most current pipelines treat every submission in isolation and disregard information about students' competencies, progress, and preferences. Consequently, the personalization pillar remains unutilized, overlooking the heterogeneity research deems essential for learning effectiveness. Scholars therefore advocate the creation of learner personas and profiles for students to support adaptive feedback and other personalized services @ballantyne2022 @le2009. However, practical methods for automatically deriving and integrating such profiles into feedback algorithms are still underexplored, and explicit mappings between profile data and adaptive feedback strategies are missing @maier2022.

In summary, institutions such as TUM encounter a continual challenge: manual feedback is pedagogically successful yet unscalable, while computerized feedback is scalable but inadequately customized. Addressing this challenge—providing concurrent, prompt, personalized, and scalable feedback remains unresolved.

== Motivation <motivation>
#TODO[
  This thesis tackles the core educational aim articulated by Hattie and Timperley: feedback should reduce the discrepancy between a learner's current performance and the goals set by the instructor @hattie2007. By incorporating learner-specific information into the feedback loop, we aim to close that gap more effectively than generic feedback could.
]

Educational research indicates that personalized feedback increases student engagement, satisfaction, and achievement. Feedback that is personalized to a learner's specific context can significantly enhance engagement and performance @bulut2020 @maier2022 @hatziapostolou2010. When factors such as students' background knowledge, current skill level, participation rate, and preferred learning style are considered when creating the feedback, students report higher satisfaction, engage more deeply, and perform better in exams @bulut2020 @mirmotahari2018. According to the literature review conducted by Maier and Klotz with 39 studies, most reported positive experiences with personalized feedback in education @maier2022. Tailored feedback helps students recognise their strengths, target precise areas for improvement, and chart concrete next steps, fostering self-regulation and deeper engagement. Achieving these outcomes at TUM would not only improve pass rates and grade distributions in large courses, but also enhance students' confidence and autonomy.

Developing the learner profile required for personalised feedback lays the groundwork for an end-to-end personalised learning ecosystem within LMSs. Such profiles can power the automatic recommendation of study materials aligned with individual competency gaps, enable adaptive lecture scheduling, generate practice tasks calibrated to each student's level, and drive intelligent assistants—such as Iris—that use profile data to suggest resources and coach study strategies. Chun #text("et al.", style: "italic") used student input, such as their motivation and background knowledge, to create an LLM-based system that generates personalized, well-structured study plans with clear explanations and controllability through user-centered interactions. The study plan incorporates comprehensive elements, including learning objectives, content selection rationales, conceptual connections across daily and weekly units, and explanations for studying each topic @chun2025. Their results showed that the generated study plan significantly improves usability, explainability, and controllability, and the developed system has the potential to enhance personalized learning and address key challenges in self-directed learning.

These two establises the motivation for the the thesis and the folowing objectives.


== Objectives <objectives>
To address the previously mentioned problems in @problem, motivated by the points mentioned in @motivation, this thesis pursues three complementary research objectives that together establish an end-to-end pipeline for personalised feedback in large-scale online courses.

\
=== Objective 1: Profiling University Students on LMSs. 
The first objective is to design and validate a learner-profiling method that can operate at scale within Artemis. We will (i) define a learner profile schema that respects the following three aspects: competency status, progress, and preferences - this schema would be used to represent the information about the student which would later used to personalise the feedback for; (ii) identify which artefacts—such as submission history, engagement logs, forum posts, chat conversations, and previous assessments—most accurately reflect competencies, progress, and learning preferences; and (iii) compare rule-based feature engineering with large-language-model (LLM) approaches, including LLM-as-profiler pipelines that extract profile vectors from free-text evidence. The outcome will be a flexible profile schema that can be populated automatically and updated incrementally throughout a course.

\
=== Objective 2: Generate Personalised Feedback Utilising the Profile. 
Building on the learner profile and the current automated feedback generation pipeline on Athena, the second objective is to create a feedback generation pipeline that produces individualised, actionable feedback through LLMs. We will: (i) design a multi-stage workflow that feeds the learner profile, the current submission, and the grading rubric into an LLM; and (ii) explore prompting strategies—such as zero-shot and chain-of-thought prompts—to ensure that learner profile cues are effectively incorporated.
\
=== Objective 3: Delivering the Personalised Feedback. 
As a final objective, we want to complement the personalised feedback with an actionable and intuitive interface. We will design a user interface that allows students to understand the feedback easily - where they failed, what they did well, and what they could improve.
\
\
All objectives will be pursued through iterative prototyping and case studies conducted within Artemis and Athena, with evaluation criteria focusing on instructional relevance, computational efficiency, and stakeholder satisfaction.


== Outline
This thesis is structured as follows. @related_work, Related Work, introduces the current state-of-the-art LLM-based feedback generation and adaptive learning methods, trying to profile the students. @requirements, Requirements lists the requirements for the system and visualises the problem space with UML diagrams. @architecture, Architecture, describes the design details of the system. @implementation, Implementation, describes the implementation of the system and explains how the objectives were realised. @user_interviews, User Interviews presents the evaluation results. @summary, Summary, concludes the thesis and provides an outlook for future work.