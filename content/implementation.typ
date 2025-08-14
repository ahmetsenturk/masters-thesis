#pagebreak()

= Implementation
In this chapter, we will describe the implementation of the proposed system. We will explain this objective by objective, referring to Section 1.3. For each objective, we will explain the implementation details, the relation with the previous chapters, what decision we made and why, and the results of the implementation.



== Profiling University Students on LMSs
Profiling university students and creating a learner profile is our first objective in this master's thesis. Under this subsection, we explain what steps we take to achieve this ojective.
\

=== Input Sources
Talk about the input sources, and how we extracted these input sources and collected the data to be sent to Athena. Put the DTO schema here!
Refer to the requirements. 

=== Learner Profile Schema
How we wanted to model the student's profile for which we would personalise the feedback


==== Preferences
Here we have to talk about the different dimensions and the prompts for these preferences.
Mention how we represented these preferences - as a boolean, int,.

We should also talk about the interface here, how we designed an intuitive interface, again iteratively just like we did with the feedback component. Refer to requirements.


- Detail of the feedback
- Tone of the feedback
- Use of examples
- Use of explanations
- Solution style
- Ending of the feedback

==== Competencies

Here 2 things are important:
- How we modeled the competencies of the students:
  - SOLO taxonomy
  - Bloom's taxonomy

- How we extracted the competencies from the student's submissions:
  - *Predifined categories of for the students to fit:* We started with a naive approach of categorizing the students under predefined categories to quickly test if we can differentiate the feedback according to these categories using LLM. We create 3 different personas - high achiever, average student and struggling student. We then listed down their needs and created different prompts for each persona. We then tested this categorization with an example exercise, using these 3 different persona prompts - to test to which degree was the feedback differentiated and was alinging with what we have setup as a persona.
  - *LLM as profiler*



== Generating Personalised Feedback Utilising the Profile

I think here mostly about the prompt engineering. Chain-of-thoughts, how to inject, how to organize the inputs in the prompt.


== Delivering the Personalised Feedback

User interface.
- Problems with the current version
- How should a personalised feedback look like? Refert to requirements.
- What I came up with and how as well, we can make use of the graph on Artemis documentation showing how UI/UX development should look like.
- We can also put the intermediate results here, how we incrementally developed feedback component.

For the implementation we should come up with some diagrams, component classes, talk a bit technical here. 