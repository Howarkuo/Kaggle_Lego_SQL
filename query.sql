-- Question 1: List all LEGO sets released in 2011. Order by number of parts descending.
SELECT set_num, name, num_parts
FROM sets
WHERE year = 2011
ORDER BY num_parts DESC;

-- Question 2: Count how many different LEGO sets exist for each year between 2001 and 2005.
SELECT year, COUNT(*) AS set_count
FROM sets
WHERE year BETWEEN 2001 AND 2005
GROUP BY year
ORDER BY year;

-- Question 3: Find all sets that include other sets. Display parent set name and included set name.
SELECT p.name AS parent_set_name, c.name AS included_set_name
FROM inventory_sets is_table
JOIN inventories i ON is_table.inventory_id = i.id
JOIN sets p ON i.set_num = p.set_num
JOIN sets c ON is_table.set_num = c.set_num;

-- Question 4: List all LEGO sets that belong to themes starting with "Star Wars", including parent themes.
SELECT s.name AS set_name, s.year, t.name AS theme_name, pt.name AS parent_theme_name
FROM sets s
JOIN themes t ON s.theme_id = t.id
LEFT JOIN themes pt ON t.parent_id = pt.id
WHERE t.name LIKE 'Star Wars%' OR pt.name LIKE 'Star Wars%';

-- Question 5: Total quantity of parts across all inventories per category, only for quantity > 50000.
SELECT pc.name AS category_name, SUM(ip.quantity) AS total_quantity
FROM part_categories pc
JOIN parts p ON pc.id = p.part_cat_id
JOIN inventory_parts ip ON p.part_num = ip.part_num
GROUP BY pc.name
HAVING SUM(ip.quantity) > 50000;

-- Question 6: Find the theme with the most sets.
SELECT t.name AS theme_name, COUNT(s.set_num) AS set_count
FROM themes t
JOIN sets s ON t.id = s.theme_id
GROUP BY t.id, t.name
ORDER BY set_count DESC
LIMIT 1;

-- Question 7: Display all sets from the year that had the highest average number of parts per set.
WITH YearAverages AS (
    SELECT year, AVG(num_parts) AS avg_parts
    FROM sets
    GROUP BY year
    ORDER BY avg_parts DESC
    LIMIT 1
)
SELECT s.*
FROM sets s
JOIN YearAverages ya ON s.year = ya.year;

-- Question 8: Find all themes that have no sets associated with them.
SELECT t.name
FROM themes t
WHERE NOT EXISTS (
    SELECT 1 
    FROM sets s 
    WHERE s.theme_id = t.id
);

-- Question 9: Find the top 5 most used colors across all sets.
SELECT c.name AS color_name, 
       c.rgb, 
       SUM(ip.quantity) AS total_quantity_used, 
       COUNT(DISTINCT i.set_num) AS num_different_sets
FROM colors c
JOIN inventory_parts ip ON c.id = ip.color_id
JOIN inventories i ON ip.inventory_id = i.id
GROUP BY c.id, c.name, c.rgb
ORDER BY total_quantity_used DESC
LIMIT 5;

-- Bonus 1: Find all sets whose names contain both "Castle" AND "Dragon".
SELECT name AS set_name, year
FROM sets
WHERE name LIKE '%Castle%' AND name LIKE '%Dragon%';

-- Bonus 2: Report showing total sets, unique parts, themes, and avg parts per set in one row.
SELECT 
    (SELECT COUNT(*) FROM sets) AS total_sets,
    (SELECT COUNT(DISTINCT part_num) FROM parts) AS total_unique_parts,
    (SELECT COUNT(*) FROM themes) AS total_themes,
    (SELECT ROUND(AVG(num_parts)) FROM sets) AS avg_parts_per_set;