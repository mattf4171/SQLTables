-- Abstract: Use operations to make adjustments with respect to each table
drop table if exists prereq; 
drop table if exists takes; 
drop table if exists teaches; 
drop table if exists section; 
drop table if exists advisor;
drop table if exists instructor; 
drop table if exists course; 
drop table if exists student; 
drop table if exists department; 
drop table if exists classroom; 
drop table if exists time_slot; 
drop table if exists time_slot_1;
drop table if exists grade_points; 

create table classroom
	(building		varchar(15),
	 room_number		varchar(7),
	 capacity		numeric(4,0),
	 primary key (building, room_number)
	);

create table department
	(dept_name		varchar(20), 
	 building		varchar(15), 
	 budget		        numeric(12,2) check (budget > 0),
	 primary key (dept_name)
	);

create table course
	(course_id		varchar(8), 
	 title			varchar(50), 
	 dept_name		varchar(20),
	 credits		numeric(2,0) check (credits > 0),
	 primary key (course_id),
	 constraint course1 foreign key (dept_name) references department(dept_name)
		on delete set null
	);

create table instructor
	(ID			varchar(5), 
	 name			varchar(20) not null, 
	 dept_name		varchar(20), 
	 salary			numeric(8,2) check (salary > 29000),
	 primary key (ID),
	 constraint instructor1 foreign key (dept_name) references department(dept_name)
		on delete set null
	);

create table section
	(course_id		varchar(8), 
         sec_id			varchar(8),
	 semester		varchar(6)
		check (semester in ('Fall', 'Winter', 'Spring', 'Summer')), 
	 year			numeric(4,0) check (year > 1701 and year < 2100), 
	 building		varchar(15),
	 room_number		varchar(7),
	 time_slot_id		varchar(4),
	 primary key (course_id, sec_id, semester, year),
	 constraint section1 foreign key (course_id) references course(course_id)
		on delete cascade,
	 constraint section2 foreign key (building, room_number) 
        references classroom(building, room_number)
		on delete set null
	);

create table teaches
	(ID			varchar(5), 
	 course_id		varchar(8),
	 sec_id			varchar(8), 
	 semester		varchar(6),
	 year			numeric(4,0),
	 primary key (ID, course_id, sec_id, semester, year),
	 constraint teaches1 foreign key (course_id,sec_id, semester, year) 
        references section(course_id, sec_id, semester, year)
		on delete cascade,
	 constraint teaches2 foreign key (ID) references instructor(ID)
		on delete cascade
	);

create table student
	(ID			varchar(5), 
	 name			varchar(20) not null, 
	 dept_name		varchar(20), 
	 tot_cred		numeric(3,0) check (tot_cred >= 0),
	 primary key (ID),
	 constraint student1 foreign key (dept_name) references department(dept_name)
		on delete set null
	);

create table takes
	(ID			varchar(5), 
	 course_id		varchar(8),
	 sec_id			varchar(8), 
	 semester		varchar(6),
	 year			numeric(4,0),
	 grade		        varchar(2),
	 primary key (ID, course_id, sec_id, semester, year),
	 constraint takes1 foreign key (course_id,sec_id, semester, year) 
        references section(course_id, sec_id, semester, year)
		on delete cascade,
	 constraint takes2 foreign key (ID) references student(id)
		on delete cascade
	);

drop table if exists advisor; 
create table advisor
	(s_ID			varchar(5),
	 i_ID			varchar(5),
	 primary key (s_ID),
	 constraint advisor1 foreign key (i_ID) references instructor(ID)
		on delete set null,
	 constraint advisor2  foreign key (s_ID) references student(ID)
		on delete cascade
	);

create table time_slot
	(time_slot_id		varchar(4),
	 day			varchar(1),
	 start_hr		numeric(2) check (start_hr >= 0 and start_hr < 24),
	 start_min		numeric(2) check (start_min >= 0 and start_min < 60),
	 end_hr			numeric(2) check (end_hr >= 0 and end_hr < 24),
	 end_min		numeric(2) check (end_min >= 0 and end_min < 60),
	 primary key (time_slot_id, day, start_hr, start_min)
	);

create table prereq
	(course_id		varchar(8), 
	 prereq_id		varchar(8),
	 primary key (course_id, prereq_id),
	 constraint prereq1 foreign key (course_id) references course(course_id)
		on delete cascade,
	 constraint prereq2 foreign key (prereq_id) references course(course_id)
	);
  
create table grade_points (
   grade   varchar(2) primary key,
   points  numeric(2, 1)
);

