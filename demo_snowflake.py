"""Minimal Snowflake Python handler loaded from this Git repository."""


def run(session):
    row = session.sql(
        "select current_account(), current_region(), current_version(), current_timestamp()"
    ).collect()[0]

    return {
        "account": row[0],
        "region": row[1],
        "snowflake_version": row[2],
        "executed_at": str(row[3]),
    }
