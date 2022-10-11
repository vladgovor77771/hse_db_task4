-- а) Найдите все прямые рейсы из Москвы в Тверь.
-- Допустим, что есть таблица connections..
-- У меня схема немного другая, я не стал переделывать (я ОЧЕНЬ ленивый)
-- Так что скринов с результатом нет
-- С моей схемой это сделать реально, но какой смысл, если все равно по заданию нужно иначе

SELECT 
    train.train_number AS train_number,
    train.start_station_name AS start_station_name,
    train.end_station_name AS end_station_name,
    train.depature AS depature,
    train.arrival AS arrival
FROM railway.connections connection
LEFT JOIN railway.trains train ON train.train_number = connection.train_number
LEFT JOIN railway.stations from_station ON from_station.name = connection.from_station
LEFT JOIN railway.stations to_station ON to_station.name = connection.to_station
LEFT JOIN railway.cities from_city ON from_city.name = from_station.city_name
LEFT JOIN railway.cities to_city ON to_city.name = to_city.city_name
WHERE from_city.name = 'Moscow' AND to_city.name = 'Tver';

-- б) Найдите все многосегментные маршруты, имеющие точно однодневный 
-- трансфер из Москвы в Санкт-Петербург (первое отправление и прибытие 
-- в конечную точку должны быть в одну и ту же дату). Вы можете применить
-- функцию DAY () к атрибутам Departure и Arrival, чтобы определить дату.

-- ??
-- тут вроде нужно заюзать