-- CTE to select data from 1969
with yesterday as (
    select * 
    from actors
    where year = 1969
),

-- CTE to select data from 1970
today as (
    select * 
    from actor_films
    where year = 1970
)

-- Query to merge yesterday's and today's data
select 
    coalesce(t.actor, y.actor) as actor,           -- Actor name, preferring today's data
    coalesce(t.actorid, y.actorid) as actorid,     -- Actor ID, preferring today's data
    coalesce(t.year, y.year) as year,              -- Year, preferring today's data
    case
        when y.films is null then 
            ARRAY[ROW(t.film, t.votes, t.rating, t.filmid)::films] -- If no films from yesterday, use today's films
        when t.film is not null then 
            y.films || ARRAY[ROW(t.film, t.votes, t.rating, t.filmid)::films] -- Append today's films to yesterday's
        else 
            y.films                                -- Otherwise, keep yesterday's films
    end as films
    
from today t
full outer join yesterday y 
on t.actorid = y.actorid;                          -- Join on actor ID to combine records