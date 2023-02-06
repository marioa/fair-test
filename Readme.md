# FAIR Test Repository

This is a target end point for FAIR testing software to try and evaluate how easy/expensive it is to get a fully compliant repository that observes the FAIR principles.

## FAIR principles for data and software

From [Lamprecht, Anna-Lena et al. (2020)](https://dx.doi.org/10.3233/DS-190026) we get the FAIR principles as follows.

|       | FAIR for data                                                | FAIR for software                                            | Operation                         |
| ----- | ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------------- |
| F1    | (Meta)data are assigned a globally unique and persistent identifier. | Software and its associated metadata have a global, unique and persistent identifier for each released version. | Rephrased                         |
| F2    | Data are described with rich metadata.                       | Software is described with rich metadata.                    | Rephrased                         |
| F3    | Metadata clearly and explicitly include the identifier of the data it describes. | Metadata clearly and explicitly include identifiers for all the versions of the software it describes. | Rephrased and extended            |
| F4    | (Meta)data are registered or indexed in a searchable resource. | Software and its associated metadata are included in a searchable software registry. | Rephrased                         |
| A1    | (Meta)data are retrievable by their identifier using a standardized communications protocol. | Software and its associated metadata are accessible by their identifier using a standardized communications protocol. | Rephrased                         |
| A1.1  | The protocol is open, free, and universally implementable.   | The protocol is open, free, and universally implementable.   | Remain the same                   |
| A1.2  | The protocol allows for an authentication and authorization procedure, where necessary. | The protocol allows for an authentication and authorization procedure, where necessary. | Remain the same                   |
| A2    | Metadata are accessible, even when the data are no longer available. | Software metadata are accessible, even when the software is no longer available. | Rephrased                         |
| I1    | (Meta)data use a formal, accessible, shared, and broadly applicable language for knowledge representation. | Software and its associated metadata use a formal, accessible, shared and broadly applicable language to facilitate machine readability and data exchange. | Rephrased and extended            |
| I2    | (Meta)data use vocabularies that follow FAIR principles.     | –                                                            | Reinterpreted, extended and split |
| I2S.1 | –                                                            | Software and its associated metadata are formally described using controlled vocabularies that follow the FAIR principles. | Reinterpreted, extended and split |
| I2S.2 | –                                                            | Software use and produce data in types and formats that are formally described using controlled vocabularies that follow the FAIR principles. | Reinterpreted, extended and split |
| I3    | (Meta)data include qualified references to other (meta)data. | –                                                            | Discarded                         |
| I4S   | –                                                            | Software dependencies are documented and mechanisms to access them exist. | Newly proposed                    |
| R1    | (Meta)data are richly described with a plurality of accurate and relevant attributes. | Software and its associated metadata are richly described with a plurality of accurate and relevant attributes. | Rephrased                         |
| R1.1  | (Meta)data are released with a clear and accessible data usage license. | Software and its associated metadata have independent, clear and accessible usage licenses compatible with the software dependencies. | Rephrased and extended            |
| R1.2  | (Meta)data are associated with detailed provenance.          | Software metadata include detailed provenance, detail level should be community agreed. | Rephrased                         |
| R1.3  | (Meta)data meet domain-relevant community standards.         | Software metadata and documentation meet domain-relevant community standards. | Rephrased                         |
