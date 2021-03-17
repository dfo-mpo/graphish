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
CREATE CONSTRAINT ON (n:D) ASSERT n.uid IS UNIQUE;
// - uid: the unique identifier of a document (e.g. file name)
//
// Sentence
//
CREATE CONSTRAINT ON (n:S) ASSERT n.uid IS UNIQUE;
//
CREATE INDEX ON :Sent(c);
// - c is the textual content, it is  indexed
CREATE INDEX ON :Sent(s);
// - s is the sentiment score, it is an indexed integer
CREATE INDEX ON :Sent(n);
// - n is the numner of occurences of the sentence
//
// Named Entity
//
CREATE CONSTRAINT ON (n:NE) ASSERT n.c IS UNIQUE;
// - c is the textual content, it is unique and indexed
CREATE CONSTRAINT ON (n:CARDINAL) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:DATE) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:EVENT) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:FAC) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:GPE) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:LAW) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:LANGUAGE) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:LOC) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:MONEY) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:NORP) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:ORDINAL) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:ORG) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:PERCENT) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:PERSON) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:PRODUCT) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:QUANTITY) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:TIME) ASSERT n.c IS UNIQUE;
CREATE CONSTRAINT ON (n:WORK_OF_ART) ASSERT n.c IS UNIQUE;
// - the entity type label (18 named entity types, e.g. PERSON)
CREATE INDEX ON :NE(n);
// - n is the number of occurences of the entity
//
// Key Phrase
//
CREATE CONSTRAINT ON (n:KP) ASSERT n.c IS UNIQUE;
// - c is the textual content, it is unique and indexed
CREATE INDEX ON :KP(n);
// - n is the numner of occurences of the key phrase
//
// Lemmatized word
//
CREATE CONSTRAINT ON (n:LW) ASSERT n.l IS UNIQUE;
// - l is the lemma form of the text, it is unique and indexed
CREATE INDEX ON :LW(n);
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
// Geonames data: all node labels have 'GN_' as prefix
//
// Feature Codes
//
CREATE CONSTRAINT ON (n:GN_FC) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :GN_FC(name);
CREATE INDEX ON :GN_FC(desc);
//
// Named locations
//
CREATE CONSTRAINT ON (n:GN_NE) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :GN_NE(name);
CREATE INDEX ON :GN_NE(ascii_name);
CREATE INDEX ON :GN_NE(alt_names);
CREATE INDEX ON :GN_NE(feature);
CREATE INDEX ON :GN_NE(location);
CREATE INDEX ON :GN_NE(admin_code);
CREATE INDEX ON :GN_NE(population);
//
// Postal codes
//
CREATE CONSTRAINT ON (n:GN_PC) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :GN_PC(place_name);
CREATE INDEX ON :GN_PC(location);
CREATE INDEX ON :GN_PC(centroid);
//
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
// British Columbia First Nations data: all node labels have 'FN_' as prefix
//
// First Nation Entity
//
CREATE CONSTRAINT ON (n:FN_E) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :FN_E(name);
CREATE INDEX ON :FN_E(address);
CREATE INDEX ON :FN_E(location);
//
// First Nation Group
//
CREATE CONSTRAINT ON (n:FN_G) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :FN_G(name);
//
// First Nation Region
//
CREATE CONSTRAINT ON (n:FN_R) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :FN_R(name);
//
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
// Project specific data
//
CREATE CONSTRAINT ON (n:PARR_PR) ASSERT n.uid IS UNIQUE;
CREATE INDEX ON :PARR_PR(pid);
CREATE INDEX ON :PARR_PR(name);
CREATE INDEX ON :PARR_PR(desc);
//
// Project Contact
//
CREATE CONSTRAINT ON (n:Person) ASSERT n.name IS UNIQUE;
CREATE INDEX ON :Person(tel);
CREATE INDEX ON :Person(email);
//
// Project Organization
//
CREATE CONSTRAINT ON (n:PR_ORG) ASSERT n.uid IS UNIQUE;
//
// Project Location
//
CREATE CONSTRAINT ON (n:PR_LOC) ASSERT n.uid IS UNIQUE;
//
// DFO Area
//
CREATE CONSTRAINT ON (n:DFO_Area) ASSERT n.uid IS UNIQUE;
//
// Policy and Program Connections
//
CREATE CONSTRAINT ON (n:PR_Policy) ASSERT n.uid IS UNIQUE;
//
// G&C Funding Sources
//
CREATE CONSTRAINT ON (n:PR_FndSrc) ASSERT n.uid IS UNIQUE;
//
// Project Phase
//
CREATE CONSTRAINT ON (n:PR_Phase) ASSERT n.uid IS UNIQUE;
//
// Project Primary Activities
//
CREATE CONSTRAINT ON (n:PR_PrmAct) ASSERT n.uid IS UNIQUE;
//
// Eco System Types
//
CREATE CONSTRAINT ON (n:EcoSysTyp) ASSERT n.uid IS UNIQUE;
//
// Target Species
//
CREATE CONSTRAINT ON (n:TgtSpc) ASSERT n.uid IS UNIQUE;
//
// Life Stages
//
CREATE CONSTRAINT ON (n:LfeStg) ASSERT n.uid IS UNIQUE;
//
// Restoration Activities
//
CREATE CONSTRAINT ON (n:ResAct) ASSERT n.uid IS UNIQUE;
//
// Habitat Outcome Metric
//
CREATE CONSTRAINT ON (n:HbtOutMtr) ASSERT n.uid IS UNIQUE;
//
// Socio-Economic Outcome
//
CREATE CONSTRAINT ON (n:SocEcoOut) ASSERT n.uid IS UNIQUE;
//
// Monitoring objectives
//
CREATE CONSTRAINT ON (n:MonObj) ASSERT n.uid IS UNIQUE;
//
// Monitoring activites
//
CREATE CONSTRAINT ON (n:MonAct) ASSERT n.uid IS UNIQUE;
//
// Monitoring design
//
CREATE CONSTRAINT ON (n:MonDsg) ASSERT n.uid IS UNIQUE;
//
// Season monitored
//
CREATE CONSTRAINT ON (n:SeaMon) ASSERT n.uid IS UNIQUE;
//
// Life Stage monitored
//
CREATE CONSTRAINT ON (n:LfeStgMon) ASSERT n.uid IS UNIQUE;
//
// Other Species
//
CREATE CONSTRAINT ON (n:OthSpc) ASSERT n.uid IS UNIQUE;
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
    MERGE (e:NE {c: entity.c})
      ON CREATE SET e.n = 1
      ON MATCH SET e.n = e.n + 1
    MERGE (n)<-[r:E_IN_D]-(e)
      ON CREATE SET r.n = 1
      ON MATCH SET r.n = r.n + 1
  WITH n, sentence, e, entity
    CALL apoc.create.addLabels(e, [entity.t]) YIELD node
  WITH n, sentence, node AS e, entity
    UNWIND entity.w AS word
      MERGE (w:LW {l: word.l})
        ON CREATE SET w.n = 1
        ON MATCH SET w.n = w.n + 1
      MERGE (e)<-[r:W_IN_E]-(w)

  WITH n, sentence
    UNWIND sentence.k AS key_phrase
  WITH n, sentence, key_phrase
    MERGE (k:KP {c: key_phrase.c})
      ON CREATE SET k.n = 1
      ON MATCH SET k.n = k.n + 1
    MERGE (n)<-[r:K_IN_D]-(k)
      ON CREATE SET r.n = 1
      ON MATCH SET r.n = r.n + 1
  WITH n, sentence, k, key_phrase
    UNWIND key_phrase.w AS word
      MERGE (w:LW {l: word.l})
        ON CREATE SET w.n = 1
        ON MATCH SET w.n = w.n + 1
      MERGE (k)<-[r:W_IN_K]-(w)
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