delete from prereq;
delete from time_slot;
delete from advisor;
delete from takes;
delete from student;
delete from teaches;
delete from section;
delete from instructor;
delete from course;
delete from department;
delete from classroom;
delete from grade_points;

insert into classroom values ('Packard', '101', '500');
insert into classroom values ('Painter', '514', '10');
insert into classroom values ('Taylor', '3128', '70');
insert into classroom values ('Watson', '100', '30');
insert into classroom values ('Watson', '120', '50');
insert into department values ('Biology', 'Watson', '90000');
insert into department values ('Comp. Sci.', 'Taylor', '100000');
insert into department values ('Elec. Eng.', 'Taylor', '85000');
insert into department values ('Finance', 'Painter', '120000');
insert into department values ('History', 'Painter', '50000');
insert into department values ('Music', 'Packard', '80000');
insert into department values ('Physics', 'Watson', '70000');
insert into course values ('BIO-101', 'Intro. to Biology', 'Biology', '4');
insert into course values ('BIO-301', 'Genetics', 'Biology', '4');
insert into course values ('BIO-399', 'Computational Biology', 'Biology', '3');
insert into course values ('CS-101', 'Intro. to Computer Science', 'Comp. Sci.', '4');
insert into course values ('CS-190', 'Game Design', 'Comp. Sci.', '4');
insert into course values ('CS-315', 'Robotics', 'Comp. Sci.', '3');
insert into course values ('CS-319', 'Image Processing', 'Comp. Sci.', '3');
insert into course values ('CS-347', 'Database System Concepts', 'Comp. Sci.', '3');
insert into course values ('EE-181', 'Intro. to Digital Systems', 'Elec. Eng.', '3');
insert into course values ('FIN-201', 'Investment Banking', 'Finance', '3');
insert into course values ('HIS-351', 'World History', 'History', '3');
insert into course values ('MU-199', 'Music Video Production', 'Music', '3');
insert into course values ('PHY-101', 'Physical Principles', 'Physics', '4');
insert into instructor values ('10101', 'Srinivasan', 'Comp. Sci.', '65000');
insert into instructor values ('12121', 'Wu', 'Finance', '90000');
insert into instructor values ('15151', 'Mozart', 'Music', '40000');
insert into instructor values ('22222', 'Einstein', 'Physics', '95000');
insert into instructor values ('32343', 'El Said', 'History', '60000');
insert into instructor values ('33456', 'Gold', 'Physics', '87000');
insert into instructor values ('45565', 'Katz', 'Comp. Sci.', '75000');
insert into instructor values ('58583', 'Califieri', 'History', '62000');
insert into instructor values ('76543', 'Singh', 'Finance', '80000');
insert into instructor values ('76766', 'Crick', 'Biology', '72000');
insert into instructor values ('83821', 'Brandt', 'Comp. Sci.', '92000');
insert into instructor values ('98345', 'Kim', 'Elec. Eng.', '80000');
insert into section values ('BIO-101', '1', 'Summer', '2009', 'Painter', '514', 'B');
insert into section values ('BIO-301', '1', 'Summer', '2010', 'Painter', '514', 'A');
insert into section values ('CS-101', '1', 'Fall', '2009', 'Packard', '101', 'H');
insert into section values ('CS-101', '1', 'Spring', '2010', 'Packard', '101', 'F');
insert into section values ('CS-190', '1', 'Spring', '2009', 'Taylor', '3128', 'E');
insert into section values ('CS-190', '2', 'Spring', '2009', 'Taylor', '3128', 'A');
insert into section values ('CS-315', '1', 'Spring', '2010', 'Watson', '120', 'D');
insert into section values ('CS-319', '1', 'Spring', '2010', 'Watson', '100', 'B');
insert into section values ('CS-319', '2', 'Spring', '2010', 'Taylor', '3128', 'C');
insert into section values ('CS-347', '1', 'Fall', '2009', 'Taylor', '3128', 'A');
insert into section values ('EE-181', '1', 'Spring', '2009', 'Taylor', '3128', 'C');
insert into section values ('FIN-201', '1', 'Spring', '2010', 'Packard', '101', 'B');
insert into section values ('HIS-351', '1', 'Spring', '2010', 'Painter', '514', 'C');
insert into section values ('MU-199', '1', 'Spring', '2010', 'Packard', '101', 'D');
insert into section values ('PHY-101', '1', 'Fall', '2009', 'Watson', '100', 'A');
insert into teaches values ('10101', 'CS-101', '1', 'Fall', '2009');
insert into teaches values ('10101', 'CS-315', '1', 'Spring', '2010');
insert into teaches values ('10101', 'CS-347', '1', 'Fall', '2009');
insert into teaches values ('12121', 'FIN-201', '1', 'Spring', '2010');
insert into teaches values ('15151', 'MU-199', '1', 'Spring', '2010');
insert into teaches values ('22222', 'PHY-101', '1', 'Fall', '2009');
insert into teaches values ('32343', 'HIS-351', '1', 'Spring', '2010');
insert into teaches values ('45565', 'CS-101', '1', 'Spring', '2010');
insert into teaches values ('45565', 'CS-319', '1', 'Spring', '2010');
insert into teaches values ('76766', 'BIO-101', '1', 'Summer', '2009');
insert into teaches values ('76766', 'BIO-301', '1', 'Summer', '2010');
insert into teaches values ('83821', 'CS-190', '1', 'Spring', '2009');
insert into teaches values ('83821', 'CS-190', '2', 'Spring', '2009');
insert into teaches values ('83821', 'CS-319', '2', 'Spring', '2010');
insert into teaches values ('98345', 'EE-181', '1', 'Spring', '2009');
insert into student values ('00128', 'Zhang', 'Comp. Sci.', '102');
insert into student values ('12345', 'Shankar', 'Comp. Sci.', '32');
insert into student values ('19991', 'Brandt', 'History', '80');
insert into student values ('23121', 'Chavez', 'Finance', '110');
insert into student values ('44553', 'Peltier', 'Physics', '56');
insert into student values ('45678', 'Levy', 'Physics', '46');
insert into student values ('54321', 'Williams', 'Comp. Sci.', '54');
insert into student values ('55739', 'Sanchez', 'Music', '38');
insert into student values ('70557', 'Snow', 'Physics', '0');
insert into student values ('76543', 'Brown', 'Comp. Sci.', '58');
insert into student values ('76653', 'Aoi', 'Elec. Eng.', '60');
insert into student values ('98765', 'Bourikas', 'Elec. Eng.', '98');
insert into student values ('98988', 'Tanaka', 'Biology', '120');
insert into takes values ('00128', 'CS-101', '1', 'Fall', '2009', 'A');
insert into takes values ('00128', 'CS-347', '1', 'Fall', '2009', 'A-');
insert into takes values ('12345', 'CS-101', '1', 'Fall', '2009', 'C');
insert into takes values ('12345', 'CS-190', '2', 'Spring', '2009', 'A');
insert into takes values ('12345', 'CS-315', '1', 'Spring', '2010', 'A');
insert into takes values ('12345', 'CS-347', '1', 'Fall', '2009', 'A');
insert into takes values ('19991', 'HIS-351', '1', 'Spring', '2010', 'B');
insert into takes values ('23121', 'FIN-201', '1', 'Spring', '2010', 'C+');
insert into takes values ('44553', 'PHY-101', '1', 'Fall', '2009', 'B-');
insert into takes values ('45678', 'CS-101', '1', 'Fall', '2009', 'F');
insert into takes values ('45678', 'CS-101', '1', 'Spring', '2010', 'B+');
insert into takes values ('45678', 'CS-319', '1', 'Spring', '2010', 'B');
insert into takes values ('54321', 'CS-101', '1', 'Fall', '2009', 'A-');
insert into takes values ('54321', 'CS-190', '2', 'Spring', '2009', 'B+');
insert into takes values ('55739', 'MU-199', '1', 'Spring', '2010', 'A-');
insert into takes values ('76543', 'CS-101', '1', 'Fall', '2009', 'A');
insert into takes values ('76543', 'CS-319', '2', 'Spring', '2010', 'A');
insert into takes values ('76653', 'EE-181', '1', 'Spring', '2009', 'C');
insert into takes values ('98765', 'CS-101', '1', 'Fall', '2009', 'C-');
insert into takes values ('98765', 'CS-315', '1', 'Spring', '2010', 'B');
insert into takes values ('98988', 'BIO-101', '1', 'Summer', '2009', 'A');
insert into takes values ('98988', 'BIO-301', '1', 'Summer', '2010', null);
insert into advisor values ('00128', '45565');
insert into advisor values ('12345', '10101');
insert into advisor values ('23121', '76543');
insert into advisor values ('44553', '22222');
insert into advisor values ('45678', '22222');
insert into advisor values ('76543', '45565');
insert into advisor values ('76653', '98345');
insert into advisor values ('98765', '98345');
insert into advisor values ('98988', '76766');
insert into time_slot values ('A', 'M', '8', '0', '8', '50');
insert into time_slot values ('A', 'W', '8', '0', '8', '50');
insert into time_slot values ('A', 'F', '8', '0', '8', '50');
insert into time_slot values ('B', 'M', '9', '0', '9', '50');
insert into time_slot values ('B', 'W', '9', '0', '9', '50');
insert into time_slot values ('B', 'F', '9', '0', '9', '50');
insert into time_slot values ('C', 'M', '11', '0', '11', '50');
insert into time_slot values ('C', 'W', '11', '0', '11', '50');
insert into time_slot values ('C', 'F', '11', '0', '11', '50');
insert into time_slot values ('D', 'M', '13', '0', '13', '50');
insert into time_slot values ('D', 'W', '13', '0', '13', '50');
insert into time_slot values ('D', 'F', '13', '0', '13', '50');
insert into time_slot values ('E', 'T', '10', '30', '11', '45 ');
insert into time_slot values ('E', 'R', '10', '30', '11', '45 ');
insert into time_slot values ('F', 'T', '14', '30', '15', '45 ');
insert into time_slot values ('F', 'R', '14', '30', '15', '45 ');
insert into time_slot values ('G', 'M', '16', '0', '16', '50');
insert into time_slot values ('G', 'W', '16', '0', '16', '50');
insert into time_slot values ('G', 'F', '16', '0', '16', '50');
insert into time_slot values ('H', 'W', '10', '0', '12', '30');
insert into prereq values ('BIO-301', 'BIO-101');
insert into prereq values ('BIO-399', 'BIO-101');
insert into prereq values ('CS-190', 'CS-101');
insert into prereq values ('CS-315', 'CS-101');
insert into prereq values ('CS-319', 'CS-101');
insert into prereq values ('CS-347', 'CS-101');
insert into prereq values ('EE-181', 'PHY-101');

