import pandas as pd
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
DATA = BASE / "data"
GOV = BASE / "governance"


def read_csv(path):
    if not path.exists():
        raise FileNotFoundError(path)
    return pd.read_csv(path)


contracts = read_csv(DATA / "contracts.csv")
projects = read_csv(DATA / "projects.csv")
interfaces = read_csv(DATA / "interfaces.csv")
data_elements = read_csv(DATA / "data_elements.csv")
authorized = read_csv(DATA / "authorized_data_elements.csv")
implemented = read_csv(DATA / "interface_data_elements.csv")


 normalize interface active flag
if "active_flag" in interfaces.columns:
    interfaces["active_flag"] = interfaces["active_flag"].astype(str).str.upper().isin(["Y", "TRUE", "1"])


 contract -> project -> interface chain
trace = (
    contracts
    .merge(projects, on="contract_id", how="left")
    .merge(interfaces, on="project_id", how="left")
)


 implemented data element detail
impl_detail = (
    implemented
    .merge(data_elements, on="data_element_id", how="left")
    .merge(interfaces[["interface_id", "project_id", "endpoint_name"]], on="interface_id", how="left")
    .merge(projects[["project_id", "contract_id"]], on="project_id", how="left")
)

impl_detail = impl_detail.merge(
    authorized,
    on=["contract_id", "data_element_id"],
    how="left"
)

impl_detail["authorization_status"] = impl_detail["authorization_status"].fillna("Not Authorized")


 traceability matrix
traceability_matrix = trace[
    [
        "contract_id",
        "partner_name",
        "project_id",
        "servicenow_ticket",
        "interface_id",
        "endpoint_name",
        "message_standard",
        "source_system",
        "destination_partner",
        "active_flag",
    ]
].copy()

traceability_matrix["traceability_status"] = "Traceable"
traceability_matrix.loc[traceability_matrix["project_id"].isna(), "traceability_status"] = "Missing Project"
traceability_matrix.loc[traceability_matrix["interface_id"].isna(), "traceability_status"] = "Missing Interface"


 unauthorized data elements
unauthorized = impl_detail[
    impl_detail["authorization_status"] == "Not Authorized"
].copy()


 orphan projects
orphan_projects = projects[
    projects["contract_id"].isna()
].copy()


 orphan interfaces
orphan_interfaces = interfaces.merge(
    projects[["project_id", "contract_id"]],
    on="project_id",
    how="left"
)

orphan_interfaces = orphan_interfaces[
    orphan_interfaces["active_flag"] & orphan_interfaces["contract_id"].isna()
].copy()


 contract coverage
coverage = (
    traceability_matrix
    .groupby(["contract_id", "partner_name"], dropna=False)
    .agg(
        project_count=("project_id", "nunique"),
        interface_count=("interface_id", "nunique")
    )
    .reset_index()
)

coverage["project_count"] = coverage["project_count"].fillna(0)
coverage["interface_count"] = coverage["interface_count"].fillna(0)

coverage["coverage_flag"] = coverage.apply(
    lambda r: "Complete"
    if r["project_count"] > 0 and r["interface_count"] > 0
    else "Needs Review",
    axis=1
)


 write outputs
GOV.mkdir(exist_ok=True)

traceability_matrix.to_csv(GOV / "traceability_matrix.csv", index=False)
unauthorized.to_csv(GOV / "unauthorized_data_elements.csv", index=False)
orphan_projects.to_csv(GOV / "orphan_projects.csv", index=False)
orphan_interfaces.to_csv(GOV / "orphan_interfaces.csv", index=False)
coverage.to_csv(GOV / "contract_coverage_summary.csv", index=False)


print("Generated governance outputs:")
for f in sorted(GOV.glob("*.csv")):
    print("-", f.name)