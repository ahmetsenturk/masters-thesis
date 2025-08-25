#import "/layout/feedbacklog_template.typ": *
#import "/metadata.typ": *
#import "/utils/feedback.typ": *

#set document(title: titleEnglish, author: author)

#show: feedbacklog.with(
  titleEnglish: titleEnglish,
  supervisor: supervisor,
  advisors: advisors,
  author: author,
  presentationDate: presentationDate,
  feedbacklogSubmissionDate: feedbacklogSubmissionDate,
)

#feedback(
  feedback: "Analysis Object Model - Keep the AOM abstract: drop technical IDs, rename methods for clarity (e.g., extract()), and clarify if the PersonalizedFeedbackGenerator belongs here; note that system boundaries are optional but acceptable to omit.",
  response: "I have updated the AOM to reflect the requested changes. I updated all the functions and attribute names to be more descriptive and removed the technical IDs. I also removed the PersonalizedFeedbackGenerator from the AOM as it is rather a part of the solution space."
)

#feedback(
  feedback: "Activity Diagram - Give the diagram a specific activity title, show where Athena obtains exercise competencies by modeling exercise, and place shared objects on the diagram's edge showing both Athena and Artemis can access them. Consider presenting animated top-level architecture used in iPraktikum instead of activity diagram in the presentation.",
  response: "Title has been changed to 'Step-by-step: From submission to feedback' and the diagram has been updated to show the shared objects on the edge of the diagram."
)

#feedback(
  feedback: "Onboarding Interface - Maybe it is better to incorporate negative examples as well as positives; clarify the effect of 'skip', maybe rephrase it and/or provide a small 'Mix of both' option without an example that then results in neutral.",
  response: "Negative examples were already added, but was not differentiable because of the previous feedback component design - this problem will be solved once we merge the new feedback component PR. Regarding the other feedback, the onboarding component received positive feedback from the peers and students so that we will keep it as the first version. "
)

#feedback(
  feedback: "Feedback Component Mock-ups - They look great, it would be great to implement them. Ensure the color coding is consistent with the programming exercise feedback thresholds. Consider adding a new type, such as 'Missing,' to differentiate between missing and incorrect answers. Also, re-think use of colors, inspired by Athena Playground, as it can get quite colorful.",
  response: "The feedback component coloring has been updated according to the feedback and communicated with the team. The missing type is added, and the component, in general, is implemented to be easily extended to support more feedback types."
)

#feedback(
  feedback: "Presentation Text - Double check the grammar (e.g., 'Why not every feedback is individualised?' sounds like a grammatical mistake), and use American English instead of British English.",
  response: "Presentation text has been updated accordingly using Grammarly for a sanity check."
)

#feedback(
  feedback: "Presentation Flow - The storyline breaks when showing the Analysis Object Model. You could for instance use 'Let's now see how this works in the AOM' to better embed the AOM in your story. Overall, the logical order of slides can be improved: Use Cases, AOM, Top Level Architecture",
  response: "I updated all the titles of the modeling diagrams to be more descriptive and to fit in the flow of the presentation."
)

#feedback(
  feedback: "Demo & Feedback Content - Motivating feedback is a great idea, but don't exaggerate it, don't say 'fantastic improvement' although just 50% of the points are achieved, better suited to 'good job'",
  response: "Prompts have been updated accordingly in Athena."
)