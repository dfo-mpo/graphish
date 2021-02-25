////////////////////////////////////////////////////////////////////////////////
//
// Geo admin tree
//
MATCH (n:GN_NE)
  WHERE n.feature STARTS WITH 'A.ADM'
RETURN n;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Terrace
//
MATCH (n:GN_NE {name: 'Terrace'})
RETURN n;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// FN
//
MATCH (m:FN_R)-[r1:G_IN_R]-(n)-[r2:IN_FN_G]-(o)
RETURN m, r1, n, r2, o;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Basic info of a project
//
MATCH (n:PARR_PR {pid: "2015AFSAR2525"})
WITH n
	MATCH
    	(n)-[:PR_HAS_LOG]-(l),
    	(n)-[:PR_HAS_PPN|PR_HAS_OFS]-(o),
        (n)-[:PR_HAS_TSP|PR_HAS_OBS]-(s),
        (n)-[:PR_AT_WSH]-(w)
WITH n, l.uid AS log, COLLECT(DISTINCT(o.uid)) AS ppn, COLLECT(DISTINCT(s.uid)) AS sc, w.uid AS ws
WITH n, log, ppn, sc, ws
	MATCH
    	(n)-[:E_IN_D]-(e),
    	(n)-[:K_IN_D]-(k)
RETURN n.pid AS project_id, log AS lead, ppn AS partners, sc AS impact_species,
  n.the_total_cost_of_the_project AS cost, ws AS watershed,
  COLLECT(DISTINCT(e.c)) AS nec, COLLECT(DISTINCT(k.c)) AS kec;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Basic info in graph view
//
MATCH (n:PARR_PR {pid: "2015AFSAR2525"})
WITH n
	MATCH
    	(n)-[r1:PR_HAS_LOG]-(l),
    	(n)-[r2:PR_HAS_PPN|PR_HAS_OFS]-(o),
        (n)-[r3:PR_HAS_TSP|PR_HAS_OBS]-(s),
        (n)-[r4:PR_AT_WSH]-(w),
    	(n)-[r5:E_IN_D]-(e),
    	(n)-[r6:K_IN_D]-(k)
RETURN n, l, o, s, w, e, k, r1, r2, r3, r4, r5, r6;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Project at same watershed
//
MATCH (n:PARR_PR)-[r1:PR_AT_WSH]-(w:PR_LOC {uid: "Quesnel River"})
WITH n, r1, w
	MATCH (n)-[r2:PR_HAS_TSP|PR_HAS_OBS]-(s)
RETURN n, r1, w, r2, s;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Same project with muliple sites
//
MATCH (n:PARR_PR {pid: "19-NF-PAC-007"})
WITH n
	MATCH (n)-[:PR_HAS_LOG]-(l)
WITH n, l
	MATCH (n)-[:PR_HAS_PPN|PR_HAS_OFS]-(o)
WITH n, l, COLLECT(o) AS oc
	MATCH (n)-[:PR_HAS_TSP|PR_HAS_OBS]-(s)
WITH n, l, oc, COLLECT(s) AS sc
	MATCH (n)-[:PR_AT_WSH]-(w)
WITH COLLECT(n) AS nc, COLLECT([l, oc, sc, w]) AS info
	MATCH (m)-[:E_IN_D]-(e)
    WHERE ALL(m IN nc WHERE EXISTS((m)-[:E_IN_D]-(e)))
WITH nc, info, COLLECT(e) AS ec
  MATCH (m)-[:K_IN_D]-(k)
    WHERE ALL(m IN nc WHERE EXISTS((m)-[:K_IN_D]-(k)))
RETURN nc, info, ec, COLLECT(k) AS kc;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Projects at the same watershed
//
MATCH (n:PARR_PR)-[:PR_AT_WSH]-(w:PR_LOC {uid: "Jervis Inlet"})
RETURN n;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Projects at the same watershed, in the same project
//
MATCH (n:PARR_PR)-[:PR_AT_WSH]-(w:PR_LOC {uid: "Jervis Inlet"})
  WHERE n.pid = "17-HPAC-01361\n(C1-PAC-22)"
WITH n
	MATCH (n)-[:PR_HAS_LOG]-(l)
WITH n, l
	MATCH (n)-[:PR_HAS_TSP|PR_HAS_OBS]-(s)
RETURN n, l, s;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Projects at the same watershed, not in the same project
// Looking at organizations
//
MATCH (n:PARR_PR)-[:PR_AT_WSH]-(w:PR_LOC {uid: "Jervis Inlet"})
  WHERE n.pid <> "17-HPAC-01361\n(C1-PAC-22)"
WITH n
	MATCH (n)-[:PR_HAS_LOG]-(l)
WITH n, l
	MATCH (n)-[:PR_HAS_PPN|PR_HAS_OFS]-(o)
WITH n, l, o
	OPTIONAL MATCH (n)-[:PR_HAS_POC|PR_HAS_POM]-(oc1)
WITH n, l, o, oc1
	OPTIONAL MATCH (n)-[:PR_HAS_SOC|PR_HAS_SOM]-(oc2)
RETURN n, l, oc1, oc2;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Projects at the same watershed, not in the same project
// Looking at species
//
MATCH (n:PARR_PR)-[:PR_AT_WSH]-(w:PR_LOC {uid: "Jervis Inlet"})
  WHERE n.pid <> "17-HPAC-01361\n(C1-PAC-22)"
WITH n
	MATCH (n)-[:PR_HAS_LOG]-(l)
WITH n, l
	MATCH (n)-[:PR_HAS_PPN|PR_HAS_OFS]-(o)
WITH n, l, COLLECT(o) AS oc
	MATCH (n)-[:PR_HAS_TSP|PR_HAS_OBS]-(s)
WITH n, l, oc, COLLECT(s) AS sc
	MATCH (n)-[:PR_AT_WSH]-(w)
RETURN n, l, oc, sc, w;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Projects at the same watershed, not in the same project
// Looking at named entities and key phrases
//
MATCH (n:PARR_PR)-[:PR_AT_WSH]-(w:PR_LOC {uid: "Jervis Inlet"})
  WHERE n.pid <> "17-HPAC-01361\n(C1-PAC-22)"
WITH n
	MATCH (n)-[:PR_AT_WSH]-(w)
WITH COLLECT(n) AS nc, COLLECT(w) AS info
	MATCH (m)-[:E_IN_D]-(e)
    WHERE m IN nc
WITH nc, info, COLLECT(e) AS ec
  MATCH (m)-[:K_IN_D]-(k)
    WHERE m IN nc
RETURN nc, info, ec, COLLECT(k) AS kc;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Project clusters
// Turn off/on auto connect
//
MATCH (n:PARR_PR)
WITH n
	MATCH (n)-[r:NEAREST]-(m)
    	WHERE r.d > 1 AND r.d < 5
RETURN DISTINCT(n), COLLECT([r, m]);
//
////////////////////////////////////////////////////////////////////////////////
