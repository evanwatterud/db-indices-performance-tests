-- Find all rows that have an ingredient name of Brussels sprouts.
EXPLAIN ANALYSE
SELECT * FROM ingredients WHERE ingredients.name = 'Brussels sprouts';

-- result:
-- Seq Scan on ingredients  (cost=0.00..1902.00 rows=686 width=21) (actual time=0.027..27.556 rows=738 loops=1)
--    Filter: ((name)::text = 'Brussels sprouts'::text)
--    Rows Removed by Filter: 99262
--  Planning time: 0.275 ms
--  Execution time: 27.652 ms

-- Calculate the total count of rows of ingredients with a name of Brussels sprouts.
EXPLAIN ANALYSE
SELECT COUNT(*) FROM ingredients WHERE ingredients.name = 'Brussels sprouts';

-- result:
-- Aggregate  (cost=1903.71..1903.72 rows=1 width=0) (actual time=25.086..25.086 rows=1 loops=1)
--   ->  Seq Scan on ingredients  (cost=0.00..1902.00 rows=686 width=0) (actual time=0.014..24.870 rows=738 loops=1)
--         Filter: ((name)::text = 'Brussels sprouts'::text)
--         Rows Removed by Filter: 99262
-- Planning time: 0.068 ms
-- Execution time: 25.149 ms

-- Find all Brussels sprouts ingredients having a unit type of gallon(s).
EXPLAIN ANALYSE
SELECT * FROM ingredients WHERE ingredients.unit = 'gallon(s)';

-- result:
-- Seq Scan on ingredients  (cost=0.00..1902.00 rows=14457 width=21) (actual time=0.011..24.178 rows=14266 loops=1)
--   Filter: ((unit)::text = 'gallon(s)'::text)
--   Rows Removed by Filter: 85734
-- Planning time: 0.049 ms
-- Execution time: 25.001 ms

-- Find all rows that have a unit type of gallon(s), a name of Brussels sprouts or has the letter j in it.
EXPLAIN ANALYSE
SELECT * FROM ingredients WHERE ingredients.unit = 'gallon(s)'
AND (ingredients.name = 'Brussels sprouts' OR ingredients.name LIKE '%j%');

-- result:
-- Seq Scan on ingredients  (cost=0.00..2402.00 rows=358 width=21) (actual time=0.261..27.783 rows=280 loops=1)
--   Filter: (((unit)::text = 'gallon(s)'::text) AND (((name)::text = 'Brussels sprouts'::text) OR ((name)::text ~~ '%j%'::text)))
--   Rows Removed by Filter: 99720
-- Planning time: 0.108 ms
-- Execution time: 27.847 ms

-- With indices:
CREATE INDEX ON ingredients(name);
CREATE INDEX ON ingredients(unit);

-- Find all rows that have an ingredient name of Brussels sprouts.
EXPLAIN ANALYSE
SELECT * FROM ingredients WHERE ingredients.name = 'Brussels sprouts';

-- result:
-- Bitmap Heap Scan on ingredients  (cost=17.73..704.77 rows=686 width=21) (actual time=0.354..0.965 rows=738 loops=1)
--   Recheck Cond: ((name)::text = 'Brussels sprouts'::text)
--   Heap Blocks: exact=435
--   ->  Bitmap Index Scan on ingredients_name_idx  (cost=0.00..17.56 rows=686 width=0) (actual time=0.272..0.272 rows=738 loops=1)
--         Index Cond: ((name)::text = 'Brussels sprouts'::text)
-- Planning time: 0.309 ms
-- Execution time: 1.040 ms

-- Calculate the total count of rows of ingredients with a name of Brussels sprouts.
EXPLAIN ANALYSE
SELECT COUNT(*) FROM ingredients WHERE ingredients.name = 'Brussels sprouts';

-- result:
-- Aggregate  (cost=706.48..706.49 rows=1 width=0) (actual time=0.951..0.951 rows=1 loops=1)
--   ->  Bitmap Heap Scan on ingredients  (cost=17.73..704.77 rows=686 width=0) (actual time=0.285..0.830 rows=738 loops=1)
--         Recheck Cond: ((name)::text = 'Brussels sprouts'::text)
--         Heap Blocks: exact=435
--         ->  Bitmap Index Scan on ingredients_name_idx  (cost=0.00..17.56 rows=686 width=0) (actual time=0.208..0.208 rows=738 loops=1)
--               Index Cond: ((name)::text = 'Brussels sprouts'::text)
-- Planning time: 0.095 ms
-- Execution time: 0.990 ms

-- Find all Brussels sprouts ingredients having a unit type of gallon(s).
EXPLAIN ANALYSE
SELECT * FROM ingredients WHERE ingredients.unit = 'gallon(s)';

-- result:
-- Bitmap Heap Scan on ingredients  (cost=292.46..1125.17 rows=14457 width=21) (actual time=2.953..6.320 rows=14266 loops=1)
--   Recheck Cond: ((unit)::text = 'gallon(s)'::text)
--   Heap Blocks: exact=652
--   ->  Bitmap Index Scan on ingredients_unit_idx  (cost=0.00..288.85 rows=14457 width=0) (actual time=2.833..2.833 rows=14266 loops=1)
--         Index Cond: ((unit)::text = 'gallon(s)'::text)
-- Planning time: 0.070 ms
-- Execution time: 7.109 ms

-- Find all rows that have a unit type of gallon(s), a name of Brussels sprouts or has the letter j in it.
EXPLAIN ANALYSE
SELECT * FROM ingredients WHERE ingredients.unit = 'gallon(s)'
AND (ingredients.name = 'Brussels sprouts' OR ingredients.name LIKE '%j%');

-- result:
-- Bitmap Heap Scan on ingredients  (cost=288.93..1193.93 rows=358 width=21) (actual time=2.616..9.619 rows=280 loops=1)
--   Recheck Cond: ((unit)::text = 'gallon(s)'::text)
--   Filter: (((name)::text = 'Brussels sprouts'::text) OR ((name)::text ~~ '%j%'::text))
--   Rows Removed by Filter: 13986
--   Heap Blocks: exact=652
--   ->  Bitmap Index Scan on ingredients_unit_idx  (cost=0.00..288.85 rows=14457 width=0) (actual time=2.429..2.429 rows=14266 loops=1)
--         Index Cond: ((unit)::text = 'gallon(s)'::text)
-- Planning time: 0.461 ms
-- Execution time: 9.666 ms
