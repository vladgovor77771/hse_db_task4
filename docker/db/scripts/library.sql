CREATE SCHEMA IF NOT EXISTS library AUTHORIZATION popov_stepan206;

CREATE TABLE library.libraries (
    id BIGSERIAL NOT NULL,
    address TEXT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE library.authors (
    id BIGSERIAL NOT NULL,
    name TEXT NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE library.publishers (
    id BIGSERIAL NOT NULL,
    name TEXT NOT NULL,
    address TEXT NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE library.books (
    id BIGSERIAL NOT NULL,
    isbn TEXT NOT NULL,
    name TEXT NOT NULL,
    author_id BIGINT NOT NULL,
    year INT NOT NULL,
    pages INT NOT NULL,
    publisher_id BIGINT NOT NULL,

    PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS books__isdb__ui ON library.books (isbn);
ALTER TABLE library.books 
    ADD FOREIGN KEY (author_id) REFERENCES library.authors (id) ON DELETE CASCADE,
    ADD FOREIGN KEY (publisher_id) REFERENCES library.publishers (id) ON DELETE CASCADE;

CREATE TABLE library.book_instances (
    id BIGSERIAL NOT NULL,
    book_id BIGINT NOT NULL,
    number BIGINT NOT NULL,
    library_id BIGINT NOT NULL,

    PRIMARY KEY(id)
);

ALTER TABLE library.book_instances 
    ADD FOREIGN KEY (book_id) REFERENCES library.books (id) ON DELETE CASCADE,
    ADD FOREIGN KEY (library_id) REFERENCES library.libraries (id) ON DELETE CASCADE;

CREATE TABLE library.categories (
    id BIGSERIAL NOT NULL,
    parent_id BIGINT,
    name TEXT NOT NULL,

    PRIMARY KEY (id)
);

ALTER TABLE library.categories 
    ADD FOREIGN KEY (parent_id) REFERENCES library.categories (id) ON DELETE CASCADE;

CREATE TABLE library.book_categories (
    book_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,

    PRIMARY KEY (book_id, category_id)
);

ALTER TABLE library.book_categories 
    ADD FOREIGN KEY (book_id) REFERENCES library.books (id) ON DELETE CASCADE,
    ADD FOREIGN KEY (category_id) REFERENCES library.categories (id) ON DELETE CASCADE;

CREATE TABLE library.readers (
    id BIGSERIAL NOT NULL,
    first_name TEXT NOT NULL,
    second_name TEXT NOT NULL,
    address TEXT NOT NULL,
    birthday TIMESTAMPTZ NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE library.book_takes (
    id BIGSERIAL NOT NULL,
    book_instance_id BIGINT NOT NULL,
    reader_id BIGINT NOT NULL,
    take_at TIMESTAMPTZ NOT NULL,
    return_at TIMESTAMPTZ NOT NULL,
    is_returned BOOLEAN NOT NULL DEFAULT FALSE,

    PRIMARY KEY (id)
);

ALTER TABLE library.book_takes 
    ADD FOREIGN KEY (book_instance_id) REFERENCES library.book_instances (id) ON DELETE CASCADE,
    ADD FOREIGN KEY (reader_id) REFERENCES library.readers (id) ON DELETE CASCADE;
