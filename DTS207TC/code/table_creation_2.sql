-- recreate a class table
drop table if exists classes cascade;
create table classes (
class_id serial primary key, class_name varchar(100) not null, average_score float
);

-- recreate a student table
drop table if exists students cascade;
create table students (
student_id serial primary key, name varchar(100) not null, age int, class_id int, foreign key (class_id) references classes(class_id)
);

-- recreate a grade sheet
drop table if exists grades cascade;
create table grades (
grade_id serial primary key, student_id int, course_id int, score float, foreign key (student_id) references students(student_id)
);

-- insert class data
insert into classes (class_name)
values
('Class A'),('Class B'),('Class C');

-- insert student data
insert into students (name, age, class_id)
values
('Alice', 20, 1),('Bob', 22, 2),('Charlie', 21, 1),('David', 23, 3),('Eve', 24, 2);

-- insert grade data
insert into grades (student_id, course_id, score)
values
(1, 1001, 85.5),(2, 1002, 90.0),(3, 1001, 78.0),(4, 1002, 88.5),(5, 1001, 92.0);