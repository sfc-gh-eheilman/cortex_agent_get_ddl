# Snowflake "Get Agent DDL" Stored Procedure

A simple SQL Stored Procedure for Snowflake that reverse-engineers the `CREATE OR REPLACE` DDL for a specified Snowflake Agent.

-----

> **:warning: UNOFFICIAL TOOL - USE AT YOUR OWN RISK**
>
> This stored procedure is **not officially supported by Snowflake**. It is a community-provided utility to fill a need I had.
>
> This tool relies on the output of the `DESC AGENT` command, which is not guaranteed to be stable. The command's output or behavior **could change at any time** in future Snowflake releases, which would break this procedure.
>
> Please test this tool thoroughly in a non-production environment before use.

## Overview

As of this writing, Snowflake does not provide a built-in `GET_DDL()` function for Snowflake Agent objects. This makes it difficult to script out agent definitions for version control or to promote them between different environments (e.g., from DEV to PROD).

This SQL Stored Procedure, `GET_AGENT_DDL`, provides this functionality. It works by:

1.  Executing a `DESC AGENT` command on the specified agent.
2.  Capturing the results of that command.
3.  Re-assembling the agent's properties (profile, comment, and specification) into a complete `CREATE OR REPLACE AGENT ...;` DDL string.

## Prerequisites

To create and use this procedure, you will need:

  * A Snowflake account with the Snowflake Agent feature enabled.
  * A role with `USAGE` privileges on the database and schema where you will create this procedure.
  * A role with sufficient privileges to `DESCRIBE` the target agent (e.g., a role with `OWNERSHIP` or `MANAGE AGENT` permissions).

## Installation

Run the following GET_AGENT_DDL.sql to create the `GET_AGENT_DDL` stored procedure in your desired database and schema.


-----

## Usage Example

To get the DDL for an agent, use the `CALL` command. You must provide the **fully qualified agent name** as a string.

### Sample Call

```sql
-- SAMPLE CALL: Must use the fully qualified agent name
CALL GET_AGENT_DDL('SNOWFLAKE_INTELLIGENCE.AGENTS.SNOWFLAKE_ACCOUNT_ASSISTANT');
```

### Example Result

The procedure will return a single string containing the DDL:

| GET\_AGENT\_DDL |
| :--- |
| `CREATE OR REPLACE AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.SNOWFLAKE_ACCOUNT_ASSISTANT WITH PROFILE=$$...profile_content...$$ COMMENT=$$...comment_content...$$;` |

