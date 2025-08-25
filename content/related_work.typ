#import "/utils/todo.typ": TODO
#pagebreak()
= Related Work <related_work>
Research on personalized, automated feedback can be grouped into two main streams. The first investigates how LLMs can be prompted and constrained to generate pedagogically sound feedback at scale. The second explores learner profiling and adaptive learning, laying the foundations for tailoring the feedback to each student's competency status, progress, and preferences.

== Large Language Models for Feedback Generation
Recent studies have begun to explore how LLMs can be guided to produce pedagogically sound feedback. 

Cohn #text("et al.", style: "italic") use chain-of-thought when evaluating short answers and find more consistent score explanations @cohn2024. Jauhiainen #text("et al.", style: "italic") report near-human agreement when ChatGPT-4 grades and gives feedback on essays, suggesting current LLMs can handle discourse-level quality fairly well @jauhiainen2024. Lohr #text("et al.", style: "italic") test whether GPT-4 can produce specific feedback types (e.g., mistakes, concepts, how-to-proceed) using expert-in-the-loop prompt iterations and clear constraints (like length and scope). Most requests returned the intended type (63/66), though some replies blended types or misjudged progress scores @lohr2024. Dai #text("et al.", style: "italic") find that ChatGPT writes more fluent, detailed summaries of student performance than human instructors, agrees well on topic assessment, and can add process-level advice that may support self-regulated learning @dai2023.

A shared lesson is that context and structure help LLMs to generate better feedback. Pathak and Ria show that adding task-specific rubrics steers models toward the course goals rather than surface correctness @pathak2025 @ria2025. Stamper #text("et al.", style: "italic") argue that future prompt-engineering should pull in multilayered student-model data—knowledge, affect, and metacognition—to reach the level of adaptation offered by classical intelligent-tutoring systems @stamper2024.

#pagebreak()


== Learner Profiling and Adaptive Learning
Work on adaptive learning platforms provides precedents for what kinds of learner data can drive meaningful personalization. 

Kochmar #text("et al.", style: "italic") illustrate that incorporating past interaction metrics—such as the number of attempted questions and historical accuracy—improves the selection of next-step hints @kochmar2020. Cuéllar #text("et al.", style: "italic") expand the signal set to quiz scores, live-session attendance, video-watch percentages, and forum posts; they feed these variables into a GPT-4 prompt that outputs a multi-part feedback message containing motivational, diagnostic, and prescriptive sections styled after popular culture archetypes (e.g., Yoda from Star Wars). Their results show that weekly personalized feedback about their performance helped students show up more, participate more, and finish with higher scores. @cuellar2025. Tang #text("et al.", style: "italic")'s SPHERE system tackles large programming classes by continuously extracting conversation logs, code history, and runtime errors to surface "critical issues" for instructor triage; selected issues are then templated into hints, explanations, or verifications. In a lab study with 20 instructors, SPHERE led to more high-quality feedback being sent (~80% vs ~46% with a baseline) and far fewer incorrect messages (~9% vs ~45%), without taking more time. It also helped instructors turn low-quality drafts into high-quality ones more often. @tang2024.

While previous work leveraged LLMs to generate feedback and, in some cases, incorporated student interaction signals for specific applications, existing approaches fall short of integrating structured learner profiling with automated, scalable feedback generation for online exercises. Our work bridges this gap by combining competency-, progress-, and preference-aware profiles with LLM-driven automated feedback for individualized and scalable feedback.
