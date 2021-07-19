BEGIN;

DROP TABLE IF EXISTS type_game_status CASCADE;
CREATE TABLE type_game_status (
    id SERIAL PRIMARY KEY,
    label VARCHAR(50) NOT NULL
);


DROP TABLE IF EXISTS type_player CASCADE;
CREATE TABLE type_player (
    id SERIAL PRIMARY KEY,
    label VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS type_user CASCADE;
CREATE TABLE type_user (
    id SERIAL PRIMARY KEY,
    label VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_login VARCHAR(255) NOT NULL,
    user_pseudo VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    type_user SMALLINT NOT NULL,
    banned SMALLINT DEFAULT 0,
    last_login_at TIMESTAMP,
    CONSTRAINT fk_type_user_type_user FOREIGN KEY(type_user) REFERENCES type_user(id)
);

DROP TABLE IF EXISTS logs_user_sessions CASCADE;
CREATE TABLE logs_user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    login_at TIMESTAMP DEFAULT NOW(),
    logout_at TIMESTAMP DEFAULT NULL,
    CONSTRAINT fk_user_id_users FOREIGN KEY(user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS logs_type_user CASCADE;
CREATE TABLE logs_type_user (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    type_user SMALLINT NOT NULL,
    granted_at TIMESTAMP NOT NULL DEFAULT NOw(),
    granted_by INT NOT NULL,
    removed_at TIMESTAMP DEFAULT NULL,
    removed_by INT DEFAULT NULL,
    CONSTRAINT fk_user_id_users FOREIGN KEY(user_id) REFERENCES users(id),
    CONSTRAINT fk_type_user_type_user FOREIGN KEY(type_user) REFERENCES type_user(id),
    CONSTRAINT fk_granted_by_users FOREIGN KEY(granted_by) REFERENCES users(id),
    CONSTRAINT fk_removed_by_users FOREIGN KEY(removed_by) REFERENCES users(id)
);

DROP TABLE IF EXISTS posters CASCADE;
CREATE TABLE posters (
    id SERIAL PRIMARY KEY,
    imdb_id VARCHAR(10) NOT NULL,
    poster_title VARCHAR(100) NOT NULL,
    poster_storepage VARCHAR(200) NOT NULL,
    poster_image VARCHAR(200) NOT NULL,
    movie_title VARCHAR(100) NOT NULL,
    movie_url VARCHAR(200) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by INT NOT NULL DEFAULT 1,
    updated_at TIMESTAMP DEFAULT NULL,
    updated_by INT DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    deleted_by INT DEFAULT NULL,
    CONSTRAINT fk_created_by_users FOREIGN KEY(created_by) REFERENCES users(id),
    CONSTRAINT fk_updated_by_users FOREIGN KEY(updated_by) REFERENCES users(id),
    CONSTRAINT fk_deleted_by_users FOREIGN KEY(deleted_by) REFERENCES users(id)
);

DROP TABLE IF EXISTS posters_mask_params CASCADE;
CREATE TABLE posters_mask_params (
    id SERIAL PRIMARY KEY,
    poster_id SMALLINT NOT NULL,
    bloc1_length SMALLINT NOT NULL,
    bloc1_height SMALLINT NOT NULL,
    bloc2_length SMALLINT NOT NULL,
    bloc2_height SMALLINT NOT NULL,
    bloc3_length SMALLINT NOT NULL,
    bloc3_height SMALLINT NOT NULL,
    bloc4_length SMALLINT NOT NULL,
    bloc4_height SMALLINT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    created_by INT NOT NULL,
    CONSTRAINT fk_poster_id_posters FOREIGN KEY(poster_id) REFERENCES posters(id),
    CONSTRAINT fk_created_by_users FOREIGN KEY(created_by) REFERENCES users(id)
);

DROP TABLE IF EXISTS link_user_posters CASCADE;
CREATE TABLE link_user_posters (
    user_id INT NOT NULL,
    poster_id SMALLINT NOT NULL,
    favorite SMALLINT DEFAULT 0,
    favorite_at TIMESTAMP DEFAULT NULL,
    CONSTRAINT pk_user_poster PRIMARY KEY (user_id, poster_id),
    CONSTRAINT fk_user_id_users FOREIGN KEY(user_id) REFERENCES users(id),
    CONSTRAINT fk_poster_id_posters FOREIGN KEY(poster_id) REFERENCES posters(id)
);

DROP TABLE IF EXISTS games CASCADE;
CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    type_game_status INT NOT NULL,
    number_posters SMALLINT NOT NULL,
    time_limit SMALLINT NOT NULL,
    share_link VARCHAR(100) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL,
    created_by INT NOT NULL,
    CONSTRAINT fk_games_type_game_status FOREIGN KEY(type_game_status) REFERENCES type_game_status(id),
    CONSTRAINT fk_created_by_users FOREIGN KEY(created_by) REFERENCES users(id)
);

DROP TABLE IF EXISTS link_game_posters CASCADE;
CREATE TABLE link_game_posters (
    game_id INT NOT NULL,
    poster_id SMALLINT NOT NULL,
    order_number SMALLINT NOT NULL,
    CONSTRAINT pk_game_poster PRIMARY KEY (game_id, poster_id),
    CONSTRAINT fk_game_id_games FOREIGN KEY(game_id) REFERENCES games(id),
    CONSTRAINT fk_poster_id_posters FOREIGN KEY(poster_id) REFERENCES posters(id)
);

DROP TABLE IF EXISTS game_players CASCADE;
CREATE TABLE game_players (
    id SERIAL PRIMARY KEY,
    game_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    pseudo VARCHAR(100) NOT NULL,
    type_player SMALLINT NOT NULL,
    rank SMALLINT DEFAULT 0,
    score SMALLINT DEFAULT 0,
    correct_guesses SMALLINT DEFAULT 0,
    total_guesses SMALLINT DEFAULT 0,
    total_skips SMALLINT DEFAULT 0,
    has_used_share_link SMALLINT DEFAULT 0,
    has_quit SMALLINT DEFAULT 0,
    CONSTRAINT fk_game_id_games FOREIGN KEY(game_id) REFERENCES games(id),
    CONSTRAINT fk_user_id_users FOREIGN KEY(user_id) REFERENCES users(id),
    CONSTRAINT fk_type_player_type_player FOREIGN KEY(type_player) REFERENCES type_player(id)
);

DROP TABLE IF EXISTS logs_player_guess CASCADE;
CREATE TABLE logs_player_guess (
    id SERIAL PRIMARY KEY,
    game_player INT NOT NULL,
    poster_id INT NOT NULL,
    poster_mask_stage SMALLINT NOT NULL,
    guess VARCHAR(255) NOT NULL,
    guessed_at TIMESTAMP NOT NULL,
    expected VARCHAR(255) NOT NULL,
    CONSTRAINT fk_game_player_game_players FOREIGN KEY(game_player) REFERENCES game_players(id),
    CONSTRAINT fk_poster_id_posters FOREIGN KEY(poster_id) REFERENCES posters(id)
);

DROP TABLE IF EXISTS logs_store_access CASCADE;
CREATE TABLE logs_store_access (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    poster_id SMALLINT NOT NULL,
    CONSTRAINT fk_user_id_users FOREIGN KEY(user_id) REFERENCES users(id),
    CONSTRAINT fk_poster_id_posters FOREIGN KEY(poster_id) REFERENCES posters(id)
);


COMMIT;
