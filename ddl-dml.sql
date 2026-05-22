-- =====================================================
--  (Data Definition Language)
-- =====================================================

CREATE DATABASE assignment_lms;

USE assignment_lms;

CREATE TABLE users (
user_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
password VARCHAR(255) NOT NULL,
role ENUM('mentor', 'student', 'admin') NOT NULL DEFAULT 'student',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE course_category (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
description TEXT,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE courses (
course_id INT AUTO_INCREMENT PRIMARY KEY,
course_name VARCHAR(150) NOT NULL,
description TEXT,
price DECIMAL(10, 2) NOT NULL DEFAULT 0,
quota INT NOT NULL DEFAULT 0,
category_id INT NOT NULL,
created_by INT NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

-- FOREIGN KEY category_id -> course_category.id
-- Cardinalitas 1 : N (One to Many)
-- Relasi : satu kategori dapat memiliki banyak course, sebaliknya 1 course hanya memiliki 1 category
CONSTRAINT fk_courses_category
    FOREIGN KEY (category_id)
    REFERENCES course_category(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
-- FOREIGN KEY created_by -> users.user_id
-- Cardinalitas 1 : N (One to Many)
-- Relasi : satu user dapat membuat banyak course, sebaliknya 1 course hanya dibuat oleh 1 user
CONSTRAINT fk_courses_user
	FOREIGN KEY (created_by)
    REFERENCES users(user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE enrollments (
enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
course_id INT NOT NULL,
enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
progress DECIMAL(5,2) NOT NULL DEFAULT 0.00,
status ENUM('active','completed', 'dropped') DEFAULT 'active',

-- FOREIGN KEY user_id -> users.user_id
-- Cardinalitas 1 : N (One to Many)
-- Relasi : satu user dapat memiliki banyak enrollment, sebaliknya 1 enrollment hanya milik 1 user
CONSTRAINT fk_enrollments_users
	FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
-- FOREIGN KEY course_id -> courses.course_id
-- Cardinalitas 1 : N (One to Many)
-- Relasi : 1 course dapat memiliki banyak enrollment dan 1 enrollment hanya untuk 1 course
CONSTRAINT fk_enrollments_courses
	FOREIGN KEY (course_id)
    REFERENCES courses(course_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
-- Mencegah user enroll course yang sama lebih dari sekali
CONSTRAINT unique_user_course
	UNIQUE (user_id, course_id)
);

CREATE TABLE lessons (
lesson_id INT AUTO_INCREMENT PRIMARY KEY,
course_id INT NOT NULL,
lesson_name VARCHAR(150) NOT NULL,
content TEXT,
order_no INT NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

-- FOREIGN KEY course_id -> courses.course_id
-- Cardinalitas 1 : N (One to Many)
-- Relasi : 1 course memiliki banyak lesson dan 1 lesson hanya dimiliki 1 course
CONSTRAINT fk_lessons_courses
	FOREIGN KEY (course_id)
    REFERENCES courses(course_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- =====================================================
--  (Data Manipulation Language)
-- =====================================================

-- =====================================================
-- SEEDER TABLE: users
-- AUTO_INCREMENT START FROM 100
-- =====================================================

INSERT INTO users (user_id, name, email, password, role) VALUES
(100, 'Andi Saputra', 'andi@example.com', 'password123', 'admin'),
(101, 'Budi Hartono', 'budi@example.com', 'password123', 'mentor'),
(102, 'Citra Lestari', 'citra@example.com', 'password123', 'student'),
(103, 'Dewi Anggraini', 'dewi@example.com', 'password123', 'admin'),
(104, 'Eko Prasetyo', 'eko@example.com', 'password123', 'student'),
(105, 'Farhan Akbar', 'farhan@example.com', 'password123', 'mentor'),
(106, 'Gina Maharani', 'gina@example.com', 'password123', 'student'),
(107, 'Hendra Wijaya', 'hendra@example.com', 'password123', 'student'),
(108, 'Intan Permata', 'intan@example.com', 'password123', 'student'),
(109, 'Joko Susilo', 'joko@example.com', 'password123', 'student'),
(110, 'Kevin Saputra', 'kevin@example.com', 'password123', 'mentor'),
(111, 'Laila Fitri', 'laila@example.com', 'password123', 'admin'),
(112, 'Yosef Fernando', 'yosef@example.com', 'password123', 'mentor'),
(113, 'Fernando Lanes', 'fernando@example.com', 'password123', 'student'),
(114, 'Natasya Maindoka', 'natasya@example.com', 'password123', 'student');

-- =====================================================
-- SEEDER TABLE: course_category
-- AUTO_INCREMENT START FROM 200
-- =====================================================

INSERT INTO course_category (id, name, description) VALUES
(200, 'Web Development', 'Belajar pengembangan website'),
(201, 'Mobile Development', 'Belajar membuat aplikasi mobile'),
(202, 'Data Science', 'Belajar analisis data dan machine learning'),
(203, 'UI/UX Design', 'Belajar desain antarmuka pengguna'),
(204, 'Cyber Security', 'Belajar keamanan sistem dan jaringan'),
(205, 'Cloud Computing', 'Belajar teknologi cloud'),
(206, 'Artificial Intelligence', 'Belajar AI dan deep learning'),
(207, 'Digital Marketing', 'Belajar pemasaran digital'),
(208, 'Database', 'Belajar manajemen basis data'),
(209, 'Programming Basics', 'Belajar dasar pemrograman');

-- =====================================================
-- SEEDER TABLE: courses
-- AUTO_INCREMENT START FROM 300
-- =====================================================

INSERT INTO courses (course_id, category_id, created_by, course_name, description, price, quota) VALUES
(300, 200, 101, 'HTML & CSS Dasar', 'Belajar dasar HTML dan CSS', 50000, 0),
(301, 200, 101, 'JavaScript Fundamental', 'Belajar JavaScript dari nol', 100000, 20),
(302, 201, 105, 'Flutter untuk Pemula', 'Membuat aplikasi mobile dengan Flutter', 150000, 25),
(303, 202, 105, 'Python Data Analysis', 'Analisis data menggunakan Python', 300000, 30),
(304, 203, 101, 'Figma UI Design', 'Desain UI menggunakan Figma', 275000, 15),
(305, 204, 105, 'Dasar Cyber Security', 'Pengenalan keamanan siber', 350000, 10),
(306, 205, 103, 'AWS Cloud Basic', 'Dasar cloud computing AWS', 280000, 35),
(307, 206, 103, 'Machine Learning Intro', 'Pengenalan machine learning', 510000, 15),
(308, 207, 101, 'SEO & Social Media', 'Strategi digital marketing', 150000, 25),
(309, 208, 105, 'MySQL Database', 'Belajar database MySQL', 650000, 15),
(310, 209, 105, 'Programming Logic', 'Dasar logika pemrograman', 75000, 0),
(311, 209, 101, 'Programming Algorithm', 'Dasar algoritma pemrograman', 175000, 20),
(312, 200, 105, 'React JS Beginner', 'Belajar React JS dasar', 575000, 25),
(313, 200, 110, 'Vue JS Beginner', 'Belajar Vue JS dasar', 400000, 15),
(314, 200, 105, 'Angular JS Beginner', 'Belajar Angular JS dasar', 240000, 35),
(315, 200, 110, 'Node JS Beginner', 'Belajar Noded JS dasar', 135000, 10);

-- =====================================================
-- SEEDER TABLE: lessons
-- AUTO_INCREMENT START FROM 400
-- =====================================================

INSERT INTO lessons (lesson_id, course_id, lesson_name, content, order_no) VALUES
(400, 300, 'Pengenalan HTML', 'Materi dasar HTML', 1),
(401, 300, 'Dasar CSS', 'Materi dasar CSS', 2),
(402, 301, 'Variabel JavaScript', 'Belajar variabel JS', 1),
(403, 301, 'Function JavaScript', 'Belajar function JS', 2),
(404, 302, 'Install Flutter', 'Setup Flutter environment', 1),
(405, 302, 'Widget Dasar', 'Belajar widget Flutter', 2),
(406, 303, 'Pandas Introduction', 'Belajar library Pandas', 1),
(407, 304, 'Wireframe UI', 'Belajar wireframe', 1),
(408, 305, 'Jenis Serangan Siber', 'Pengenalan cyber attack', 1),
(409, 306, 'Pengenalan AWS', 'Dasar AWS cloud', 1),
(410, 307, 'Apa itu Machine Learning', 'Konsep machine learning', 1),
(411, 308, 'SEO Dasar', 'Optimasi mesin pencari', 1),
(412, 309, 'DDL & DML MySQL', 'Belajar query database', 1),
(413, 310, 'Flowchart Dasar', 'Dasar logika pemrograman', 1),
(414, 311, 'Component React', 'Belajar component React', 1);

-- =====================================================
-- SEEDER TABLE: enrollments
-- AUTO_INCREMENT START FROM 500
-- =====================================================

INSERT INTO enrollments (enrollment_id, user_id, course_id, progress, status) VALUES
(500, 102, 300, 20.00, 'active'),
(501, 102, 301, 50.00, 'active'),
(502, 103, 302, 100.00, 'completed'),
(503, 104, 303, 35.00, 'active'),
(504, 105, 304, 80.00, 'active'),
(505, 106, 305, 10.00, 'active'),
(506, 107, 306, 60.00, 'active'),
(507, 108, 307, 100.00, 'completed'),
(508, 109, 308, 25.00, 'active'),
(509, 110, 309, 45.00, 'active'),
(510, 111, 310, 70.00, 'active'),
(511, 102, 311, 15.00, 'dropped'),
(512, 103, 301, 40.00, 'active'),
(513, 104, 300, 90.00, 'completed'),
(514, 106, 302, 55.00, 'active');