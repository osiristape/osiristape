WITH height_rank AS (
    SELECT *,
           NTILE(10) OVER (ORDER BY height DESC) AS height_decile
    FROM patients
),
median_weight AS (
    SELECT AVG(weight) AS median_weight
    FROM (
        SELECT weight
        FROM patients
        ORDER BY weight
        LIMIT 2 - (SELECT COUNT(*) FROM patients) % 2    -- 1 if odd, 2 if even
        OFFSET (SELECT (COUNT(*) - 1) / 2 FROM patients)
    ) AS subquery
)
SELECT name, height, weight
FROM height_rank, median_weight
WHERE height_decile = 1
  AND weight < median_weight;
