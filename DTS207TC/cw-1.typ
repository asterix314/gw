#import "/assignment.typ": assignment, sol

#show: assignment.with(
  title: [Assessment Task 1 (CW)],
  course: [DTS207TC: Database Development and Design],
  university-logo: image("resource/logo.png", width: 6cm),
  figure-numbering: "1",
)

= Intermediate SQL

== Table Creation (10 marks):

Create tables with suitable data types for students, courses, and course enrollments based on the data in the CSV files.

#sol[See file `table_creation_11.sql`
#raw(read("cw-1/table_creation_11.sql"), lang: "sql", block:true)]

== View Creation (5 marks):

Create a view named `student_course_view` that includes the student's name, course name, grade, and GPA. The results should be sorted by the student's name in ascending order.

#sol[See file `view_creation_12.sql`
#raw(read("cw-1/view_creation_12.sql"), lang: "sql", block: true)]

== Query Execution (5 marks):

Execute a query to retrieve data from the `student_course_view` and provide a screenshot of the query results.

#sol[See @fig_13 for query result.
#figure(
  image("resource/view_13.png", height: 40%),
  caption: [Screenshot of view query result for question 1.3 using `psql` command line tool.],
) <fig_13>]

#set enum(numbering: "(a)")

= Advanced SQL

1. Create a stored procedure called `insert_or_update_student` to insert or update a new student into the student table. The stored procedure requires the student's name, age, and class ID as parameters. (We assume that there will be no students with the same name.) (8 marks)

#sol[See file `insert_or_update_student_2a.sql`. Note that when presented with a non-existent `class_id`, the procedure will give an error because of foreign key violation.

#raw(read("cw-1/insert_or_update_student_2a.sql"), lang: "sql", block: true)]

2. Create a trigger to automatically calculate and update the class average when a grade is inserted or updated in the grades table. The class average is stored in a new field called `average_score` in the class table. (8 marks)

#sol[See file `trigger_2b.sql`. 

#raw(read("cw-1/trigger_2b.sql"), lang: "sql", block: true)]

3. Test your program using the following statements and provide a screenshot of the results. (4 marks)

#sol[See @fig_2c for query result.
#figure(
  image("resource/2c.png"),
  caption: [Screenshot of query result for question 2.c using `psql` command line tool.],
  placement: none,
) <fig_2c>]

= Complex Data Types

1. Create XML DTD that corresponds to the given ER Diagram (the dotted box represents a weak entity). The DTD should be validated using the XML validation tool. (EditiX) (10 marks)

#sol[
```xml
<!DOCTYPE UNIVERSITY [
  <!ELEMENT UNIVERSITY (SECTION+)>

  <!ELEMENT SECTION (STUDENT+)>
  <!ATTLIST SECTION
            Number        CDATA #REQUIRED
            Year          CDATA #REQUIRED
            Qtr           CDATA #REQUIRED
            Course_number CDATA #REQUIRED
            Course_name   CDATA #REQUIRED>

  <!ELEMENT STUDENT EMPTY>   <!-- leaf in the hierarchy -->
  <!ATTLIST STUDENT
            Ssn      CDATA #REQUIRED
            Name     CDATA #REQUIRED
            Class    CDATA #REQUIRED
            Grade    CDATA #REQUIRED>

  <!-- COURSE Weak entity -->
  <!ELEMENT COURSE EMPTY>
  <!ATTLIST COURSE
            Course_number CDATA #REQUIRED
            Course_name   CDATA #REQUIRED>
]>
```

- The root element is `<UNIVERSITY>`, which contains one or more  `<SECTION>` elements.

- Each `<SECTION>` contains one or more `<STUDENT>` elements.

- One-to-Many between `<COURSE>` and `<SECTION>` (a course corresponds to multiple sections).

- One-to-Many between `<SECTION>` and `<STUDENT>` (a section has multiple students).
]

2. Create an XML instance document corresponding to the DTD you have created in the first step. The XML document must have at least one record for every element specified in the DTD. Validate the instance document against the DTD using the XML validation tool. (EditiX) (10 marks)

#sol[The following XML demonstrates multiple sections of the same course (CS101 has sections 101 and 102) and shows students enrolled in multiple courses across different sections.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE UNIVERSITY SYSTEM "university.dtd">
<UNIVERSITY>
    <SECTION Number="101" Year="2024" Qtr="Fall" Course_number="CS101" Course_name="Introduction to Computer Science">
        <STUDENT Ssn="123-45-6789" Name="John Smith" Class="Freshman" Grade="A"/>
        <STUDENT Ssn="234-56-7890" Name="Emily Johnson" Class="Sophomore" Grade="B+"/>
        <STUDENT Ssn="345-67-8901" Name="Michael Brown" Class="Freshman" Grade="A-"/>
    </SECTION>
    
    <SECTION Number="201" Year="2024" Qtr="Fall" Course_number="MATH201" Course_name="Calculus I">
        <STUDENT Ssn="123-45-6789" Name="John Smith" Class="Freshman" Grade="B"/>
        <STUDENT Ssn="456-78-9012" Name="Sarah Davis" Class="Junior" Grade="A"/>
        <STUDENT Ssn="567-89-0123" Name="David Wilson" Class="Sophomore" Grade="B+"/>
    </SECTION>
    
    <SECTION Number="102" Year="2024" Qtr="Fall" Course_number="CS101" Course_name="Introduction to Computer Science">
        <STUDENT Ssn="678-90-1234" Name="Jennifer Lee" Class="Senior" Grade="A-"/>
        <STUDENT Ssn="789-01-2345" Name="Robert Taylor" Class="Freshman" Grade="C+"/>
    </SECTION>
    
    <SECTION Number="301" Year="2024" Qtr="Fall" Course_number="PHYS301" Course_name="Classical Mechanics">
        <STUDENT Ssn="234-56-7890" Name="Emily Johnson" Class="Sophomore" Grade="A"/>
        <STUDENT Ssn="456-78-9012" Name="Sarah Davis" Class="Junior" Grade="B+"/>
        <STUDENT Ssn="890-12-3456" Name="Lisa Anderson" Class="Senior" Grade="A"/>
    </SECTION>
