////////////////////////////////////////////////////////////////////////////////
//
// Load First Nation data from the import/ directory
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.json('bcgov_fn_2.0.json')
    YIELD value AS map
  RETURN map
", "
  WITH map
    MERGE (n:BC_FIRST_NATION {uid: map.url})
      SET
        n.name = map.name,
        n.region = map.region,
        n.loc_desc = map.loc,
        n.website = map.website
  WITH map, n
    FOREACH (_ IN CASE map.lat <> '' AND map.lng <> '' WHEN TRUE THEN [1] ELSE [] END |
      SET
        n.location = POINT({latitude: TOFLOAT(map.latitude), longitude: TOFLOAT(map.longitude), crs: 'WGS-84'})
    )
",
{
    batchSize:100, iterateList:true, parallel:true
});
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Load First Nation Group data from the import/ directory
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.json('bcgov_og_2.0.json')
    YIELD value AS map
  RETURN map
", "
  WITH map
    MERGE (n:BC_NATION_COUNCIL {uid: map.url})
      SET
        n.name = map.name,
        n.region = map.region,
        n.loc_desc = map.loc,
        n.website = map.website
  WITH map, n
    FOREACH (_ IN CASE map.lat <> '' AND map.lng <> '' WHEN TRUE THEN [1] ELSE [] END |
      SET
        n.location = POINT({latitude: TOFLOAT(map.latitude), longitude: TOFLOAT(map.longitude), crs: 'WGS-84'})
    )
",
{
    batchSize:100, iterateList:true, parallel:true
});
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Link First Nation to First Nation Group
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.json('bcgov_og_2.0.json')
    YIELD value AS map
  RETURN map
", "
  WITH map
    MATCH (n:BC_NATION_COUNCIL {uid: map.url})
  WITH map, n
    UNWIND map.members As member
  WITH map, n, member
    MATCH (m:BC_FIRST_NATION {uid: member.url})
      MERGE (n)-[:HAS_MEMBER]->(m);
",
{
    batchSize:100, iterateList:true, parallel:false
});
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Load First Nation Region data from the import/ directory
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.json('bcafn_2.0.json')
    YIELD value AS map
  RETURN map
", "
  WITH map
    MERGE (n:BC_GEO_REGION {uid: map.url})
      SET
        n.name = map.name,
        n.lang = map.language,
        n.desc = map.desc,
        n.bkgd = map.bgd,
        n.summ = map.summ
  WITH map, n
    FOREACH (_ IN CASE map.lat <> '' AND map.lng <> '' WHEN TRUE THEN [1] ELSE [] END |
      SET
        n.location = POINT({latitude: TOFLOAT(map.latitude), longitude: TOFLOAT(map.longitude), crs: 'WGS-84'})
    )
    FOREACH (_ IN CASE map.fn_population <> '' WHEN TRUE THEN [1] ELSE [] END |
      SET
        n.fn_pop = TOINTEGER(map.fn_population)
    )
    FOREACH (_ IN CASE map.total_population <> '' WHEN TRUE THEN [1] ELSE [] END |
      SET
        n.tt_pop = TOINTEGER(map.total_population)
    )
    FOREACH (_ IN CASE map.percent_population <> '' WHEN TRUE THEN [1] ELSE [] END |
      SET
        n.pc_pop = TOFLOAT(REPLACE(map.percent_population, '%', ''))
    )
",
{
    batchSize:100, iterateList:true, parallel:true
});
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Link First Nation Group to First Nation Region
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.json('bcafn_2.0.json')
    YIELD value AS map
  RETURN map
", "
  WITH map
    MATCH (n:BC_GEO_REGION {uid: map.url})
  WITH map, n
    UNWIND map.grp AS grp
  WITH map, n, grp
    MATCH (g:BC_NATION_COUNCIL)
      WHERE grp.name IN g.name
    MERGE (n)-[:HAS_ASSOCIATION]->(g)
  WITH grp, g
      SET
        g.desc = grp.desc;
",
{
    batchSize:100, iterateList:true, parallel:false
});
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Link First Nation Group to First Nation Region
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.json('bcafn_2.0.json')
    YIELD value AS map
  RETURN map
