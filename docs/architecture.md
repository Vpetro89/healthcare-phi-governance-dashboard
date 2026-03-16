Architecture Overview

Conceptual Flow

Contract records originate in a contract registry and establish the legal authority for data sharing.

Project implementation records represent the operational work required to enable that exchange. These typically originate from a workflow or ticketing platform that tracks integrations.

Interface metadata describes the actual technical endpoints used to transmit data. Each interface represents a system connection between an internal platform and an external partner.

Authorized data elements define what the contract permits to be shared. These elements are mapped to healthcare interoperability structures such as HL7 segments or FHIR resources.

Implemented interface fields represent what is actually exposed through the interface. These come from interface configuration or data extraction logic.

Reconciliation compares authorized elements against implemented elements. The result is a traceability record showing where governance coverage exists and where gaps remain.

Logical Model

Contract → Project → Interface → Implemented Data Elements

Authorized data elements attach to the contract and define the permitted data scope. Implemented elements from interfaces are reconciled against that scope.

Governance Checks

Active project with no contract reference
Active interface with no linked project
Active endpoint with no contract authority
Implemented data element not authorized by contract
Active interface tied to an expired contract
High-sensitivity data transmitted to external partners

Intended BI Layer

The generated governance outputs can be used as a reporting model in Power BI.

Typical reporting metrics include:

Total contracts represented in the system
Total projects linked to contracts
Total governed interfaces
Number of orphaned interfaces
Number of implemented elements not authorized by contract
Active interfaces grouped by protocol or message standard
External partner exposure by data sensitivity level