insert into grade_points values ('A+', 4.2);
insert into grade_points values ('A', 4.0);
insert into grade_points values ('A-', 3.7);
insert into grade_points values ('B+', 3.33);
insert into grade_points values ('B', 3.0);
insert into grade_points values ('B-', 2.7);
insert into grade_points values ('C+', 2.3);
insert into grade_points values ('C', 2.0);
insert into grade_points values ('C-', 1.7);
insert into grade_points values ('F', 0.0);

runscript from '~/Downloads/courses-ddl.sql';
runscript from '~/Downloads/courses-small.sql';

select * from classroom;

-- 1. show the name and salary of all instructors
select name, salary from instructor;

-- 2. show all columns for instructors in the 'Comp. Sci.' department
select * from instructor where dept_name='Comp. Sci.';

-- 3. show name, salary, department for instructors with salaries less than $50,000.
select name, salary, dept_name from instructor where (salary<50000);

-- 4. show the student name, major department and total credits for 
--    students with at least 90 credits
select name, dept_name, tot_cred from student where (tot_cred<90);

-- 5. show the student ID and name for students who are majoring in  
--    Electrical Engineering  (Elec. Eng.) or Comp. Sci.  and have at least 90 credits
select id, name from student where (dept_name='Elec. Eng.' or dept_name='Comp. Sci.') and tot_cred>=90;

