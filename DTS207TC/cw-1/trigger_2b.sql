-- trigger function
create or replace function update_avg_score() returns trigger
language plpgsql
as $$
    begin
        with score as (
            select class_id, avg(score) as average_score
            -- need `classes` and left join to consider _all_ `class_id`s
            -- this is in case when rows are deleted from `grades`
            from classes left join students using (class_id)
                left join grades using (student_id)
            group by class_id)
        update classes as c
        set average_score = s.average_score
        from score as s where c.class_id = s.class_id;
        return null;
    end;
$$;

create or replace trigger tr_update_grades
    after insert or delete or update of student_id, score on grades
    execute function update_avg_score();