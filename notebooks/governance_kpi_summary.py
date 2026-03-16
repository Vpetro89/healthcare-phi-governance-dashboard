import pandas as pd
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
GOV = BASE / "governance"


def load_csv(file_name):
    file_path = GOV / file_name
    if not file_path.exists():
        raise FileNotFoundError(f"Required file not found: {file_path}")
    return pd.read_csv(file_path)


trace = load_csv("traceability_matrix.csv")
unauth = load_csv("unauthorized_data_elements.csv")
orph_proj = load_csv("orphan_projects.csv")
orph_int = load_csv("orphan_interfaces.csv")
coverage = load_csv("contract_coverage_summary.csv")


def safe_nunique(df, column):
    return df[column].dropna().nunique() if column in df.columns else 0


def safe_len(df):
    return len(df) if df is not None else 0


contracts_modeled = safe_nunique(trace, "contract_id")
projects_modeled = safe_nunique(trace, "project_id")
interfaces_modeled = safe_nunique(trace, "interface_id")

unauthorized_elements = safe_len(unauth)
orphan_projects = safe_len(orph_proj)
orphan_interfaces = safe_len(orph_int)

contracts_needing_review = 0
if "coverage_flag" in coverage.columns:
    contracts_needing_review = int(
        coverage["coverage_flag"].eq("Needs Review").sum()
    )


summary = pd.DataFrame(
    [
        {"metric": "contracts_modeled", "value": contracts_modeled},
        {"metric": "projects_modeled", "value": projects_modeled},
        {"metric": "interfaces_modeled", "value": interfaces_modeled},
        {"metric": "unauthorized_data_elements", "value": unauthorized_elements},
        {"metric": "orphan_projects", "value": orphan_projects},
        {"metric": "orphan_interfaces", "value": orphan_interfaces},
        {"metric": "contracts_needing_review", "value": contracts_needing_review},
    ]
)


output_file = GOV / "governance_kpi_summary.csv"
summary.to_csv(output_file, index=False)

print(summary)