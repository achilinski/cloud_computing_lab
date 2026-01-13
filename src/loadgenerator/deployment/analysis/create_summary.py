import pandas as pd
from pathlib import Path

base_dir = Path("../results")
all_summaries = []

for clients_dir in base_dir.iterdir():
    if not clients_dir.is_dir():
        continue

    clients = int(clients_dir.name)
    dfs = []

    for csv_file in clients_dir.glob("*/example_stats.csv"):
        ip = csv_file.parent.name
        df = pd.read_csv(csv_file)
        df["ip"] = ip
        df["clients"] = clients
        dfs.append(df)
        print(f"Loaded {csv_file}")

    if not dfs:
        continue

    merged_df = pd.concat(dfs, ignore_index=True)

    summary = {
        "clients": clients,
        "overall_request_count": merged_df["Request Count"].sum(),
        "overall_failure_count": merged_df["Failure Count"].sum(),
        "average_response_time": (
            (merged_df["Average Response Time"] * merged_df["Request Count"]).sum()
            / merged_df["Request Count"].sum()
        ),
        "min_response_time": merged_df["Min Response Time"].min(),
        "max_response_time": merged_df["Max Response Time"].max(),
    }
    all_summaries.append(summary)

summary_df = pd.DataFrame(all_summaries).sort_values("clients")

summary_file = Path("summary.csv")
summary_df.to_csv(summary_file, index=False)

print(summary_df)
