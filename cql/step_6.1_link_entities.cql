////////////////////////////////////////////////////////////////////////////////
//
// Link project watershed_name with same name, nearest location on Geonames
//
MATCH (n:PROJECT)
  WHERE EXISTS(n.location)
    AND EXISTS(n.watershed_name)
WITH n, n.location AS loc, n.watershed_name AS place_name
	MATCH (p:GEO_LOCATION {name: place_name})
WITH DISTINCT(n) AS n, COLLECT([p, DISTANCE(loc, p.location)]) AS pc
WITH n, REDUCE(m=HEAD(pc), e IN TAIL(pc) | CASE e[1] < m[1] WHEN TRUE THEN e ELSE m END) AS match
WITH n, match[0] AS p
  MERGE (n)-[:PLACE_NEAR_WATERSHED]->(p);
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Link project orgs to FN entities
//
MATCH (n:ORGANIZATION)
WITH n
	MATCH (p:BC_FIRST_NATION)
    WHERE n.uid IN p.name
WITH n, p
  MERGE (n)-[:IS_A_FIRST_NATION]->(p);
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Link project orgs to FN groups
//
MATCH (n:ORGANIZATION)
WITH n
	MATCH (p:BC_NATION_COUNCIL)
    WHERE n.uid IN p.name
WITH n, p
  MERGE (n)-[:IS_A_NATION_COUNCIL]->(p);
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Create nearest neighbor graph within watershed
//
CALL apoc.periodic.iterate(
"
	MATCH (n:PROJECT)-[:HAS_WATERSHED]-(w)
    WHERE NOT(EXISTS((n)-[:NEAREST_IN_WATERSHED]->()))
	WITH DISTINCT(w) AS w, COLLECT(n) AS nc
  RETURN nc
", "
  WITH nc
    UNWIND nc AS n
  WITH nc, n, [m IN nc WHERE m <> n AND NOT(EXISTS((n)-[:NEAREST_IN_WATERSHED]->(m))) | [DISTANCE(m.location, n.location), m]] AS dl
  WITH n, dl, REDUCE(h=HEAD(dl), e IN TAIL(dl) | CASE h[0] < e[0] WHEN TRUE THEN h ELSE e END) AS md
  WITH n, [e IN dl WHERE e[0] = md[0] | e[1]] AS ll
  WITH n, ll
    FOREACH (m IN ll |
      MERGE (n)-[r:NEAREST_IN_WATERSHED]->(m)
        SET
          r.d = ROUND(DISTANCE(n.location, m.location)/1000)
    )
",
{
    batchSize:10, iterateList:true, parallel:false
});
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Create nearest neighbor graph within same project
//
CALL apoc.periodic.iterate(
"
	MATCH (n:PROJECT)
    	WHERE EXISTS(n.pid)
        AND n.pid <>'NA'
        AND n.number_of_sites > 0
        AND NOT(EXISTS((n)-[:NEAREST_IN_PROJECT]->()))
	WITH DISTINCT(n.pid) AS n, COLLECT(n) AS nc
  RETURN nc
", "
  WITH nc
    UNWIND nc AS n
  WITH nc, n, [m IN nc WHERE m <> n AND NOT(EXISTS((n)-[:NEAREST_IN_PROJECT]->(m))) | [DISTANCE(m.location, n.location), m]] AS dl
  WITH n, dl, REDUCE(h=HEAD(dl), e IN TAIL(dl) | CASE h[0] < e[0] WHEN TRUE THEN h ELSE e END) AS md
  WITH n, [e IN dl WHERE e[0] = md[0] | e[1]] AS ll
  WITH n, ll
    FOREACH (m IN ll |
      MERGE (n)-[r:NEAREST_IN_PROJECT]->(m)
        SET
          r.d = ROUND(DISTANCE(n.location, m.location)/1000)
    )
",
{
    batchSize:10, iterateList:true, parallel:false
});
//
////////////////////////////////////////////////////////////////////////////////
