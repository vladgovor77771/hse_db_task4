-- Показать все названия книг вместе с именами издателей.

SELECT book.name, publisher.name FROM library.books book
LEFT JOIN library.publishers publisher ON book.publisher_id = publisher.id;

-- В какой книге наибольшее количество страниц?

SELECT book.name FROM library.books book
ORDER BY book.pages DESC
LIMIT 1;

-- Какие авторы написали более 5 книг?

SELECT author.name FROM library.authors author
WHERE (SELECT COUNT(*) FROM library.books book WHERE book.author_id = author.id) > 5;

-- В каких книгах более чем в два раза больше страниц, чем среднее количество страниц для всех книг?

WITH stats AS (SELECT AVG(pages) AS avg_pages FROM library.books)
SELECT book.name FROM library.books book
WHERE book.pages > (SELECT avg_pages FROM stats) * 2;

-- Какие категории содержат подкатегории?

WITH all_cats AS (SELECT id, name, parent_id FROM library.categories)
SELECT cat.name FROM all_cats cat
WHERE EXISTS (SELECT name FROM all_cats child WHERE child.parent_id = cat.id);

-- У какого автора (предположим, что имена авторов уникальны) написано максимальное количество книг?

SELECT author.name FROM library.authors author
ORDER BY (SELECT COUNT(*) FROM library.books book WHERE book.author_id = author.id) DESC
LIMIT 1;

-- Какие читатели забронировали все книги (не копии), написанные "Марком Твеном"?

WITH 
    mark_twen AS (
        SELECT ARRAY_AGG(book.id) AS book_ids
        FROM library.books book 
        LEFT JOIN library.authors author ON book.author_id = author.id
        WHERE author.name = 'Mark Twen'
    ),
	mark_twen_read_books_by_readers AS (
		SELECT
			reader.first_name AS first_name, 
			reader.second_name AS second_name, 
			ARRAY_AGG(book.id) AS read_books
		FROM library.readers reader
		LEFT JOIN library.book_takes book_takes ON book_takes.reader_id = reader.id 
		LEFT JOIN library.book_instances book_instances ON book_instances.id = book_takes.book_instance_id  
		LEFT JOIN library.books book ON book.id = book_instances.book_id 
		LEFT JOIN library.authors author ON book.author_id = author.id
		WHERE author.name = 'Mark Twen'
		GROUP BY reader.first_name, reader.second_name
	)

SELECT grouped.first_name, grouped.second_name FROM mark_twen_read_books_by_readers grouped
WHERE (
    grouped.read_books <@ (SELECT book_ids FROM mark_twen) AND 
    grouped.read_books @> (SELECT book_ids FROM mark_twen)
);

-- Какие книги имеют более одной копии?

SELECT book.name FROM library.books book
WHERE (SELECT COUNT(*) FROM library.book_instances instance WHERE instance.book_id = book.id) > 1;

-- ТОП 10 самых старых книг

SELECT book.name FROM library.books book
ORDER BY book.year
LIMIT 10;

-- Перечислите все категории в категории “Спорт” (с любым уровнем вложености).

WITH RECURSIVE cats AS (
	SELECT id, parent_id, name
	FROM library.categories
	WHERE name = 'Sport'
	UNION ALL
    SELECT child.id, child.parent_id, child.name
    FROM library.categories child
    JOIN cats s ON s.id = child.parent_id
)
SELECT name FROM cats;

