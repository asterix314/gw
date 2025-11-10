drop table if exists student cascade ;
create table student (
    student_id int, -- all ids use the int type
    name text,      -- all character types use the `text` type for flexibility
    gender text,    -- stick to `text` instead of `char` for consistency
    major text,
    gpa float       -- 8-byte floating point arithmetic should suffice
);

insert into student (student_id, "name", gender, major, gpa)
values
    (1,'Alice','F','Computer Science',3.5),
    (2,'Bob','M','Mathematics',3.8),
    (3,'Charlie','M','Physics',3.2),
    (4,'Diana','F','Computer Science',3.9),
    (5,'Ethan','M','Mathematics',3.6),
    (6,'Fiona','F','Physics',3.7),
    (7,'George','M','Computer Science',3.4),
    (8,'Hannah','F','Mathematics',3.3),
    (9,'Ian','M','Physics',3.1),
    (10,'Julia','F','Computer Science',3.0);

drop table if exists course cascade;
create table course (
    course_id int,
    course_name text,
    credits float,    -- use `float` instead of `int` for flexibility
    department text
  );

insert into course (course_id, course_name, credits, department)
values
    (1,'Database Systems',4,'Computer Science'),
    (2,'Calculus',3,'Mathematics'),
    (3,'Quantum Mechanics',5,'Physics'),
    (4,'Operating Systems',4,'Computer Science'),
    (5,'Linear Algebra',3,'Mathematics'),
    (6,'Classical Mechanics',5,'Physics'),
    (7,'Data Structures',4,'Computer Science'),
    (8,'Differential Equations',3,'Mathematics'),
    (9,'Electromagnetism',5,'Physics');

drop table if exists enrollment cascade;
create table enrollment (
    enrollment_id int,
    student_id int,
    course_id int,
    grade float       -- use `float` instead of `int` for flexibility
  );
  
insert into enrollment (enrollment_id, student_id, course_id, grade)
values
    (1,1,1,85.0),   (2,2,2,90.0),   (3,3,3,78.0),   (4,4,1,92.0),
    (5,5,2,88.0),   (6,6,3,85.0),   (7,7,4,80.0),   (8,8,5,82.0),
    (9,9,6,76.0),   (10,10,7,88.0), (11,1,8,90.0),  (12,2,9,85.0),
    (13,3,1,80.0),  (14,4,2,88.0),  (15,5,3,92.0),  (16,6,4,85.0),
    (17,7,5,80.0),  (18,8,6,82.0),  (19,9,7,76.0),  (20,10,8,88.0);