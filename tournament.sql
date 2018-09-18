-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS matches CASCADE;

CREATE TABLE players (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL
);

CREATE TABLE matches (
	id SERIAL PRIMARY KEY,
	winner INT REFERENCES players(id),
	loser INT REFERENCES players(id)
);

CREATE VIEW wins AS
	SELECT players.id, count(matches.winner) AS num
	FROM players LEFT JOIN matches 
	ON players.id = matches.winner
	GROUP BY players.id;

CREATE VIEW counter AS
	SELECT players.id, count(matches.winner) AS num 
	FROM players LEFT JOIN matches
	ON players.id = matches.winner 
	OR players.id = matches.loser
	GROUP BY players.id;

CREATE VIEW standings AS
	SELECT players.id, players.name, wins.num AS wins_num, counter.num
	FROM players, wins, counter
	WHERE players.id = wins.id AND players.id = counter.id
	ORDER BY wins_num DESC;
