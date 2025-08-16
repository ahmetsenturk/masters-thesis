#import "/utils/todo.typ": TODO


#pagebreak()

= Implementation
In this chapter, we will describe the implementation of the proposed system. We will explain this objective by objective, referring to Section 1.3. For each objective, we will explain the implementation details, the relation with the previous chapters, what decision we made and why, and the results of the implementation.


== Profiling University Students on LMSs
Profiling university students and creating a learner profile is our first objective in this master's thesis. We wanted to create a learner profile that would respect the following three aspects: (i) competency status of the student, (ii) progress of the student, and (iii) the preferences of the student. Under this subsection, we explain what steps we take to achieve this objective.
\

#TODO[
  Refer to FR 8 here
]

=== Learner Profile Schema
As mentioned in the introduction, we defined the personalised feedback as a feedback that respects the following three aspects of the student: (i) competency status, (ii) progress, and (iii) preferences. Our goal with defining the learner profile was to create a schema that would allow us to capture these three aspects. In the following subsections how we profiled these three aspects.


==== Competencies & Progress
Since competencies and progress are closely related, we will discuss them together under this subsection. The aim was to create a profile that would allow us to generate a feedback that respects student's competencies and progress. Therefore we needed to define a schema that would allow us to capture these two aspects.

The goal was to understand the student's level of mastery and progress, as literature indicates that feedback should covers student's process and mastery @lohr2024. We started with a naive approach of categorizing the students under predefined categories to quickly test if we can differentiate the feedback according to these categories using LLM. We created 3 different personas - high achiever, average student and struggling student. We then listed down their needs and created different prompts for each persona. We then tested this categorization with an example exercise, using these 3 different persona prompts - to test to which degree was the feedback differentiated and was alinging with what we have setup as a persona.


#TODO[
  Put the 3 different personas here.
]

#TODO[
  I should put the example exercise to the appendix. With all the details of the problem statement rubrics etc.
  Also the different prompts for the different personas go to the appendix.
]

After getting successful results, which yield in different feeedback different personas which were meeting the needs of the personas we defined, we moved onto a more sophisticated and more personalised method, in terms of granularity, of calculating the competency status of students automatically via LLM - a method called LLM-as-a-profiler. Since we didn't categorize students under a predefined persona, this approach was more flexible in terms of differentiating students. We followed an iterative approach introducing this method. Started with a simple approach of prompting LLM to extract the strengths and weaknesses of the student's submission.

#TODO[
  Reference to LLM-as-a-profiler here.
]

#TODO[
  How should I present the results of the experiments?
]

#TODO[
  We should put all the prompts and output schemas to the appendix.
]

Then we moved to a more structured way of representing the competencies of the students, using the SOLO taxonomy. SOLO taxonomy is specifically designed to represent the learning process of the students, and it is a very well adopted taxonomy in the literature.

#TODO[
  Explain the SOLO taxonomy here. Give some example output of LLM analysis with the SOLO taxonomy as the schema.
  Reference SOLO taxonomy.
]

After the experiments with the SOLO taxononmy, we moved from SOLO taxonomy to Bloom's taxonomy - which was organic transition since it is very well adopted in the literature and also was adopted by Artemis as well. With this shift, we also changed our shifts from analysing the student's submission to understand what the required competencies are, to analysing the student's submission according to the Bloom's taxonomy competencies that are already linked to the exercise, since Artemis already supoorts defining competencies of type Bloom's taxonomy and map them to the exercises. However, since Athena can and should work with any other LMS as well, we implemented a mechanism to extract the competencies from the exercise metadata as a fallback strategy.

Finally, we extended the schema to include the progress of the student regarding the competencies. So in the schema, we pictured student's comptency progress, which would capture the student's progress comparison as the previous and current submission. 


