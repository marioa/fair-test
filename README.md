# FAIR Test Repository

[![fair-software.eu](https://img.shields.io/badge/fair--software.eu-%E2%97%8F%20%20%E2%97%8F%20%20%E2%97%8B%20%20%E2%97%8F%20%20%E2%97%8B-orange)](https://fair-software.eu)

This is a target end point for FAIR and FAIR4RS metric testing software to evaluate how easy/expensive it is to get a fully compliant repository that complies with the FAIR principles. The `codemeta.json` file was generated using the [codemeta-generator](https://codemeta.github.io/codemeta-generator/).

## FAIR principles for data and research software

From [Lamprecht, Anna-Lena et al. (2020)](https://dx.doi.org/10.3233/DS-190026) modified according to [Chue Hong, N. et al (2022)](https://doi.org/10.15497/RDA00065). In general for software:

* **F: Software, and its associated metadata, is easy for both humans and machines to find.**
* **A: Software, and its metadata, is retrievable via standardized protocols.**
* **I: Software interoperates with other software by exchanging data and/or metadata, and/or through interaction via application programming interfaces (APIs), described through standards.**
* **R: Software is both usable (can be executed) and reusable (can be understood, modified, built upon, or incorporated into other software).**

and in more detail:

|      | FAIR for data                                                | FAIR for software                                            |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| F1   | (Meta)data are assigned a globally unique and persistent identifier. | Software is assigned a globally unique and persistent identifier. |
| F1.1 | -                                                            | Components of the software representing levels of granularity are assigned distinct identifiers. |
| F1.2 | -                                                            | Different versions of the software are assigned distinct identifiers. |
| F2   | Data are described with rich metadata.                       | Software is described with rich metadata.                    |
| F3   | Metadata clearly and explicitly include the identifier of the data it describes. | Metadata clearly and explicitly include the identifier of the software they describe. |
| F4   | (Meta)data are registered or indexed in a searchable resource. | Metadata are FAIR, searchable and indexable.                 |
| A1   | (Meta)data are retrievable by their identifier using a standardized communications protocol. | Software and its associated metadata are accessible by their identifier using a standardized communications protocol. |
| A1.1 | The protocol is open, free, and universally implementable.   | The protocol is open, free, and universally implementable.   |
| A1.2 | The protocol allows for an authentication and authorization procedure, where necessary. | The protocol allows for an authentication and authorization procedure, where necessary. |
| A2   | Metadata are accessible, even when the data are no longer available. | Metadata are accessible, even when the software is no longer available. |
| I1   | (Meta)data use a formal, accessible, shared, and broadly applicable language for knowledge representation. | Software reads, writes and exchanges data in a way that meets domain-relevant community standards. |
| I2   | (Meta)data use vocabularies that follow FAIR principles.     | Software includes qualified references to other objects.     |
| I3   | (Meta)data include qualified references to other (meta)data. | –                                                            |
| R1   | (Meta)data are richly described with a plurality of accurate and relevant attributes. | Software is described with a plurality of accurate and relevant attributes. |
| R1.1 | (Meta)data are released with a clear and accessible data usage license. | Software is given a clear and accessible license.            |
| R1.2 | (Meta)data are associated with detailed provenance.          | Software is associated with detailed provenance.             |
| R1.3 | (Meta)data meet domain-relevant community standards.         | -                                                            |
| R2   | -                                                            | Software includes qualified references to other software.    |
| R3   | -                                                            | Software includes qualified references to other software.    |



## Tools used

Tools used to measure compliance with FAIR:

* [somef](https://github.com/KnowledgeCaptureAndDiscovery/somef)
* [Howfairis](https://github.com/fair-software/howfairis)
* [Fair-enough-metrics](https://github.com/vemonet/fair-enough-metrics)

## Changes

What was required to compy with the metrics.

|       | FAIR  for data | FAIR for software |
| ----- | -------------- | ----------------- |
| F1    |                |                   |
| F1.1  |          -     |                   |
| F1.2  |          -     |                   |
| F2    |                |                   |
| F3    |                |                   |
| F4    |                |                   |
| A1    |                |                   |
| A1.1  |                |                   |
| A1.2  |                |                   |
| A2    |                |                   |
| I1    |                |                   |
| I2    |                |                   |
| I3    |                |   -               |
| R1    |                |                   |
| R1.1  |                |                   |
| R1.2  |                |                   |
| R1.3  |                |                   |
| R2    |          -     |                   |
| R3    |          -     |                   |
