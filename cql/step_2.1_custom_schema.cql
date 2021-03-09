// Note: This script will be processed by neo4j-shell utility
// All comments in Java Style: line preceded by //
// Its syntax must be list of cypher queries and neo4j-shell commands
// separated by ';'
//
// CONSTRAINTS AND INDEXES
//
// 1. Create unique constraint
// CREATE CONSTRAINT ON (n:Label) ASSERT n.property IS UNIQUE;
//
// 2. Create a single-property index
// CREATE INDEX ON :Label(property);
//
// 3. Create a composite index
// CREATE INDEX ON :Label(prop1, …​, propN);
//
// 4. Create node property existence constraint
// CREATE CONSTRAINT ON (n:Label) ASSERT EXISTS(n.property);
//
// 5. Create relationship property existence constraint
// CREATE CONSTRAINT ON ()-[r:relationshipType]-() ASSERT EXISTS(r.property);
//
// 6. Create a Node Key
// ASSERT (variable.propertyName_1, …​, variable.propertyName_n) IS NODE KEY;
//
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
// NLP data: all node labels have 'NLP_' as prefix
//
////////////////////////////////////////////////////////////////////////
//
// Document
//
CREATE CONSTRAINT ON (n:DOCUMENT) ASSERT n.uid IS UNIQUE;
// - uid: the unique identifier of a document (e.g. file name)
//
// Sentence
//
CREATE CONSTRAINT ON (n:SENTENCE) ASSERT n.uid IS UNIQUE;
//
CREATE INDEX ON :SENTENCE(c);
// - c is the textual content, it is  indexed
CREATE INDEX ON :SENTENCE(s);
// - s is the sentiment score, it is an indexed integer
CREATE INDEX ON :SENTENCE(n);
// - n is the numner of occurences of the sentence
//
// Named Entity
//
CREATE CONSTRAINT ON (n:NAMED_ENTITY) ASSERT n.c IS UNIQUE;
// - c is the textual content, it is unique and indexed
CREATE CONSTRAINT ON (n:NAMED_ENTITY_CARDINAL) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_DATE) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_EVENT) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_FAC) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_GPE) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_LAW) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_LANGUAGE) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_LOC) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_MONEY) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_NORP) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_ORDINAL) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_ORG) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_PERCENT) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_PERSON) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_PRODUCT) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_QUANTITY) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_TIME) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NAMED_ENTITY_WORK_OF_ART) ASSERT n.c IS UNIQUE;
// - the entity type label (18 named entity types, e.g. PERSON)
CREATE INDEX ON :NAMED_ENTITY(n);
// - n is the number of occurences of the entity
//
// Key Phrase
//
CREATE CONSTRAINT ON (n:KEY_PHRASE) ASSERT n.c IS UNIQUE;
// - c is the textual content, it is unique and indexed
CREATE INDEX ON :KEY_PHRASE(n);
// - n is the numner of occurences of the key phrase
//
// Lemmatized word
//
CREATE CONSTRAINT ON (n:WORD) ASSERT n.l IS UNIQUE;
// - l is the lemma form of the text, it is unique and indexed
CREATE INDEX ON :WORD(n);
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
// Geonames data: all node labels have 'GN_' as prefix
//
// Feature Codes
//
CREATE CONSTRAINT ON (n:GEO_FEATURE) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :GEO_FEATURE(name);
CREATE INDEX ON :GEO_FEATURE(desc);
//
// Named locations
//
CREATE CONSTRAINT ON (n:GEO_LOCATION) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :GEO_LOCATION(name);
CREATE INDEX ON :GEO_LOCATION(ascii_name);
CREATE INDEX ON :GEO_LOCATION(alt_names);
CREATE INDEX ON :GEO_LOCATION(feature);
CREATE INDEX ON :GEO_LOCATION(location);
CREATE INDEX ON :GEO_LOCATION(admin_code);
CREATE INDEX ON :GEO_LOCATION(population);
//
// Postal codes
//
CREATE CONSTRAINT ON (n:CA_POST_CODE) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :CA_POST_CODE(place_name);
CREATE INDEX ON :CA_POST_CODE(location);
CREATE INDEX ON :CA_POST_CODE(centroid);
//
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
// British Columbia First Nations data: all node labels have 'FN_' as prefix
//
// First Nation Entity
//
CREATE CONSTRAINT ON (n:BC_FIRST_NATION) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :BC_FIRST_NATION(name);
CREATE INDEX ON :BC_FIRST_NATION(address);
CREATE INDEX ON :BC_FIRST_NATION(location);
//
// First Nation Group
//
CREATE CONSTRAINT ON (n:BC_NATION_COUNCIL) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :BC_NATION_COUNCIL(name);
//
// First Nation Region
//
CREATE CONSTRAINT ON (n:BC_GEO_REGION) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :BC_GEO_REGION(name);
//
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
// Project specific data
//
CREATE CONSTRAINT ON (n:PROJECT) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :PROJECT(pid);
CREATE INDEX ON :PROJECT(name);
CREATE INDEX ON :PROJECT(desc);
//
// Project Contact
//
CREATE CONSTRAINT ON (n:CONTACT_PERSON) ASSERT n.name IS UNIQUE;
CREATE INDEX ON :CONTACT_PERSON(tel);
CREATE INDEX ON :CONTACT_PERSON(email);
//
// Project Organization
//
CREATE CONSTRAINT ON (n:ORGANIZATION) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :ORGANIZATION(name);
//
// GC Funding Sources
//
CREATE CONSTRAINT ON (n:GC_FUNDING_SOURCE) ASSERT n.uid IS UNIQUE;
//
// Project Location
//
CREATE CONSTRAINT ON (n:WATERSHED) ASSERT n.uid IS UNIQUE;
//
// DFO Area
//
CREATE CONSTRAINT ON (n:DFO_AREA) ASSERT n.uid IS UNIQUE;
//
// Policy and Program Connections
//
CREATE CONSTRAINT ON (n:POLICY_PROGRAM) ASSERT n.uid IS UNIQUE;
//
// Project Phase
//
CREATE CONSTRAINT ON (n:PROJECT_PHASE) ASSERT n.uid IS UNIQUE;
//
// Eco System Types
//
CREATE CONSTRAINT ON (n:ECO_SYSTEM_TYPE) ASSERT n.uid IS UNIQUE;
//
// Project Primary Activities
//
CREATE CONSTRAINT ON (n:PROJECT_ACTIVITY) ASSERT n.uid IS UNIQUE;
//
// Species
//
CREATE CONSTRAINT ON (n:SPECIES) ASSERT n.uid IS UNIQUE;
CREATE CONSTRAINT ON (n:TARGET_SPECIES) ASSERT n.uid IS UNIQUE;
//
// Life Stages
//
CREATE CONSTRAINT ON (n:LIFE_STAGE) ASSERT n.uid IS UNIQUE;
//
// Restoration Activities
//
CREATE CONSTRAINT ON (n:RESTORATION_ACTIVITY) ASSERT n.uid IS UNIQUE;
//
// Habitat Outcome Metric
//
CREATE CONSTRAINT ON (n:HABITAT_OUTCOME_METRIC) ASSERT n.uid IS UNIQUE;
//
// Monitoring objectives
//
CREATE CONSTRAINT ON (n:MONITORING_OBJECTIVE) ASSERT n.uid IS UNIQUE;
//
// Monitoring activites
//
CREATE CONSTRAINT ON (n:MONITORING_ACTIVITY) ASSERT n.uid IS UNIQUE;
//
// Monitoring design
//
CREATE CONSTRAINT ON (n:MONITORING_DESIGN) ASSERT n.uid IS UNIQUE;
//
// Season monitored
//
CREATE CONSTRAINT ON (n:SEASON_MONITORED) ASSERT n.uid IS UNIQUE;
//
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
// List all constraints
CALL db.constraints();
//
// List all indexes
CALL db.indexes();
//
// Wait for all indexes online
CALL db.awaitIndexes();
//
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Call the nlp micro service to process the documents.
//
CALL apoc.custom.asProcedure(
  'nlp_import',
  'WITH $n AS n
    CALL apoc.load.jsonParams($nlp_service, {method: "POST"}, $input)
      YIELD value
  WITH n, value
    UNWIND value AS document
  WITH n, document
    UNWIND document.p AS sentence

  WITH n, sentence
    UNWIND sentence.e AS entity
  WITH n, sentence, entity
    MERGE (e:NAMED_ENTITY {c: entity.c})
      ON CREATE SET e.n = 1
      ON MATCH SET e.n = e.n + 1
    MERGE (n)-[r:HAS_NAMED_ENTITY]->(e)
      ON CREATE SET r.n = 1
      ON MATCH SET r.n = r.n + 1
  WITH n, sentence, e, entity
    CALL apoc.create.addLabels(e, ["NAMED_ENTITY_" + entity.t]) YIELD node
  WITH n, sentence, node AS e, entity
    UNWIND entity.w AS word
      MERGE (w:WORD {l: word.l})
        ON CREATE SET w.n = 1
        ON MATCH SET w.n = w.n + 1
      MERGE (e)-[r:HAS_WORD]->(w)

  WITH n, sentence
    UNWIND sentence.k AS key_phrase
  WITH n, sentence, key_phrase
    MERGE (k:KEY_PHRASE {c: key_phrase.c})
      ON CREATE SET k.n = 1
      ON MATCH SET k.n = k.n + 1
    MERGE (n)-[r:HAS_KEY_PHRASE]->(k)
      ON CREATE SET r.n = 1
      ON MATCH SET r.n = r.n + 1
  WITH n, sentence, k, key_phrase
    UNWIND key_phrase.w AS word
      MERGE (w:WORD {l: word.l})
        ON CREATE SET w.n = 1
        ON MATCH SET w.n = w.n + 1
      MERGE (k)-[r:HAS_WORD]->(w)
        ON CREATE SET r.c = word.c
  RETURN n AS result;',
  'write',
  [['result','NODE']],
  [['n','NODE'], ['nlp_service','STRING'], ['input','STRING']]
);
//
CALL apoc.custom.list;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// CALL apoc.custom.list;
//
// CALL apoc.custom.removeProcedure('nlp_import');
//
////////////////////////////////////////////////////////////////////////////////