==== Preferences
Third and the last aspect of the learner profile is the preferences of the student. Preferences refer to the student's preferences regarding how they want to receive the feedback, so they refer to the dimensions that would explicitly set by the students. We followed a hybrid approach to identify the possible preference dimensions, (i) we did a literature review to identify the most common dimensions and (ii) we experimented with different intuitive dimensions that are relevant for the feedback.

To start with, we used the previously mentioned student personas, and defined the preferences of each persona differently. After observing the feedback generated for each persona was alining with the persona's feedback preferences, we moved to a more structured way of representing the preferences of the students.

#TODO[
  Put a table of three different preferences for each persona.
]

Then we converted these preferences into dimensions, meaining allowing students to set their level of preference for each dimension. The first dimensions were the following: (i) detail of the feedback, (ii) practicality of the feedback, (iii) hint style, and (iv) ending of the feedback. We started with a boolean representation for each dimension to represent the each end of the spectrum. For the (i) detail of the feedback, two ends of the spectrum were: (1) brief feedback, (2) detailed feedback. For the (ii) practicality of the feedback: (1) practical feedback, (2) theoretical feedback. For the (iii) hint style: (i) alternative hints, (ii) standard hints. Finally for the (iv) ending of the feedback: (i) feedback that ends with a summary, (ii) feedback that asks a follow-up question at the end.


After conducting experiments, more literature review, and user interviews (see section 6) with the above setup and observing that some of the dimensions were not well understood by the students, we transitioned into the following dimensions: (i) detail of the feedback and (ii) tone of the feedback.


=== Input Sources for the Learner Profile
After defining the learner profile schema, our task was to identify the input sources for such a profile, meaning which input signals we can obtain from the LMS or explicitly by the students to profile the students following the schema. We again used a hybrid approach to identify these signals, (i) we did a literature review to identify the most common signals and (ii) we analysed what Artemis offered out of the box. Finally we combined our findings by running experiments to evaluate the quality of the feedback generated.


As previously mentioned in Section 2.2, scholars used various signals to profile the students, such as quiz scores, live-session attendance, forum posts, and submission history. 

== Generating Personalised Feedback Utilising the Profile

After defining the learner profile schema and the input sources for the learner profile, the next step was to integrate the profile into the feedback generation process.

We used a chain-of-thought approach, where in the first step we extracted the student's competency status using the input data, and in the following step, making use of the student's competency status, we generated the personalised feedback. 

#TODO[
  We can create a simple diagram for here
]

Prompting was the key for this objective. We tried many different prompts, arranging inputs differently and injecting the student's profile into the prompt in different ways.

#TODO[
  Put the prompts here.
]

#TODO[
  End feedback schema?
]



== Delivering the Personalised Feedback

Displaying the personalised feedback on the LMS and delivering it to the students was our last objective, which complements the two previous objectives. Since Artemis already was providing either automated or manual feedback, there was already a feedback display on the platform. Our objective was to come up with a design which would meet our requirements, to identify the problems and missing features with the current versiom comparing to our vision, and to propose & implement a new feedback component for Artemis.

=== How should a personalised feedback look like?

According to Hattie and Timperley, the feedback should be actionable, understandable, and should be aligned with the student's needs @hattie2007. This should also apply to how feedback is delivered to the students. While the content of the feedback is important, the way it is delivered is also important. In the context of this thesis, we defined that a feedback should be delivered in a way that is (i) actionable (i.e., students should be able to understand what is the next step they should take) and (ii) interpretable (i.e., students )

#TODO[
  Refer to FR 12 here
]



2. What are the problems with the current version?

- Color coding
- Not immediately understandable
- Not very actionable
- Not uniformed accross exercise types - no uniform design system 
- Redundant code snippets and components

3. Implementation/Refactoring of the feedback component

- What I came up with and how as well, we can make use of the graph on Artemis documentation showing how UI/UX development should look like.
- We can also put the intermediate results here, how we incrementally developed feedback component.

For the implementation we should come up with some diagrams, component classes, talk a bit technical here. 