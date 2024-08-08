CREATE DATABASE nitin;
USE nitin;
CREATE TABLE probo( User_id VARCHAR(50), poll_id VARCHAR(50), poll_option_id VARCHAR(50), amount INT, created_dt DATE);
INSERT INTO probo( User_id, poll_id, poll_option_id, amount, created_dt)
VALUES
("id1","p1","A", 200 , "2021-12-01");
SELECT * FROM probo;
INSERT INTO probo( User_id, poll_id, poll_option_id, amount, created_dt)
VALUES
("id2", "p1", "C", 250, "2021-12-01"),
("id3", "p1", "A", 200, "2021-12-01"),
("id4", "p1", "B", 500, "2021-12-01"),
("id5", "p1", "C", 50, "2021-12-01"),
("id6", "p1", "D", 500, "2021-12-01"),
("id7", "p1", "C", 200, "2021-12-01"),
("id8", "p1", "A", 100, "2021-12-01");
SELECT Poll_Option_Id ,User_ID    FROM probo;

-- Total amount invested in Option C
SELECT SUM(amount) AS total_invested_in_C
FROM probo
WHERE poll_option_id = 'C';

-- Total amount invested in each losing option
SELECT poll_option_id, SUM(amount) AS total_invested
FROM probo
WHERE poll_option_id IN ('A', 'B', 'D')
GROUP BY poll_option_id;

-- Total amount invested in Option C
WITH invested_in_C AS (
    SELECT SUM(amount) AS total_invested_in_C
    FROM probo
    WHERE poll_option_id = 'C'
),

-- Total amount invested in losing options (A, B, D)
invested_in_losing_options AS (
    SELECT SUM(amount) AS total_invested_in_losing_options
    FROM probo
    WHERE poll_option_id IN ('A', 'B', 'D')
),

-- Amount invested by each user in Option C
user_investments_in_C AS (
    SELECT user_id, amount
    FROM probo
    WHERE poll_option_id = 'C'
),

-- Distribute the losing options' money proportionally to the users who invested in Option C
distributed_amounts AS (
    SELECT
        u.user_id,
	
        ((u.amount / (SELECT total_invested_in_C FROM invested_in_C)) * (SELECT total_invested_in_losing_options FROM invested_in_losing_options)) + ( u.amount) AS "Returns"
    FROM user_investments_in_C u
)

-- Final result to see how much each user will receive
SELECT * FROM distributed_amounts;


