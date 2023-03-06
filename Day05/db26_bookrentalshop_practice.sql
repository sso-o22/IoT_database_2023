/* BookRentalShop 연습 */
SELECT *
  FROM divtbl;
  
-- 서브쿼리 - 성능이 떨어지는 영향(안좋음)
SELECT b.Author AS '저자'  -- 1
  -- , b.Division AS '장르'  -- 2
     , (SELECT Names 
          FROM divtbl 
		 WHERE Division = b.Division) AS '장르'  -- 3
     , b.Names AS '책제목'  -- 4
     , b.ISBN
     , b.Price AS '금액'
  FROM bookstbl AS b
 ORDER BY b.Names ASC;  -- 책제목, 3 => b.Names 대신 사용 / DB에서는 인덱스 1부터
 
-- 조인 - 서브쿼리 쓸바에는 조인으로 변경하라
SELECT b.Author AS '저자'
  -- , b.Division 
     , d.Names AS '장르'
     , b.Names AS '책제목'
     , b.ISBN
     , b.Price AS '금액'
  FROM bookstbl AS b  -- 새로 시작했으므로 위에 b랑 다름
 INNER JOIN divtbl AS d
    ON b.Division = d.Division
 ORDER BY b.Names;
 
-- 서브쿼리 - 장르로 그룹핑
SELECT (SELECT Names 
          FROM divtbl 
		 WHERE Division = bb.Division) AS '장르'
	 , bb.총합
  FROM (
		SELECT b.Division
			 , SUM(b.Price) AS '총합'
		  FROM bookstbl AS b
		 GROUP BY b.Division
       ) AS bb;
       
-- 내부 조인
SELECT m.Names AS '이름'
     , m.Addr AS '주소'
     , m.Mobile AS '연락처'
     , r.rentalDate AS '대여일자' 
     , r.returnDate AS '반납일자'
  -- , r.bookIdx 
     , b.Names AS '책제목' 
     , d.Names AS '장르'
     , b.Price AS '금액'
  FROM membertbl AS m
 INNER JOIN rentaltbl AS r
    ON m.memberIdx = r.memberIdx
 INNER JOIN bookstbl AS b
    ON r.bookIdx = b.bookIdx
 INNER JOIN divtbl AS d
    ON b.Division = d.Division;
    
-- 외부 조인
SELECT m.Names AS '이름'
     , m.Addr AS '주소'
     , m.Mobile AS '연락처'
     , r.rentalIdx  -- rentalIDX 값 없으면 책 안빌림
     , r.rentalDate AS '대여일자' 
     , IFNULL(r.returnDate, '미반납') AS '반납일자'
  -- , r.bookIdx 
     , b.Names AS '책제목' 
     , d.Names AS '장르'
     , b.Price AS '금액'
  FROM membertbl AS m  -- 멤버 테이블 기준이므로 LEFT
 INNER JOIN rentaltbl AS r  
    ON m.memberIdx = r.memberIdx
  LEFT OUTER JOIN bookstbl AS b
    ON r.bookIdx = b.bookIdx
  LEFT OUTER JOIN divtbl AS d
    ON b.Division = d.Division
 WHERE r.rentalIdx IS NULL;  -- 책을 안빌린 사람들
 
-- 책을 두권이상 출판한 저자
SELECT bb.Author
  -- , bb.Division
     , d.Names AS '장르'
     , bb.출판권수
     , bb.합계금액
  FROM (
		SELECT b.Author
			 , b.Division
			 , COUNT(b.Author) AS '출판권수'
			 , SUM(b.Price) AS '합계금액'
		  FROM bookstbl AS b
		 GROUP BY b.Author, b.Division
		HAVING COUNT(b.Author) >= 2
       ) AS bb
INNER JOIN divtbl AS d
   ON bb.Division = d.Division
ORDER BY bb.출판권수 DESC;