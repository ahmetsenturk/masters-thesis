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
  response: "..."
)

#feedback(
  feedback: "Activity Diagram - Give the diagram a specific activity title, show where Athena obtains exercise competencies by modeling exercise, and place shared objects on the diagram's edge showing both Athena and Artemis can access them. Consider presenting animated top-level architecture used in iPraktikum instead of activity diagram in the presentation.",
  response: "..."
)

#feedback(
  feedback: "Onboarding Interface - Maybe it is better to incorporate negative examples as well as positives; clarify the effect of “skip”, maybe  rephrase it and/or provide a small “Mix of both” option without an example that then results in neutral.",
  response: "..."
)

#feedback(
  feedback: "Feedback Component Mock-ups - They look greati would be great to implement them. Make sure that the color coding is consistent with the programming exercise feedback thresholds. Consider adding a new type such as “Missing” to differentiate between missing and incorrect answers. Also re-think use of colors, inspired by Athena Playground, as it can get quite colorful.",
  response: "..."
)

#feedback(
  feedback: "Presentation Text - Double check the grammar (e.g., “Why not every feedback is individualised?“ sounds like a grammatical mistake), and use American English instead of British English.",
  response: "..."
)

#feedback(
  feedback: "Presentation Flow - The storyline breaks when showing the Analysis Object Model. You could for instance use “Let's now see how this works in the AOM” to better embed the AOM in your story. Overall, the logical order of slides can be improved: Use Cases, AOM, Top Level Architecture",
  response: "..."
)

#feedback(
  feedback: "Demo & Feedback Content - Motivating feedback is great idea, but don't exaggerate it, don't say “fantastic improvement“ although just 50% of the points are achieved, better suited “good job“",
  response: "..."
)