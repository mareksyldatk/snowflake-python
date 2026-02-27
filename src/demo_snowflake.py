"""Snowflake Python demo handler that populates a random-data table."""

from datetime import datetime, timezone
import hashlib
import random
import uuid


def _sha256_hex(value):
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def _get_generic_secret(session, fully_qualified_secret_name):
    return session.sql(
        f"SELECT SYSTEM$GET_GENERIC_SECRET_STRING('{fully_qualified_secret_name}')"
    ).collect()[0][0]


def run(session):
    table_name = "PLATFORM_DEV.PYTHON.DEMO_RANDOM_DATA"
    run_id = str(uuid.uuid4())
    row_count = 25

    session.sql(
        f"""
        CREATE TABLE IF NOT EXISTS {table_name} (
            run_id STRING,
            row_num NUMBER,
            category STRING,
            metric_value NUMBER(10, 2),
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
        rows, schema=["RUN_ID", "ROW_NUM", "CATEGORY", "METRIC_VALUE", "CREATED_AT"]
    )
    df.write.mode("append").save_as_table(table_name)

    total_rows = session.sql(f"SELECT COUNT(*) FROM {table_name}").collect()[0][0]
    client_id = _get_generic_secret(session, "PLATFORM_DEV.SECURITY.CLIENT_ID")
    client_secret = _get_generic_secret(session, "PLATFORM_DEV.SECURITY.CLIENT_SECRET")
    jwt_assertion = _get_generic_secret(session, "PLATFORM_DEV.SECURITY.JWT_ASSERTION")

    return {
        "table": table_name,
        "run_id": run_id,
        "inserted_rows": row_count,
        "total_rows": int(total_rows),
        "secret_hashes": {
            "CLIENT_ID": _sha256_hex(client_id),
            "CLIENT_SECRET": _sha256_hex(client_secret),
            "JWT_ASSERTION": _sha256_hex(jwt_assertion),
        },
    }
