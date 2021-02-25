////////////////////////////////////////////////////////////////////////////////
//
// Link project watershed_name with same name, nearest location on Geonames
//
MATCH (n:PARR_PR)
  WHERE EXISTS(n.location)
    AND EXISTS(n.watershed_name)
WITH n, n.location AS loc, n.watershed_name AS place_name
	MATCH (p:GN_NE {name: place_name})
WITH DISTINCT(n) AS n, COLLECT([p, DISTANCE(loc, p.location)]) AS pc
WITH n, REDUCE(m=HEAD(pc), e IN TAIL(pc) | CASE e[1] < m[1] WHEN TRUE THEN e ELSE m END) AS match
WITH n, match[0] AS p
  MERGE (n)-[:WS_NEAR_PL]->(p);
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Link project orgs to FN entities
//
MATCH (n:PR_ORG)
WITH n
	MATCH (p:FR_E)
    WHERE n.uid IN p.name
WITH n, p
  MERGE (n)-[:ORG_IS_FNE]->(p);
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Link project orgs to FN groups
//
MATCH (n:PR_ORG)
WITH n
	MATCH (p:FR_G)
    WHERE n.uid IN p.name
WITH n, p
  MERGE (n)-[:ORG_IS_FNG]->(p);
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Create nearest neighbor graph within watershed
//
CALL apoc.periodic.iterate(
"
	MATCH (n:PARR_PR)-[:PR_AT_WSH]-(w)
	WITH DISTINCT(w) AS w, COLLECT(n) AS nc
  RETURN nc
", "
  WITH nc
    UNWIND nc AS n
  WITH nc, n, [m IN nc WHERE m <> n AND NOT(EXISTS((n)-[:NEAREST]-(m))) | [DISTANCE(m.location, n.location), m]] AS dl
  WITH n, dl, REDUCE(h=HEAD(dl), e IN TAIL(dl) | CASE h[0] < e[0] WHEN TRUE THEN h ELSE e END) AS md
  WITH n, [e IN dl WHERE e[0] = md[0] | e[1]] AS ll
  WITH n, ll
    FOREACH (m IN ll |
      MERGE (n)-[r:NEAREST]->(m)
        SET
          r.d = ROUND(DISTANCE(n.location, m.location)/1000),
          r.t = CASE n.pid = m.pid AND n.number_of_sites > 0 WHEN TRUE THEN 'p' ELSE 'w' END
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
	MATCH (n:PARR_PR)
    	WHERE EXISTS(n.pid) AND n.pid <>'NA' AND n.number_of_sites > 0
	WITH DISTINCT(n.pid) AS n, COLLECT(n) AS nc
  RETURN nc
", "
  WITH nc
    UNWIND nc AS n
  WITH nc, n, [m IN nc WHERE m <> n AND NOT(EXISTS((n)-[:NEAREST]-(m))) | [DISTANCE(m.location, n.location), m]] AS dl
  WITH n, dl, REDUCE(h=HEAD(dl), e IN TAIL(dl) | CASE h[0] < e[0] WHEN TRUE THEN h ELSE e END) AS md
  WITH n, [e IN dl WHERE e[0] = md[0] | e[1]] AS ll
  WITH n, ll
    FOREACH (m IN ll |
      MERGE (n)-[r:NEAREST]->(m)
        SET
          r.d = ROUND(DISTANCE(n.location, m.location)/1000),
          r.t = 'p'
    )
",
{
    batchSize:10, iterateList:true, parallel:false
});
//
////////////////////////////////////////////////////////////////////////////////