", "
  WITH map
    MATCH (n:BC_GEO_REGION {uid: map.url})
  WITH map, n
    UNWIND map.fn AS fn
  WITH map, n, fn
    MATCH (e:BC_FIRST_NATION {uid: fn.bc_ws})
      MERGE (n)-[:HAS_NATION]->(e)
      SET
        e.lang = fn.language,
        e.office = fn.bc_office,
        e.region = fn.region,
        e.chief = fn.chief,
        e.council = [s IN SPLIT(fn.council, ',') | TRIM(s)],
        e.gov = fn.gov,
        e.contact = fn.contact
      FOREACH (_ IN CASE fn.address <> '' WHEN TRUE THEN [1] ELSE [] END |
        SET
          e.address = fn.address
      )
      FOREACH (_ IN CASE fn.land_area <> '' WHEN TRUE THEN [1] ELSE [] END |
        SET
          e.area = TOFLOAT(REPLACE(fn.land_area, ' ha', ''))
      )
      FOREACH (_ IN CASE fn.pop_off <> '' WHEN TRUE THEN [1] ELSE [] END |
        SET
          e.pop_off = TOINTEGER(fn.pop_off)
      )
      FOREACH (_ IN CASE fn.pop_on <> '' WHEN TRUE THEN [1] ELSE [] END |
        SET
          e.pop_on = TOINTEGER(fn.pop_on)
      )
      FOREACH (_ IN CASE fn.pop_all <> '' WHEN TRUE THEN [1] ELSE [] END |
        SET
          e.pop_all = TOINTEGER(fn.pop_all)
      )
      FOREACH (_ IN CASE fn.fn_ws <> '' WHEN TRUE THEN [1] ELSE [] END |
        SET
          e.website = fn.fn_ws
      );
",
{
    batchSize:100, iterateList:true, parallel:false
});
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Link First Nation with location of its addess postal code
//
MATCH (n:BC_FIRST_NATION)
	WHERE EXISTS(n.address) AND n.address <> ''
WITH n, REPLACE(SUBSTRING(n.address, SIZE(n.address)-7), ' ', '') AS zip
WITH n, zip
	MATCH (p:CA_POST_CODE {uid: zip})
		MERGE (n)-[:AT_ZIP]->(p);
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Link First Nation with same name, nearest populated place on Geonames
//
MATCH (n:BC_FIRST_NATION)-[:AT_ZIP]->(z)
WITH n, TRIM(SPLIT(n.address, ',')[SIZE(SPLIT(n.address, ','))-2]) AS place_name, CASE EXISTS(n.location) WHEN TRUE THEN n.location ELSE z.location END AS loc
WITH n, place_name, loc
	MATCH (p:GEO_LOCATION {name: place_name})
    	WHERE p.feature STARTS WITH 'P.PPL'
        OR p.feature STARTS WITH 'L.RESV'
WITH DISTINCT(n) AS n, COLLECT([p, DISTANCE(loc, p.location)]) AS pc
WITH n, pc, REDUCE(m=HEAD(pc), e IN TAIL(pc) | CASE e[1] < m[1] WHEN TRUE THEN e ELSE m END) AS match
WITH n, [e IN pc WHERE e[1] = match[1] | e[0]] AS ll, match[1] AS d
WITH n, ll, d
  FOREACH (p IN ll |
    MERGE (n)-[r:PLACE_NEARBY]->(p)
      SET r.d = d
  );
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Call the nlp micro service to process First Nation's name.
//
MATCH (n:BC_FIRST_NATION)
  WITH n, [
      apoc.map.fromPairs([['u', 'name'], ['c', REDUCE(s=HEAD(n.name), e IN TAIL(n.name) | s+ '.\n\n'+ e)]])
			apoc.map.fromPairs([['u', 'pref_name'], ['c', CASE n.pref_name IS NOT NULL WHEN TRUE THEN n.pref_name ELSE '' END]]),
			apoc.map.fromPairs([['u', 'alt_name'], ['c', CASE n.alt_name IS NOT NULL WHEN TRUE THEN n.pref_name ELSE '' END]])
    ] AS input
    CALL custom.nlp_import(n, 'http://nlp:8000/process/', apoc.convert.toJson(input))
      YIELD result
RETURN 1;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Call the nlp micro service to process First Nation Council's name
//
MATCH (n:BC_NATION_COUNCIL)
  WITH n, [apoc.map.fromPairs([['u', 'name'], ['c', REDUCE(s=HEAD(n.name), e IN TAIL(n.name) | s+ '.\n\n'+ e)]])] AS input
    CALL custom.nlp_import(n, 'http://nlp:8000/process/', apoc.convert.toJson(input))
      YIELD result
RETURN 1;
//
////////////////////////////////////////////////////////////////////////////////
