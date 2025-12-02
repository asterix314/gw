create or replace view student_course_view as
    select s.name, c.course_name, e.grade, s.gpa
    from enrollment as e
        inner join student as s using (student_id)
        inner join course as c using (course_id)
    order by s.name asc