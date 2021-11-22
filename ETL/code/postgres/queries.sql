

-- tables_name
select tablename from pg_catalog.pg_tables where schemaname != 'pg_catalog' and schemaname != 'information_schema';

-- table_columns
select column_name, udt_name, is_nullable, character_maximum_length from information_schema.COLUMNS where TABLE_NAME = '${table}' order by ordinal_position;

-- table_pks
select key_column from (select kcu.table_schema,kcu.table_name,tco.constraint_name,tco.constraint_type,kcu.ordinal_position as position,kcu.column_name as key_column
from information_schema.table_constraints tco
join information_schema.key_column_usage kcu on kcu.constraint_name = tco.constraint_name and kcu.constraint_schema = tco.constraint_schema and kcu.constraint_name = tco.constraint_name
where tco.constraint_type = 'PRIMARY KEY' order by kcu.table_schema,kcu.table_name,position) as X where table_name = '${table}';

-- table_fks
select distinct tc.constraint_name,kcu.column_name,ccu.table_name as foreign_table_name,ccu.column_name as foreign_column_name
from information_schema.table_constraints as tc 
join information_schema.key_column_usage as kcu on tc.constraint_name = kcu.constraint_name and tc.table_schema = kcu.table_schema
join information_schema.constraint_column_usage as ccu on ccu.constraint_name = tc.constraint_name and ccu.table_schema = tc.table_schema
where tc.constraint_type = 'FOREIGN KEY' and tc.table_name = '${table}';

-- table_row_count
select count(*) from ${table};

-- dag
select distinct tc.table_name,ccu.table_name as foreign_table_name from information_schema.table_constraints as tc
join information_schema.key_column_usage as kcu on tc.constraint_name = kcu.constraint_name and tc.table_schema = kcu.table_schema
join information_schema.constraint_column_usage as ccu on ccu.constraint_name = tc.constraint_name and ccu.table_schema = tc.table_schema
where tc.constraint_type = 'FOREIGN KEY';

-- select_all
select * from ${table};

-- select_ids
select ${id} from ${table};

-- select_conditional
select * from ${table} where ${conditions};

-- single_insert
insert into ${table} (${cols_name}) values (${cols_value});

-- delete_conditional
delete from ${table} where ${conditions};

-- update_conditional
update ${table} set ${update_sets} where ${conditions};

-- version_trigger_func
CREATE FUNCTION version_trigger_${safe_table}() RETURNS trigger AS
$$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF ${conflict_condition}
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
 
        UPDATE  ${table}
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   ${new_id_condition}
            AND current_timestamp <@ __valid;
 
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
 
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO ${table} (${id_cols}, __valid, ${other_cols})
            VALUES (${id_cols_value},
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                ${other_cols_value});
 
        RETURN NEW;
    END IF;
 
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  ${table}
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE ${old_id_condition}
            AND current_timestamp <@ __valid;
 
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- version_trigger
CREATE TRIGGER ${safe_table}_trig
    INSTEAD OF INSERT OR UPDATE OR DELETE
    ON ${safe_table}_recent
    FOR EACH ROW
    EXECUTE PROCEDURE version_trigger_${safe_table}();

-- recent_view
CREATE VIEW ${safe_table}_recent AS
    SELECT  ${cols}
    FROM    ${table}
    WHERE   current_timestamp <@ __valid;

-- historic_view
CREATE VIEW ${safe_table}_historic AS
    SELECT  ${cols}
    FROM    ${table}
    WHERE   current_setting('timerobot.as_of_time')::timestamptz <@ __valid;

-- set_versioning_time
SET timerobot.as_of_time = '${time}';

-- btree_extension
CREATE EXTENSION IF NOT EXISTS btree_gist;