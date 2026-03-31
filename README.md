## Healthcare Data Exchange Governance and Lineage

### Description
Healthcare organizations exchange data with external partners such as health information exchanges, registries, research programs, and analytics vendors. During audits or compliance reviews, they need to show where shared data originated, which agreements authorized the exchange, how integrations were implemented, and which data elements were transmitted.

This repository reconstructs that lineage using contract metadata, implementation records, interface configuration, and data element mappings. The goal is to identify where implemented integrations diverge from contractual authorization and to surface governance gaps that need review.

### Objectives
- Reconcile contract records with implementation projects
- Reconstruct implementation lineage across governance systems
- Map authorized data elements to the fields exposed through interfaces
- Identify interfaces operating without documented contract authority
- Produce a traceability matrix suitable for governance and audit review

### Modeled Source Systems
- Contract Registry (`Conga`-style contract metadata)
- Project / Intake Registry (`ServiceNow`-style implementation tracking)
- Governance Catalog (`Collibra`-style metadata catalog)
- Interface Metadata / API Registry
- Data Element Dictionary with `HL7` and `FHIR` mappings

### Repository Structure
- `data/` — Synthetic source tables and derived reconciliation outputs
- `sql/` — Schema definitions, reconciliation queries, and audit validation logic
- `notebooks/` — Python scripts used to reconstruct lineage and detect governance gaps
- `governance/` — Traceability matrices and governance catalog examples
- `pipelines/` — Example ingestion configuration

### Key Governance Questions
- Which interfaces are active but lack documented contract authority?
- Which contracts do not map to an implementation project?
- Which data elements are exposed through interfaces but not explicitly authorized?
- Which external partners receive data through endpoints with incomplete governance documentation?
- Which integrations should be reviewed before a compliance or privacy audit?

### Project Outputs
- Contract → Project → Interface traceability matrix
- Authorized versus implemented data element reconciliation
- Identification of orphaned interfaces
- Governance coverage metrics across integrations
- Exception reporting for audit and remediation planning

### Technologies
- SQL
- Python
- Power BI
- Healthcare interoperability concepts (`HL7`, `FHIR`, `EDI`)
- Data governance and data provenance modeling

### Author
Vincent Petro