</UNIVERSITY>
```]

= ORM

1. Design a UML class diagram for this application. Specify key attributes of each entity type and structural constraints on each relationship type. Note any unspecified requirements, and make appropriate assumptions to make the specification complete. (10 marks)

#sol[See @fig_4a. Some assumptions and clarifications:

- `Address` composite attribute: To efficiently handle the city, state, and ZIP code requirements for the permanent address, a separate `Address` value object is created. This promotes reusability, as both `currentAddress` and `permanentAddress` can use the same structure.

- `TranscriptEntry` association class: Though not directly mentioned in the question statement, it represents the relationship between a `Student` and a `Section`, recording the outcome (grade). Modeling it as a class allows us to store attributes like `grade`, `semester`, and `year` directly on the relationship.

#figure(
  image("resource/uml_4a.svg", width: 90%),
  caption: [UML class diagram for a university database (Question 4.b)],
) <fig_4a>]

2. Translate the UML class diagram created in the above question (a) into a relational schema. In the relational schema, only use relation name and attribute, e.g., student (name, number, SSN,..etc.) and specify foreign key as fk. (10 marks)

#sol[Below is a simplified relational schema for the UNIVERSITY database:

- `STUDENT (
  student_number, SSN, first_name, last_name, 
  current_address, current_phone, 
  permanent_address, permanent_phone,
  permanent_city, permanent_state,permanent_zip, 
  birth_date, sex, class, 
  major_department (fk), 
  minor_department (fk), 
  degree_program)`

- `DEPARTMENT (
  dept_code, dept_name, office_number, office_phone, college)`

- `COURSE (
  course_number, course_name, 
  description, semester_hours, level, 
  offering_dept (fk))`

- `SECTION (
  course_number (fk), section_number, semester, year)`

- `TRANSCRIPT (
  student_number (fk), course_number (fk), section_number (fk), semester, year, grade)`]

= Data Warehousing

1. State which schema (star, snowflake etc.) is the most appropriate to model the above data warehouse. Give your opinion of which might be more empirically useful and state the reasons behind your answer. (6 marks)

#sol[The *snowflake schema* is most appropriate for the vehicle analysis warehouse, as some dimension tables are hierarchical.

From the problem description, we can see that there is a huge fact table `fact_trip` for the vehicle's trip log, and a few supporting dimension tables:

- `dim_vehicle` for vehicle details, referenced from `fact_trip` by `vehicle_id`.
- `dim_driver` for driver details, referenced by `driver_id`.
- `dim_location` for point locations, referenced by `location_id`. It is assumed that the vehicle's speed is measured by some radar gun installed at these locations. Each speeding location is further associated with a street (a hierarchy of dimension tables):
  - `dim_street` for street details such as distance, referenced from `dim_location` by `street_id`.

*A dimension table for time is not needed* because the SQL `date` type would be sufficient, and PostgreSQL has functions to extract day, month, quarter and year parts from a single `date` value.

The problem description also states that there is a "street map" available without giving any specifics. We will assume that this *map records the connections among streets*, effectively a graph with streets as the vertices. It is a small fact table (references `dim_street`), so we'll call it `fact_city_map`.

Generally speaking, both the star and snowflake schema can be more empirically useful than the other depending on the specific problem that they are trying to solve. In this case, the snowflake model is the more useful one.
]

2. Draw a schema diagram for the above data warehouse using one of the most appropriate schema diagrams. Dimension and fact tables must have all primary keys by introducing the attribute that identifies each entity. Furthermore, a complete schema diagram must capture associations among all the entities to perform OLAP operations. (6 marks)

#sol[See @fig_5b for the snowflake schema diagram. Primary keys are in boldface. Foreign key references are indicated by links between entities.
#figure(
  image("resource/diagram_5b.png", width: 90%),
  caption: [Snowflake model for vehicle data warehouse.],
  placement: none,
) <fig_5b>]

3. A driver may like to perform online analytical processing to determine how to move fastest from one location to another location at a particular time. Discuss how this can be done efficiently by using data stored in the warehouse. (8 marks)

#sol[Conceptually, the driver's request can be satisfied by running some shortest path algorithm over the graph defined by the `fact_city_map` table. The crux of the matter is *real-time responsiveness*.

The user expects the query to finish in under a second, and there can be many concurrent requests. Therefore it is infeasible (and not necessary) to execute a shortest path algorithm every time a request comes in. Instead, an in-memory `location_route` table is built and maintained at regular intervals which serves the requests in real-time:

```sql
create table location_route (
  src int,      -- source `location_id`
  dest int,     -- destination `location_id`
  route int[]   -- a list of `street_id`s, giving the current fastest route
  estimated_time float
)
```

All requests of the "fastest route" is served by a simple look-up. This strategy works because although the requests are frequent, the underlying fastest route does not change as frequently. Depending on the traffic, a 20-minute refresh interval is reasonable. Another way is to implement `location_route` as a materialized view. 

Now for the actual algorithm to build `location_route`. One thing worth noting is that it is not solely determined by the city map, but also depends on the current traffic on the ground. A short but slow route should not be chosen if there is a longer but ultimately faster one. There are 2 approaches.

- Use recursive CTE to generate all possible routes from one location to another, and select the fastest one given the current average speed on each street. If this approach is still too slow for very large data sets, then:

- Use an off-line program or procedural language function (e.g. Python) to do the update.]