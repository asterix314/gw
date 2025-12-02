create or replace procedure insert_or_update_student(
    name students.name%type,
    age students.age%type,
    class_id students.class_id%type)
language sql    -- a single `merge` statement would suffice
begin atomic
    with input_row as (
        select name, age, class_id)
    merge into students as s using input_row as i
        on s.name = i.name
    when not matched then
        insert (name, age, class_id) values (i.name, i.age, i.class_id)
    when matched then
        update set age = i.age, class_id = i.class_id;
end