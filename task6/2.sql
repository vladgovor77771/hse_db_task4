-- Добавьте запись о бронировании читателем ‘Василеем Петровым’ книги 
-- с ISBN 123456 и номером копии 4

WITH 
    book_instance AS (
        SELECT inst.id FROM library.book_instances inst
        LEFT JOIN library.books book ON inst.book_id = book.id
        WHERE book.isbn = '123456' AND inst.number = 4
    ),
    vasya AS (
        SELECT reader.id FROM library.readers reader
        WHERE reader.first_name = 'Vasily' AND reader.second_name = 'Petrov'
    )

INSERT INTO library.book_takes (book_instance_id, reader_id, take_at, return_at)
VALUES (book_instance.id, vasya.id, NOW(), NOW() + INTERVAL '1' DAY * 30)

-- Удалить все книги, год публикации которых превышает 2000 год.

DELETE FROM library.books book
WHERE book.year > 2000

-- Измените дату возврата для всех книг категории "Базы данных", 
-- начиная с 01.01.2016, чтобы они были в заимствовании на 30 дней 
-- дольше (предположим, что в SQL можно добавлять числа к датам).

UPDATE library.book_takes
SET
    return_at = return_at + INTERVAL '1' DAY * 30
FROM 
    library.book_instances book_instance
    LEFT JOIN library.books book ON book.id = book_instance.book_id
    LEFT JOIN library.book_categories book_category ON book_category.book_id = book.id
    LEFT JOIN library.categories category ON category.id = book_category.category_id
WHERE
	book_instance.id = book_instance_id AND
    category.name = 'Databases' AND 
    NOT is_returned AND
    take_at > TIMESTAMP WITH TIME ZONE '2016-01-01 00:00:00 +03:00'
