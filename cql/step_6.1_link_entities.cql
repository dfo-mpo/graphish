////////////////////////////////////////////////////////////////////////////////
//
// Link project with the nearest location on Geonames
//
MATCH (n:PROJECT)
  WHERE EXISTS(n.location)
WITH n, n.location AS loc
	MATCH (p:GEO_LOCATION)
    WHERE p.feature STARTS WITH 'P.PPL'
WITH DISTINCT(n) AS n, COLLECT([p, DISTANCE(loc, p.location)]) AS pc
WITH n, pc, REDUCE(m=HEAD(pc), e IN TAIL(pc) | CASE e[1] < m[1] WHEN TRUE THEN e ELSE m END) AS match
WITH n, [e IN pc WHERE e[1] = match[1] | e[0]] AS ll, match[1] AS d
WITH n, ll, d
	FOREACH (p IN ll |
    	MERGE (n)-[r:PLACE_NEARBY]->(p)
        	SET r.d = ROUND(d/1000)
  );
//
//
//
MATCH (n:PROJECT {pid: '19-NF-PAC-043'})
WITH n 
  MATCH (p:GEO_LOCATION) 
    WHERE p.name CONTAINS "Chilliwack" 
      AND p.feature STARTS WITH "P.PPL" 
  MERGE (n)-[r:PLACE_NEARBY]->(p)
    SET
      r.d = 0.0;
//
MATCH (n:PROJECT {pid: '18-HPAC-01090'})
WITH n 
  MATCH (p:GEO_LOCATION) 
    WHERE p.name CONTAINS "Fraser Valley Regional District" 
  MERGE (n)-[r:PLACE_NEARBY]->(p)
    SET
      r.d = 0.0;
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
  MATCH (w:WATERSHED)
  WITH w
    MATCH (n:PROJECT)-[:HAS_WATERSHED]-(w)
  WITH DISTINCT(w) AS w, COLLECT(n) AS nc
  RETURN nc
", "
  WITH nc
	  UNWIND nc AS n
  WITH nc, n, [m IN nc WHERE m <> n AND NOT(EXISTS((n)-[:NEAREST_IN_WATERSHED]-(m))) | [ROUND(DISTANCE(m.location, n.location)/1000), m]] AS dl
  WITH n, dl, REDUCE(h=HEAD(dl), e IN TAIL(dl) | CASE h[0] < e[0] WHEN TRUE THEN h ELSE e END) AS md
  WITH n, [e IN dl WHERE e[0] = md[0] | e[1]] AS ll, md[0] AS d
  WITH n, ll, d
	  FOREACH (m IN ll |
      MERGE (n)-[r:NEAREST_IN_WATERSHED]->(m)
        SET r.d = d
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
	WITH DISTINCT(n.pid) AS pid, COLLECT(n) AS nc
    WITH pid, nc
    	WHERE SIZE(nc) > 1
  RETURN nc
", "
  WITH nc
    UNWIND nc AS n
  WITH nc, n, [m IN nc WHERE m <> n AND NOT(EXISTS((n)-[:NEAREST_IN_PROJECT]-(m))) | [ROUND(DISTANCE(m.location, n.location)/1000), m]] AS dl
  WITH n, dl, REDUCE(h=HEAD(dl), e IN TAIL(dl) | CASE h[0] < e[0] WHEN TRUE THEN h ELSE e END) AS md
  WITH n, [e IN dl WHERE e[0] = md[0] | e[1]] AS ll, md[0] AS d
  WITH n, ll, d
    FOREACH (m IN ll |
      MERGE (n)-[r:NEAREST_IN_PROJECT]->(m)
        SET r.d = d
    )
",
{
    batchSize:10, iterateList:true, parallel:false
});
//
////////////////////////////////////////////////////////////////////////////////
