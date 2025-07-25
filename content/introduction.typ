#import "/utils/todo.typ": TODO

= Introduction
How can universities ensure that every student—from first-year newcomers to international postgraduates—receives feedback that is personal, even as enrolments swell into the tens of thousands? This challenge sits at the centre of contemporary higher education: scaling instruction to ever-growing cohorts while preserving the personal touch that makes feedback transformative.

Over the past decade, digital learning platforms powered by artificial intelligence (AI) have revolutionized the delivery of instruction, propelling a shift from teacher-centered to student-centered paradigms, such as flipped classroom approach @monaco2007 @ozdamli2016. In this new landscape, learners engage more actively, direct their own studies, and expect learning experiences that recognise their individual circumstances. 

As the center of the education shifts from teacher to student, feedback's role today is even more important than before for this evolution to be maintained. When students are given with take-home tasks and are expected to be proactive, they require a validation, a feedback on their submissions—not only in the form of a grade or correction. A high-quality feedback can facilitate skill development, encourage self-reflection, and prompt self-regulated learning for students, enhancing their overall educational outcomes and reduce the discrepancies between current understandings/performance and a desired goal @hattie2007 @shute2008.

Current Learning Management Systems (LMSs) are already adopting this shift as they allow students to follow the course in their own pace, watching lectures, performing the exercise, etc. Some of them also provide automated features that support instructors in effectively engaging large numbers of students, like automated feedback generation @turnbull2021. Artemis is on of these LMSs. Created at Technical University of Munich, Artemis is a platform for interactive learning that offers automated feedback @krusche2018. Artemis allows lecturers to organize their courses by scheduling lectures, exercises, and quizzes. The Athena module in Artemis automates the feedback process, providing timely, structured comments and freeing instructors of tedious grading responsibilities @schwind2023 @dietrich2023.

However, even advanced automation fails to address an important concern: How can feedback be personalized to students' competencies, progress, and preferences? Current systems, even the ones with automated processes, use a uniform feedback generation pipelines that overlook variations in students' competencies, progress, and preferences. Research indicates that generic signals are likely to be disregarded or, worse, misread, while feedback that personalized to a learner's specific context can significantly enhance engagement and performance @bulut2020 @maier2022 @hatziapostolou2010. Bringing together the disparity between scale and personalization is hence both an educational necessity and a technological problem.




== Problem
Educational research indicates that personalized feedback increases student engagement, satisfaction, and achievement.  When factors such as students' background knowledge, current skill level, participation rate, and preferred learning style are taken into account when creating the feedback, students report higher satisfaction, engage more deeply, and perform better in exams @bulut2020 @mirmotahari2018. According to the literature review conducted by Maier and Klotz with 39 studies, most reported positive experiences with personalized feedback in education @maier2022.

Delivering such individualized feedback manually, however, becomes unmanageable with large student bodies. Cohorts exceed 1000 students in some courses at large universities like TUM, leaving instructors unable to craft bespoke feedback for students' each and every submission. Even with generous teaching-assistant support, the time and cognitive load required to diagnose misconceptions, reference past performance, and suggest actionable next steps for each student are very demanding. This scalability bottleneck forces educators to rely on generic rubrics or minimal pass/fail remarks, diluting the pedagogical impact of feedback.

LMSs equipped with automated feedback modules—such as Artemis with Athena integration—solve the scalability pillar of the problem by generating feedback automatically based on students' submission and other metadata such as rubrics, yet they fall short on personalization. Most of the current pipelines treat every submission in isolation and disregard information about students' competencies, progress, and preferences. As a consequence, personalization pillar still remains not utilized, overlooking the heterogeneity that research deems essential for learning effectiveness. Scholars therefore advocate the creation of learner personas and profiles for students to support adaptive feedback and other personalized services @ballantyne2022 @le2009, but practical methods for automatically deriving such profiles and integrating them into feedback algorithms are still under-explored. Future work must establish explicit mappings between profile data and adaptive feedback strategies @maier2022.

In summary, institutions such as TUM encounter a continual challenge: manual feedback is pedagogically successful yet unscalable, while computerized feedback is scalable but inadequately customized. Addressing this challenge—providing feedback that is concurrently prompt, personalized, and scalable—continues to be an unresolved issue.



== Motivation
This thesis tackles the core educational aim articulated by Hattie and Timperley: feedback should reduce the discrepancy between a learner's current performance and the goals set by the instructor @hattie2007. By incorporating learner-specific information into the feedback loop, we aim to close that gap more effectively than generic feedback could.

Research consistently shows a strong positive correlation between personalized feedback and both academic performance and learner satisfaction @bulut2020 @mirmotahari2018 @maier2022. Tailored feedback helps students recognise their strengths, target precise areas for improvement, and chart concrete next steps, thereby fostering self-regulation and deeper engagement. Achieving these outcomes at TUM would not only improve pass rates and grade distributions in large courses, but also enhance students' confidence and autonomy.

Developing the learner profile required for personalised feedback lays the groundwork for an end-to-end personalised learning ecosystem within LMSs. Such profiles can power the automatic recommendation of study materials aligned with individual competency gaps, enable adaptive lecture scheduling, generate practice tasks calibrated to each student's level, and drive intelligent assistants—such as Iris—that use profile data to suggest resources and coach study strategies.

Reference the following paper in above paragraph: @hu2024

Personalised automation also alleviates instructor workload by reducing repetitive grading and clarifying where human intervention is most needed. Tutors can concentrate on high-impact mentoring moments—such as live tutoring sessions—while routine feedback is delivered automatically. Institutions, in turn, gain a scalable mechanism for improving learning outcomes and student satisfaction metrics without proportionally increasing staffing costs.

Collectively, these motivations underscore the value of the proposed research: a feasible pathway toward feedback that is simultaneously personalised, impactful, and scalable.


== Objectives
This thesis pursues two complementary research objectives that together establish an end-to-end pipeline for personalised feedback in large-scale online courses.

\
#text(weight: "bold")[Objective 1: Profiling university students on LMSs.] The first objective is to design and validate a learner-profiling method that can operate at scale within Artemis. We will: (i) identify which artefacts—such as submission history, engagement logs, forum posts, chat conversations, and previous assessments—most accurately reflect competencies, progress, and learning preferences; (ii) determine which preference dimensions (e.g., preferred level of detail, use of examples, explanation style) should be collected explicitly from students and devise lightweight elicitation instruments such as Likert-style sliders or pairwise surveys; and (iii) compare rule-based feature engineering with large-language-model (LLM) approaches, including LLM-as-profiler pipelines that extract profile vectors from free-text evidence. The outcome will be a flexible profile schema that can be populated automatically and updated incrementally throughout a course.

\
#text(weight: "bold")[Objective 2: Utilising the profile to generate personalised feedback.] Building on the learner profile, the second objective is to create a feedback-generation pipeline that produces individualised, actionable feedback through generative AI. We will: (i) design a multi-stage workflow that feeds the profile, the current submission, and the grading rubric into an LLM; (ii) explore prompting strategies—such as zero-shot and chain-of-thought prompts—to ensure that profile cues are effectively incorporated; (iii) specify an output schema (e.g., JSON containing rationale, identified strengths, weaknesses, and next-step guidance) that integrates seamlessly with Athena; and (iv) evaluate the resulting feedback both quantitatively (rubric alignment, coverage of profile cues) and qualitatively (student surveys) against the baseline.

Both objectives will be pursued through iterative prototyping and case studies conducted within Artemis and Athena, with evaluation criteria focusing on instructional relevance, computational efficiency, and stakeholder satisfaction.


== Outline
