-- =====================================================
-- i. SQL FUNDAMENTALS 
-- =====================================================

-- Tampilkan seluruh data course.
 SELECT * FROM courses;
 
 -- Tampilkan nama course dan harga saja.
 SELECT course_name, price FROM courses;
 
 -- Tampilkan course dengan harga antara 50.000 sampai 200.000.
SELECT
	course_id,
    course_name,
    price
FROM courses
WHERE price BETWEEN 50000 AND 200000;

-- Tampilkan course yang memiliki kuota 0 ATAU harga di atas 500.000.
SELECT 
	course_id,
    course_name
    price,
    quota
FROM courses
WHERE quota = 0 OR price > 500000;

-- Tampilkan 5 course dengan harga tertinggi.
SELECT 
	course_id,
    course_name,
    price
FROM courses
ORDER BY price DESC LIMIT 5;

-- =====================================================
-- ii. Aggregate & Conditional Logic 
-- =====================================================

-- Hitung total user yang terdaftar.
SELECT COUNT(*) AS total_user_terdaftar FROM users;

-- Hitung total course yang tersedia
SELECT COUNT(*) AS total_course_tersedia FROM courses;

-- Hitung jumlah course per kategori.
SELECT
	cc.id,
    cc.name,
    COUNT(c.course_id) AS jumlah_course
FROM course_category cc
LEFT JOIN courses c ON cc.id = c.category_id
GROUP BY cc.id, cc.name
ORDER BY jumlah_course;

-- Hitung rata-rata harga course per kategori.
SELECT
    cc.name,
    ROUND(AVG(c.price), 2) AS rata_rata_harga
FROM course_category cc
JOIN courses c ON cc.id = c.category_id
GROUP BY cc.id, cc.name
ORDER BY rata_rata_harga;

-- Tampilkan kategori yang memiliki lebih dari 3 course.
SELECT
	cc.name,
    COUNT(c.course_id) AS jumlah_course
FROM course_category cc
JOIN courses c ON cc.id = c.category_id
GROUP BY cc.id, cc.name
HAVING COUNT(c.course_id) > 3;

-- =====================================================
-- iii. Join Statements
-- =====================================================

-- Tampilkan daftar course beserta nama kategorinya.
SELECT 
	c.course_id,
    c.course_name,
    cc.id,
    cc.name AS nama_kategori
FROM courses c
INNER JOIN course_category cc ON c.category_id = cc.id;

-- Tampilkan semua kategori meskipun belum memiliki course.
SELECT 
	cc.id,
    cc.name,
    COUNT(c.course_id) AS jumlah_course
FROM course_category cc
LEFT JOIN courses c ON cc.id = c.category_id
GROUP BY cc.id, cc.name;

-- Tampilkan semua user meskipun belum pernah mengupload course.
SELECT 
    u.user_id,
    u.name,
    u.role,
    COUNT(c.course_id) AS jumlah_course_diupload
FROM users u
LEFT JOIN courses c ON u.user_id = c.created_by
WHERE u.role IN( 'admin', 'mentor')
GROUP BY u.user_id, u.name, u.role
ORDER BY jumlah_course_diupload;

-- Tampilkan daftar course beserta nama instructor yang membuat course tersebut.
SELECT
    c.course_id,
    c.created_by,
    u.name,
    u.role
FROM courses c
INNER JOIN users u ON c.created_by = u.user_id;

-- Tampilkan jumlah course yang dibuat oleh masing-masing instructor.
SELECT
    u.user_id,
    u.name          AS nama_instructor,
    COUNT(c.course_id)   AS jumlah_course_dibuat
FROM users u
INNER JOIN courses c ON u.user_id = c.created_by
GROUP BY u.user_id, u.name
ORDER BY jumlah_course_dibuat;