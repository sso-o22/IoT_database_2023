USE bookrentalshop;

-- 1번 문제
SELECT CONCAT(LEFT(m.Names, 1), ',', RIGHT(m.Names, 2)) AS '회원명'
	 , SUBSTRING_INDEX(m.Addr, ' ', -1) AS '주소'
	 , m.Mobile AS '폰번호'
	 , CONCAT(UPPER(SUBSTRING_INDEX(m.Email, '@', 1)),
       '@'
     , UPPER(SUBSTRING_INDEX(m.Email, '@', -1))) AS '이메일'
  FROM membertbl as m
 ORDER BY m.Email DESC;
  

-- 2번 문제
SELECT d.Names AS '장르'
     , b.Author AS '작가'
     , b.Names AS '책제목'
  FROM bookstbl AS b
 INNER JOIN divtbl AS d
    ON b.Division = d.Division
 ORDER BY d.Names ASC, b.Author ASC, b.Names DESC;
  

-- 3번 문제
INSERT INTO divtbl (Division, Names)
VALUES ('I002', '네트워크');

-- 4번 문제
UPDATE membertbl
   SET Levels = 'D'
     , Mobile = '010-9839-9999'
 WHERE Names = '성명건';
	
-- 5번 문제
-- IFNULL(컬럼명, Null일 경우 대체해서 나올 값);
SELECT IFNULL(d.Names, '--합계--') AS '장르'
     , CONCAT(FORMAT(SUM(b.Price), 0),'원') AS '장르별 총합계'
  FROM bookstbl AS b
 INNER JOIN divtbl AS d
    ON b.Division = d.Division
 GROUP BY d.Names
  WITH ROLLUP;
  