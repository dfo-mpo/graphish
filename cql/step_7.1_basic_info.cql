////////////////////////////////////////////////////////////////////////////////
//
// Geo admin tree
//
MATCH (n:GEO_LOCATION)
  WHERE n.feature STARTS WITH 'A.ADM'
RETURN n;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Terrace
//
MATCH (n:GEO_LOCATION {name: 'Terrace'})
RETURN n;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// First Nation Tree: Region - Council - Nation
//
MATCH (m:BC_GEO_REGION)-[r:HAS_NATION]-(n:BC_FIRST_NATION)
WITH DISTINCT(m) AS m, COLLECT([r, n]) AS nc
	MATCH (m)-[r1:HAS_ASSOCIATION]-(a:BC_NATION_COUNCIL)-[r2:HAS_MEMBER]-(n:BC_FIRST_NATION)
WITH DISTINCT(m) AS m, nc, COLLECT([r1, a, r2, n]) AS anc
RETURN m, nc, anc;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Basic info of a project
//
MATCH (n:PROJECT {pid: "19-NF-PAC-043"})
WITH n
	MATCH
    	(n)-[:HAS_LEAD_ORGANIZATION]-(l),
    	(n)-[:HAS_PROJECT_PARTNER|HAS_OTHER_FUNDING_SOURCE|HAS_GC_FUNDING_SOURCE]-(o),
      (n)-[:HAS_TARGET_SPECIES|HAS_OTHER_BENEFITTING_SPECIES]-(s),
      (n)-[:HAS_WATERSHED]-(w)
WITH n, l.uid AS log, COLLECT(DISTINCT(o.uid)) AS ppn, COLLECT(DISTINCT(s.uid)) AS sc, w.uid AS ws
WITH n, log, ppn, sc, ws
	MATCH
    	(n)-[:HAS_NAMED_ENTITY]-(e),
    	(n)-[:HAS_KEY_PHRASE]-(k)
RETURN n.pid AS project_id, log AS lead, ppn AS partners, sc AS impact_species,
  n.the_total_cost_of_the_project AS cost, ws AS watershed,
  COLLECT(DISTINCT(e.c)) AS nec, COLLECT(DISTINCT(k.c)) AS kec;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Basic info in graph view
//
MATCH (n:PROJECT {pid: "19-NF-PAC-043"})-[r]-(o)
RETURN n, r, o;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Project at same watershed
//
MATCH (n:PROJECT)-[r1:HAS_WATERSHED]-(w:WATERSHED {uid: "Chilliwack River"})
WITH n, r1, w
	MATCH (n)-[r2:HAS_TARGET_SPECIES|HAS_OTHER_BENEFITTING_SPECIES]-(s)
RETURN n, r1, w, r2, s;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Same project with muliple sites
//
MATCH (n:PROJECT {pid: "16-HPAC-00402"})
WITH n
	MATCH (n)-[:HAS_LEAD_ORGANIZATION]-(l)
WITH n, l
	MATCH (n)-[:HAS_PROJECT_PARTNER|HAS_OTHER_FUNDING_SOURCE|HAS_GC_FUNDING_SOURCE]-(o)
WITH n, l, COLLECT(o) AS oc
	MATCH (n)-[:HAS_TARGET_SPECIES|HAS_OTHER_BENEFITTING_SPECIES]-(s)
WITH n, l, oc, COLLECT(s) AS sc
	MATCH (n)-[:HAS_WATERSHED]-(w)
RETURN n, l, oc, sc;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Projects at the same watershed
//
MATCH (n:PROJECT)-[r1:HAS_WATERSHED]-(w:WATERSHED {uid: "Chilliwack River"})
WITH n, r1, w
	MATCH (n)-[r2:HAS_TARGET_SPECIES|HAS_OTHER_BENEFITTING_SPECIES]-(s)
RETURN n, r1, w, r2, s;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Project clusters by watershed & project sites
//
MATCH (n:PROJECT)
WITH n
	MATCH (n)-[r:NEAREST_IN_PROJECT|NEAREST_IN_WATERSHED]-(m)-[:HAS_WATERSHED]-(w)
RETURN m, n, w;
//
////////////////////////////////////////////////////////////////////////////////
