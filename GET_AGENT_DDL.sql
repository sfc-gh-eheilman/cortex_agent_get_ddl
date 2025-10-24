/*
--------------------------------------------------------------------------------------
--  Procedure:  GET_AGENT_DDL
--  Author:     Eric Heilman
--  Version:    1.0.0
--  Purpose:    Reconstructs the DDL for a Snowflake Agent from DESCRIBE output.
--------------------------------------------------------------------------------------

--  SCRIPT RELIES ON INTERNAL METADATA STRUCTURES THAT ARE SUBJECT TO CHANGE
--  AT ANY TIME WITHOUT NOTICE. TEST THOROUGHLY. USE AT YOUR OWN RISK.
--
--------------------------------------------------------------------------------------
*/


CREATE OR REPLACE PROCEDURE GET_AGENT_DDL(AGENT_NAME VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS $$
DECLARE
    DDL_STRING VARCHAR;
    DESC_QUERY_ID VARCHAR; -- Variable to store the specific query ID
BEGIN
    -- 1. Execute the DESCRIBE command
    DESC AGENT IDENTIFIER(:AGENT_NAME);

    -- 2. Capture its Query ID immediately
    DESC_QUERY_ID := LAST_QUERY_ID();

    -- 3. Process the result using the captured ID
    SELECT
        CONCAT_WS(' ',
            'CREATE OR REPLACE AGENT',
            CONCAT_WS('.', "database_name", "schema_name", "name"), -- AGT_NME
            
            
            'WITH PROFILE=' || CHR(36) || CHR(36) || "profile" || CHR(36) || CHR(36), 
            
            
            IFF(NULLIF("comment", '') IS NOT NULL, 'COMMENT=' || CHR(36) || CHR(36) || "comment" || CHR(36) || CHR(36), ''), 
            
            
            IFF(NULLIF("agent_spec", '') IS NOT NULL, 'FROM SPECIFICATION ' || CHR(36) || CHR(36) || "agent_spec" || CHR(36) || CHR(36), '') 
        ) || ';'
    INTO :DDL_STRING -- Capture the final string in our variable
    FROM TABLE(RESULT_SCAN(:DESC_QUERY_ID)); -- Use the specific query ID

    -- 4. Return the variable
    RETURN DDL_STRING;

END;
$$;