-- 6. insert a new Student with an ID 12399, name is Fred Brooks, student is majoring in Comp. Sci., total credits is 0.
insert into student values ('12399', 'Fred Brooks', 'Comp. Sci.', '0');

-- 7. increase the total credits by 8 for student with ID 19991
update student set tot_cred=tot_cred+8 where id=19991

-- 8. change the tot_cred for student ID=12399 to 100.
update student set tot_cred =100 where id=12399

-- 9. show all columns for all students
select * from student;

-- 10.  Give all faculty a 4% increase in salary.
update INSTRUCTOR  set salary = salary*1.04

-- 11.  Give all faculty in the Physics department a $3,500 salary increase.
-- select dept_name, salary from instructor
update INSTRUCTOR  set SALARY = case when dept_name="Physics" then (SALARY +3500) end

-- 12.  show the  ID, name and salary for all instructors
select id, name, salary from instructor;

-- 13.  try to delete the course 'PHY-101'.  
select * from course;
delete from course where course_id ="PHY-101"; 

-- 14.  Why does the delete fail?
-- Because the column course_id is a foreign key?

-- 15.  Delete the course 'CS-315'
delete from COURSE  where COURSE_ID ="CS-315";

-- 16.  Show a list of all course_id.
select course_id from course;

-- 17.  Show all the student majors.  Do not show duplicates.
select distinct dept_name from student order by dept_name; 

