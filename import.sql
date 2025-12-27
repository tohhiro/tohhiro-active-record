drop TABLE IF EXISTS users;
CREATE TABLE users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    age INTEGER,
    created_at DATETIME,
    updated_at DATETIME
);

drop TABLE IF EXISTS comments;
CREATE TABLE comments(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    body TEXT,
    created_at DATETIME,
    updated_at DATETIME
)