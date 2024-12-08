create table inputTable
(
    input text
);
copy inputTable from 'input.txt';

create function input_target(input text) returns bigint as
$$
select split_part(input, ':', 1)::bigint;
$$ language sql;

create function input_values(input text) returns bigint[] as
$$
select string_to_array(substr(input, strpos(input, ':') + 2, length(input)), ' ')::bigint[];
$$ language sql;

create function operator_product(operator_count int)
    returns table
            (
                result_sequence text[]
            )
as
$$
begin
    return query
        with recursive product(sequence, depth) as (select array []::text[], 0 as depth
                                                    union all
                                                    select p.sequence || array [o.op], p.depth + 1
                                                    from product p,
                                                         (select '+' as op union all select '*' as op) o
                                                    where p.depth < operator_count)
        select sequence
        from product
        where depth = operator_count;
end;
$$ language plpgsql;

create function eval(val_array bigint[], operators text[]) returns bigint as
$$
declare
    result bigint;
begin
    result := val_array[1];
    for i in 1..array_length(val_array, 1) - 1
        loop
            if operators[i] = '+' then
                result := result + val_array[i + 1];
            elsif operators[i] = '*' then
                result := result * val_array[i + 1];
            else
                RAISE exception 'Unsupported operator: %', operators[i];
            end if;
        end loop;
    return result;
end;
$$ language plpgsql;

do
$$
    declare
        rec       record;
        operators text[];
        counter   bigint;
    begin
        counter := 0;

        for rec in
            select input_target(input) as target,
                   input_values(input) as values
            from inputTable
            loop
                for operators in
                    select result_sequence
                    from operator_product(array_length(rec.values, 1) - 1)
                    loop
                        if eval(rec.values, operators) = rec.target
                        then
                            counter := counter + rec.target;
                            exit;
                        end if;
                    end loop;
            end loop;

        raise notice 'Result: %', counter;
    end
$$;

drop function input_target;
drop function input_values;
drop function operator_product;
drop function eval;
drop table inputTable;
