////////////////////////////////////////////////////////////////////////////////
//
// Load Geonames feature code data from the import/ directory
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.csv('featureCodes_en.txt', {sep: 'TAB', nullValues: ['']})
    YIELD lineNo, map, list
", "
  WITH map
    MERGE (n:GEO_FEATURE {uid: map.code})
      SET
        n.name = map.name,
        n.desc = map.desc;
",
{
    batchSize:100, iterateList:true, parallel:true
});
//
//
// Load Geonames Bristish Columbia data from the import/ directory
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.csv('CA-BC-geonames.tsv', {sep: 'TAB', nullValues: ['']})
    YIELD lineNo, map, list
", "
  WITH map
    MERGE (n:GEO_LOCATION {uid: TOINTEGER(map.geonameid)})
      SET
        n.name = map.name,
        n.ascii_name = map.ascii_name,
        n.alt_names = SPLIT(map.alt_names, ','),
        n.location = POINT({latitude: TOFLOAT(map.latitude), longitude: TOFLOAT(map.longitude), crs: 'WGS-84'}),
        n.feature = map.feature_class + '.' + map.feature_code,
        n.population = TOINTEGER(map.population),
        n.elevation = TOINTEGER(map.elevation),
        n.dem = TOINTEGER(map.dem),
        n.timezone = map.timezone,
        n.ts = DATE(map.modification_date)
  WITH map, n
    FOREACH (_ IN CASE n.feature IN ['A.ADM1'] WHEN TRUE THEN [1] ELSE [] END |
      SET
        n.admin_code = map.admin1_code
    )
    FOREACH (_ IN CASE n.feature IN ['A.ADM2'] WHEN TRUE THEN [1] ELSE [] END |
      SET
        n.admin_code = map.admin1_code + '.' + map.admin2_code,
        n.upper_adm = map.admin1_code
    )
    FOREACH (_ IN CASE n.feature IN ['A.ADM3'] WHEN TRUE THEN [1] ELSE [] END |
      SET
        n.admin_code = map.admin1_code + '.' + map.admin2_code + '.' + map.admin3_code,
        n.upper_adm = map.admin1_code + '.' + map.admin2_code
    )
    FOREACH (_ IN CASE NOT(n.feature IN ['A.ADM1', 'A.ADM2', 'A.ADM3']) WHEN TRUE THEN [1] ELSE [] END |
      SET
        n.upper_adm = map.admin1_code + (CASE map.admin2_code IS NOT NULL WHEN TRUE THEN '.' + map.admin2_code ELSE '' END) + (CASE map.admin3_code IS NOT NULL WHEN TRUE THEN '.' + map.admin3_code ELSE '' END)
    );
",
{
    batchSize:1000, iterateList:true, parallel:true
});
//
//
//
CALL apoc.periodic.iterate(
"
  MATCH (n:GEO_LOCATION)
  WITH n
    MATCH (fc:GEO_FEATURE {uid: n.feature})
  RETURN n, fc
", "
  WITH n, fc
    MERGE (n)-[:HAS_FEATURE]->(fc);
",
{
    batchSize:1000, iterateList:true, parallel:false
});
//
//
//
CALL apoc.periodic.iterate(
"
  MATCH (n:GEO_LOCATION)
    WHERE n.upper_adm IS NOT NULL
  WITH n
    MATCH (m:GEO_LOCATION {admin_code: n.upper_adm})
  RETURN n, m
", "
  WITH n, m
    MERGE (n)-[:WITH_IN]->(m);
",
{
    batchSize:1000, iterateList:true, parallel:false
});
//
// Load Canada postal code data from the import/ directory
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.json('bc_pc_1.0.json')
    YIELD value
  RETURN value AS map
", "
  WITH map
    MERGE (n:CA_POST_CODE {uid: map.code})
      SET
        n.centroid = POINT({latitude: map.centroid[0], longitude: map.centroid[1], crs: 'WGS-84'}),
        n.boundary = [p IN map.points | POINT({latitude: p[0], longitude: p[1], crs: 'WGS-84'})];
",
{
    batchSize:1000, iterateList:true, parallel:true
});
//
// Load Geonames postal code data from the import/ directory
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.csv('gn_pc_1.0.tsv', {sep: 'TAB', nullValues: ['']})
  YIELD lineNo, map, list
", "
  WITH map
    MERGE (n:CA_POST_CODE {uid: REPLACE(map.code, ' ', '')})
      SET
        n.place_name = CASE EXISTS(n.place_name) WHEN TRUE THEN n.place_name + [map.place] ELSE [map.place] END,
        n.lat_list = CASE EXISTS(n.lat_list) WHEN TRUE THEN n.lat_list + [TOFLOAT(map.latitude)] ELSE [TOFLOAT(map.latitude)] END,
        n.lng_list = CASE EXISTS(n.lng_list) WHEN TRUE THEN n.lng_list + [TOFLOAT(map.longitude)] ELSE [TOFLOAT(map.longitude)] END
  WITH n
    SET
      n.location =  POINT({latitude: apoc.coll.sum(n.lat_list)/SIZE(n.lat_list), longitude: apoc.coll.sum(n.lng_list)/SIZE(n.lng_list), crs: 'WGS-84'});
",
{
    batchSize:1000, iterateList:true, parallel:true
});
//
MATCH (n:CA_POST_CODE)
  WHERE NOT(EXISTS(n.location))
  SET n.location = n.centroid;
//
////////////////////////////////////////////////////////////////////////////////
