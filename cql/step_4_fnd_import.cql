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
    MERGE (n:FN_E {uid: map.url})
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
    MERGE (n:FN_G {uid: map.url})
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
    MATCH (n:FN_G {uid: map.url})
  WITH map, n
    UNWIND map.members As member
  WITH map, n, member
    MATCH (m:FN_E {uid: member.url})
      MERGE (n)<-[:IN_FN_G]-(m);
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
    MERGE (n:FN_R {uid: map.url})
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
    MATCH (n:FN_R {uid: map.url})
  WITH map, n
    UNWIND map.grp AS grp
  WITH map, n, grp
    MATCH (g:FN_G)
      WHERE grp.name IN g.name
    MERGE (n)<-[:G_IN_R]-(g)
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
    MATCH (n:FN_R {uid: map.url})
  WITH map, n
    UNWIND map.fn AS fn
  WITH map, n, fn
    MATCH (e:FN_E {uid: fn.bc_ws})
      MERGE (n)<-[:E_IN_R]-(e)
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
MATCH (n:FN_E)
	WHERE EXISTS(n.address) AND n.address <> ''
WITH n, REPLACE(SUBSTRING(n.address, SIZE(n.address)-7), ' ', '') AS zip
WITH n, zip
	MATCH (p:GN_PC {uid: zip})
		MERGE (n)-[:FN_AT_ZIP]->(p);
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Link First Nation with same name, nearest populated place on Geonames
//
MATCH (n:FN_E)-[:FN_AT_ZIP]->(z)
WITH n, TRIM(SPLIT(n.address, ',')[SIZE(SPLIT(n.address, ','))-2]) AS place_name, CASE EXISTS(n.location) WHEN TRUE THEN n.location ELSE z.location END AS loc
WITH n, place_name, loc
	MATCH (p:GN_NE {name: place_name})
    	WHERE p.feature STARTS WITH 'P.PPL'
        OR p.feature STARTS WITH 'A.ADM'
        OR p.feature STARTS WITH 'L.RESV'
WITH DISTINCT(n) AS n, COLLECT([p, DISTANCE(loc, p.location)]) AS pc
WITH n, REDUCE(m=HEAD(pc), e IN TAIL(pc) | CASE e[1] < m[1] WHEN TRUE THEN e ELSE m END) AS match
WITH n, match[0] AS p
  MERGE (n)-[:FN_NEAR_PL]->(p);
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Load FN_E name file from the import/ directory
// Call the nlp micro service to process the documents.
//
MATCH (n:FN_E)
  WITH n, [apoc.map.fromPairs([['u', 'name'], ['c', REDUCE(s=HEAD(n.name), e IN TAIL(n.name) | s+ '.\n\n'+ e)]])] AS input
    CALL custom.nlp_import(n, 'http://nlp:8000/process/', apoc.convert.toJson(input))
      YIELD result
RETURN 1;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Load FN_G name file from the import/ directory
// Call the nlp micro service to process the documents.
//
MATCH (n:FN_G)
  WITH n, [apoc.map.fromPairs([['u', 'name'], ['c', REDUCE(s=HEAD(n.name), e IN TAIL(n.name) | s+ '.\n\n'+ e)]])] AS input
    CALL custom.nlp_import(n, 'http://nlp:8000/process/', apoc.convert.toJson(input))
      YIELD result
RETURN 1;
//
////////////////////////////////////////////////////////////////////////////////
