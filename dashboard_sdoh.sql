// Štáty a organické jedlo
SELECT 
    fact.state, 
    COUNT(fact.household_id) AS organic_loyalist_count
FROM fact_household fact
JOIN dim_groceries g ON fact.household_id = g.household_id
WHERE g.organic_food = 7
GROUP BY fact.state
ORDER BY organic_loyalist_count DESC;



// Stress a vzdelanie

SELECT 
    o.education, 
    AVG(w.hw_stress_v2) AS avg_stress_score,
    COUNT(o.household_id) AS sample_size
FROM dim_occupation o
JOIN dim_wellness w ON o.household_id = w.household_id
GROUP BY o.education;

// BMI a frekvencia nákupov

SELECT 
    g.grocery_trips, 
    AVG(d.hw_bmi) AS average_bmi,
    //COUNT(g.household_id) AS household_count
FROM dim_groceries g
JOIN dim_diet d ON g.household_id = d.household_id
WHERE g.grocery_trips IS NOT NULL 
  AND d.hw_bmi IS NOT NULL
GROUP BY g.grocery_trips;