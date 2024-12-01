#import "@preview/mcm-scaffold:0.1.0": *
#import "@preview/mitex:0.2.2": *

#show: mcm.with(
  title: "2024 Mathematical Contest in Modeling (MCM) Summary Sheet",
  problem-chosen: "ABCDEF",
  team-control-number: "1111111",
  year: "2024",
  summary: [
    #include "summary.typ"
  ],
  keywords: [Earth’s Magnetic Field; Sensor; Time Point; Matrix; KDT; HFBNNA.],
  magic-leading: 0.65em,
)
#set par(first-line-indent: 12pt)

= Introduction
== Problem background
#include "introduction.typ"
== Restatement of the Problem
Based on the background information and the constraints outlined in the problem statement, we need to address the following issues:
- How to select the best sensors to represent the magnetic field of a specific time.
- How to perform the selection algorithm efficiently on a large amount of data.
- How to extract the original signal from the data of many sensors and eliminate noises.
== Our work 
Our work is illustrated in #ref(<out-work>).
#figure(caption: "Our work")[#image("flow.svg")] <out-work>
= Assumption and Justifications
Given that practical problems often involve numerous complex factors, the first step is to make reasonable assumptions in order to simplify the model. Each assumption is then followed by a corresponding explanation.
- *Assumption*: The geomagnetic field and magnetic field from a specific objects are uniform in space.
- *Justification*: To make the variation of data be consistent with data from sensors from different unknown locations only uniform magnetic field's model can be established with relative accurate data.
- *Assumption*: The data from the sensors is accurate enough to model the magnetic field.
- *Justification*: The amount of the sensors is large and for the geomagnetic data is nearly consistent.

= Model Establishment
== Data processing 
To speed up data I/O, we first combine all the sensor data into a dictionary format stored in JSON file.
Then, the data is rearranged as a matrix, its dimension is the time stamps, the second dimension represents every
sensors, the final dimension contains data from all channels. 
=== Model for problem 1 & 2 
1) Differential matrix\
#include "dim.typ"


\
2) KD Tree \
#include "kdtree.typ"




#bibliography("references.bib")

#pagebreak()

#heading("Appendix A ", numbering: none, outlined: false)

#include "codes.typ"