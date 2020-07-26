CREATE TABLE parents AS
  SELECT "abraham" AS parent, "barack" AS child UNION
  SELECT "abraham"          , "clinton"         UNION
  SELECT "delano"           , "herbert"         UNION
  SELECT "fillmore"         , "abraham"         UNION
  SELECT "fillmore"         , "delano"          UNION
  SELECT "fillmore"         , "grover"          UNION
  SELECT "eisenhower"       , "fillmore";

CREATE TABLE dogs AS
  SELECT "abraham" AS name, "long" AS fur, 26 AS height UNION
  SELECT "barack"         , "short"      , 52           UNION
  SELECT "clinton"        , "long"       , 47           UNION
  SELECT "delano"         , "long"       , 46           UNION
  SELECT "eisenhower"     , "short"      , 35           UNION
  SELECT "fillmore"       , "curly"      , 32           UNION
  SELECT "grover"         , "short"      , 28           UNION
  SELECT "herbert"        , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;

-------------------------------------------------------------
-- PLEASE DO NOT CHANGE ANY SQL STATEMENTS ABOVE THIS LINE --
-------------------------------------------------------------

-- The size of each dog
CREATE TABLE size_of_dogs AS
  SELECT d.name, s.size FROM dogs as d, sizes as s WHERE d.height <= s.max AND d.height > s.min ;

-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  SELECT p.child FROM parents as p, dogs as d WHERE p.parent = d.name ORDER BY d.height DESC
  ;

-- Filling out this helper table is optional
CREATE TABLE siblings AS
  SELECT c1.child AS child1, c2.child as child2 FROM parents as c1, parents as c2 WHERE c1.parent = c2.parent AND c1.child < c2.child;

-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT sib.child1 || " and " || sib.child2 || " are " || siz.size || " siblings"
  FROM siblings as sib, size_of_dogs as siz, size_of_dogs as siz2 
  WHERE sib.child1 = siz.name AND  sib.child2 = siz2.name AND siz.size = siz2.size--THERE NEEDS TO BE FOUR CONDITIONS
  ;

-- Ways to stack 4 dogs to a height of at least 170, ordered by total height
CREATE TABLE stacks_helper AS  
  SELECT dogs1.name || ", " || dogs2.name ||", " ||dogs3.name || ", " || dogs4.name, dogs1.height + dogs2.height + dogs3.height + dogs4.height as total_height 
  FROM dogs as dogs1, dogs as dogs2, dogs as dogs3, dogs as dogs4
  WHERE dogs1.height < dogs2.height AND dogs2.height < dogs3.height AND dogs3.height < dogs4.height AND total_height > 170 
  ;--AND 
  --dogs1.name < dogs2.name AND dogs2.name < dogs3.name AND dogs3.name < dogs4.name;


--INSERT INTO stacks_helper SELECT dogs.name, dogs.height, dogs.height FROM dogs;
  --INSERT INTO stacks_helper(dogs) SELECT (stacks_helper.dogs || "," ||  stacks_helper.dogs), sum(stack_height), dogs.height FROM stacks_helper, dogs;
  --VALUES (dogs.name, dogs.fur)
-- Add your INSERT INTOs here


CREATE TABLE stacks AS
  SELECT * FROM stacks_helper as s 
  ORDER BY s.total_height ASC;