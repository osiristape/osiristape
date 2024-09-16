WITH height_threshold AS (
    SELECT MIN(height) AS min_top_10_height
    FROM (
        SELECT height
        FROM patients
        ORDER BY height DESC
        LIMIT (SELECT COUNT(*) * 0.1 FROM patients)
    ) AS top_10_percent
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
SELECT first_name, height, weight
FROM patients, height_threshold, median_weight
WHERE height >= min_top_10_height
  AND weight < median_weight;
