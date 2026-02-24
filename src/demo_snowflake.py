"""Snowflake Python demo handler that populates a random-data table."""

from datetime import datetime, timezone
import random
import uuid


def run(session):
    table_name = "ANALYTICS_PROD.PYTHON.DEMO_RANDOM_DATA"
    run_id = str(uuid.uuid4())
    row_count = 25

    session.sql(
        f"""
        CREATE TABLE IF NOT EXISTS {table_name} (
            run_id STRING,
            row_num NUMBER,
            category STRING,
            value NUMBER(10, 2),
            created_at TIMESTAMP_NTZ
        )
        """
    ).collect()

    now_utc = datetime.now(timezone.utc).replace(tzinfo=None)
    rows = []
    for i in range(1, row_count + 1):
        rows.append(
            (
                run_id,
                i,
                random.choice(["A", "B", "C"]),
                round(random.uniform(10, 1000), 2),
                now_utc,
            )
        )

    df = session.create_dataframe(
        rows, schema=["RUN_ID", "ROW_NUM", "CATEGORY", "VALUE", "CREATED_AT"]
    )
    df.write.mode("append").save_as_table(table_name)

    total_rows = session.sql(f"SELECT COUNT(*) FROM {table_name}").collect()[0][0]
    return {
        "table": table_name,
        "run_id": run_id,
        "inserted_rows": row_count,
        "total_rows": int(total_rows),
    }