-- 18.  create a table "company" with columns id, name and ceo. 
-- Make "id" the primary key.
-- insert the following data 
--    id   name          ceo
--    ACF  Acme Finance  Mike Dempsey
--    TCA  Tara Capital  Ava Newton
--    ALB  Albritton     Lena Dollar
create table company
    ( ID          varchar(5),
      name    varchar(20) not null,
      ceo       varchar(20) not null,
      primary key (ID)
    );
insert into company values('ACF', 'Abhi Engineering', 'Mike Dempsey');
insert into company values('TCA', 'Tara Capital', 'Ava Newton');
insert into company values('ALB', 'Albritton', 'Lena Dollar');


-- create a table "security" with columns id, name, type.
-- Make "id" the primary key.
-- insert the following data
--    id    name                type
--    AE    Abhi Engineering    Stock
--    BH    Blues Health        Stock
--    CM    County Municipality Bond
--    DU    Downtown Utlity     Bond
--    EM    Emmitt Machines     Stock
create table security 
	( 	ID		varchar(5),
		name	varchar(20),
		type	varchar(20),
		primary key (ID)
	);
insert into security values('AE', 'Abhi Engineering', 'Stock');
insert into security values('BH', 'Blues Health', 'Stock');
insert into security values('CM', 'County Municipality', 'Bond');
insert into security values('DU', 'Downtown Utlity', 'Bond');
insert into security values('EM', 'Emmitt Machines', 'Stock');

-- create a table "funds"   
-- Make "FundID" the primary key.  
-- Make "CompanyID" a foreign key.
-- add the following data
-- CompanyID  InceptionDate   FundID Name
--    ACF      2005-01-01     BG     Big Growth
--    ACF      2006-01-01     SG     Steady Growth
--    TCA      2005-01-01     LF     Tiger Fund
--    TCA      2006-01-01     OF     Owl Fund
--    ALB      2005-01-01     JU     Jupiter
--    ALB      2006-01-01     SA     Saturn
create table funds
	(	CompanyID		varchar(5),
		InceptionDate	varchar(20),
		FundID			varchar(5),
		Name			varchar(20),
		primary key (FundID),
		foreign key (CompanyID) references company(id)
	);
insert into funds values('ACF', '2005-01-01', 'BG', 'Big Growth');
insert into funds values('ACF', '2006-01-01', 'SG', 'Steady Growth');
insert into funds values('TCA', '2005-01-01', 'LF', 'Tiger Fund');
insert into funds values('TCA', '2006-01-01', 'OF', 'Owl Fund');
insert into funds values('ALB', '2005-01-01', 'JU', 'Jupiter');
insert into funds values('ALB', '2006-01-01', 'SA', 'Saturn');


-- create a table holdings
-- Make fundID, securityID the primary key.
-- Make fundID a foreign key.
-- Make securityID a foreign key.
-- add the following data  
--    fundID   securityID   quantity
--     BG       AE           500
--     BG       EM           300
--     SG       AE           300
--     SG       DU           300
--     LF       EM          1000
--     LF       BH          1000
--     OF       CM          1000
--     OF       DU          1000
--     JU       EM          2000
--     JU       DU          1000
--     SA       EM          1000
--     SA       DU          2000
create table holdings
	(	fundID		varchar(5),
		securityID	varchar(5),
		quantity	numeric(5),
		primary key(fundID, securityID),
		foreign key(fundID) references security(ID) on delete set null
	);
insert into holdings values('BG', 'AE', '500');
insert into holdings values('BG', 'EM', '300');
insert into holdings values('SG', 'AE', '300');
insert into holdings values('SG', 'DU', '300');
insert into holdings values('LF', 'EM', '1000');
insert into holdings values('LF', 'BH', '1000');
insert into holdings values('OF', 'CM', '1000');
insert into holdings values('OF', 'DU', '1000');
insert into holdings values('JU', 'EM', '2000');
insert into holdings values('JU', 'DU', '1000');
insert into holdings values('SA', 'EM', '1000');
insert into holdings values('SA', 'DU', '2000');

-- 19.  alter the security table to add a column price numeric(7,2)
alter table security add price numeric(7,2);

-- 20.  drop the tables. Because of the foreign keys, you must drop the 
--   tables in a particular order.
drop table if exists prereq; 
drop table if exists takes; 
drop table if exists teaches; 
drop table if exists section; 
drop table if exists advisor;
drop table if exists instructor; 
drop table if exists course; 
drop table if exists student; 
drop table if exists department; 
drop table if exists classroom; 
drop table if exists time_slot; 
drop table if exists time_slot_1;
drop table if exists grade_points;
drop table if exists company;
drop table if exists security;
drop table if exists holdings;
drop table if exists funds;