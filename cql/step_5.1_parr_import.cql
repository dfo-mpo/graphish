////////////////////////////////////////////////////////////////////////////////
//
// DFO Area
//
UNWIND [
	['FIA', 'Fraser and Interior Area'],
	['NCA', 'North Coast Area'],
	['SCA', 'South Coast Area'],
	['Yukon', 'Yukon']
] AS dfo_area
WITH dfo_area
	MERGE (n:DFO_AREA {uid: dfo_area[0]})
		SET
			n.name = dfo_area[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Policy and Program Connections
//
UNWIND [
	['Species At Risk Act (SARA) Recovery Plans', 'Project supports implementation of priority activities described in federal recovery strategies, action plans or management plans for listed Species at Risk.'],
	['COSEWIC Assessed Populations', 'Activities targeting species without federal recovery documents that seek to address habitats, threats and other considerations identified in COSEWIC assessments.'],
	['WSP Implementation', 'Activities contribute to the WSP Implementation Plan at the watershed/CU level to advance Implementation Strategies.'],
	['Fisheries Act Rebuilding Plans', 'Placeholder to be defined.'],
	['Southern BC Chinook Initiative', 'Activities directly link to SBC high-level strategic plan that includes trends in aggregated CU and habitat status, limiting factors and threats, objectives, and management strategies.']
] AS pr_policy
WITH pr_policy
	MERGE (n:POLICY_PROGRAM {uid: pr_policy[0]})
		SET
			n.name = pr_policy[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// G&C Funding Sources
//
UNWIND [
	['AFSAR', 'Aboriginal Fund for Species at Risk'],
	['AHRF', 'Aquatic Habitat Restoration Fund'],
	['BCSRIF', 'British Columbia Salmon Restoration Innovation Fund'],
	['CNFASAR', 'Canadian Nature Fund for Aquatic Species at Risk'],
	['CRF', 'Coastal Restoration Fund'],
	['FHRI', 'Fisheries Habitat Restoration Initiative '],
	['HSP', 'Habitat Stewardship Program for Aquatic Species at Risk'],
	['IHPP', 'Indigenous Habitat Participation Program'],
	['SEP', 'Salmon Enhancement Program'],
	['RFCPP', 'Recreational Fisheries Conservation Partnership Program']
] AS pr_fndsrc
WITH pr_fndsrc
	MERGE (n:GC_FUNDING_PROGRAM {uid: pr_fndsrc[0]})
		SET
			n.name = pr_fndsrc[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Project Phase
//
UNWIND [
	['Proposed', 'A project that has been proposed, but has not undergone the planning and design and feasibility phase.'],
	['Planning', 'A proposed project in the developmental and technical planning stage, typically undergoing design and feasibility analysis.'],
	['Active', 'A project that is currently underway and being implemented (i.e. the project is being physically executed including activities such as construction, maintenance, site assessment, etc.).'],
	['Completed', 'A project that was implemented and completed. This project may or may not be maintained and/or monitored after completion.']
] AS pr_phase
WITH pr_phase
	MERGE (n:PROJECT_PHASE {uid: pr_phase[0]})
		SET
			n.name = pr_phase[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Project Primary Activities
//
UNWIND [
	['Design and Feasibility', 'The development, technical planning, and/or feasibility analysis of a restoration project not in the project implementation stage (i.e. the actual physical application of a project).'],
	['Decommissioning', 'The planned shut-down or removal of infrastructure, equipment, facilities, etc. from operation or usage.'],
	['Implementation', 'The physical application of tasks for a project resulting from planning (e.g. habitat or infrastructure construction, earth moving, improvements to physical infrastructure, consultations/workshops).'],
	['Maintenance', 'The physical application of tasks for a project on existing infrastructure with the intention of maintaining and/or modifying existing efficiency (i.e. not improvement).'],
	['Stewardship', 'The application of tasks for a project with a large component of community involvement to promote salmon stewardship and salmon watershed conservation (e.g. Stream to Sea Education Program).'],
	['Research and Monitoring', 'The application of research/monitoring tasks for a project with the intention of data collection to address information gaps. This can include the collection of baseline information to inform design.']
] AS pr_prmact
WITH pr_prmact
	MERGE (n:PROJECT_ACTIVITY {uid: pr_prmact[0]})
		SET
			n.name = pr_prmact[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Eco System Types
//
UNWIND [
	['Freshwater', 'Aquatic ecosystem with naturally occurring water that is neither seawater or brackish. Includes lakes, ponds, rivers, streams, and creeks. Includes Riparian.'],
	['Estuarine', 'Aquatic ecosystem with naturally occurring water that is brackish and found at the interface where freshwater, usually from river and streams, mix with saltwater from the ocean.'],
	['Marine', 'Aquatic ecosystem with naturally occurring water that is saltwater']
] AS ecosystyp
WITH ecosystyp
	MERGE (n:ECO_SYSTEM_TYPE {uid: ecosystyp[0]})
		SET
			n.name = ecosystyp[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Target Species
//
UNWIND [
	['BT', 'Bull Trout (Salvelinus confluentus) targeted in restoration activities.'],
	['CH', 'Chinook Salmon (Oncorhynchus tshawytscha) targeted in restoration activities.'],
	['CM', 'Chum Salmon (Oncorhynchus keta) targeted in restoration activities.'],
	['CO', 'Coho Salmon (Oncorhynchus kisutch) targeted in restoration activities.'],
	['CT', 'Cutthroat Trout (Oncorhynchus clarkii) targeted in restoration activities.'],
	['DV', 'Dolly Varden (Salvelinus malma) targeted in restoration activities.'],
	['PK', 'Pink Salmon (Oncorhynchus gorbuscha) targeted in restoration activities.'],
	['RB', 'Rainbow Trout (Oncorhynchus mykiss) targeted in restoration activities.'],
	['UDC', 'Umatilla Dace (Rhynichthys umatilla) targeted in restoration activities.'],
	['SG', 'Sturgeon (General) targeted in restoration activities.'],
	['SK', 'Sockeye Salmon (Oncorhynchus nerka) targeted in restoration activities.'],
	['SSU', 'Salish Sucker (Catostomus sp.) targeted in restoration activities.'],
	['ST', 'Steelhead (Oncorhynchus mykiss) targeted in restoration activities.'],
	['WCT', 'Westslope (Yellowstone) Cutthroat Trout (Oncorhynchus clarki lewisi) targeted in restoration activities.'],
	['WSG', 'White Sturgeon (Acipenser transmontanus) targeted in restoration activities.'],
	['Other', 'Other aquatic species targeted in restoration activites provided as a list using the following format:  CCA, NP, intertidal bivalves.']
] AS tgtspc
WITH tgtspc
	MERGE (n:TARGET_SPECIES:SPECIES {uid: tgtspc[0]})
		SET
			n.name = tgtspc[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Life Stages
//
UNWIND [
	['Returning adult', 'Migrating adult and spawner stages.'],
	['Estuarine juvenile', 'Marine and estuarine rearing life stages as juveniles grow into adults.'],
	['Freshwater juvenile', 'Freshwater rearing and over-wintering life stages including fry, parr, and migrating smolt.'],
	['Incubation', 'Inter-gravel development phase including the egg and alevin life cycle stages.']
] AS lfestg
WITH lfestg
	MERGE (n:LIFE_STAGE {uid: lfestg[0]})
		SET
			n.name = lfestg[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Restoration Activities
//
UNWIND [
	['Fish passage', 'Removal and/or remediation of obstructions to improve access to habitat above and below those obstructions. Includes maintenance and effectiveness monitoring of fish passage removal structures.'],
	['Riparian restoration and management', 'Restoration activities focused on re-establishing riparian habitat (e.g. riparian planting, riparian fencing, riparian bank stabilization, invasive species control, treatment, etc.). Includes maintenance and effectiveness monitoring of riparian habitat.'],
	['Estuarine restoration', 'Restoration activities focused on re-establishing estuarine habitat (e.g. distributary channels, breaching, marsh building, eelgrass planting, invasive species control, etc.). Includes maintenance and effectiveness monitoring of estuarine habitat.'],
	['Nearshore and marine restoration', 'Restoration activities focused on re-establishing nearshore and marine habitat (e.g. bull-kelp planting, saltmarsh bench creation, shoreline stabilization, invasive species control, etc.). Includes maintenance and effectiveness monitoring of nearshore and marine habitat.'],
	['Instream structure', 'Restoration activities involving rehabilitation or manipulation of instream habitat through the placement of natural and/or man-made materials (e.g. LWD, rocks, boulders, gravel, instream bank stabilization, etc.) to support channel structure and function. Includes maintenance and effectiveness monitoring of instream habitat.'],
	['Instream flow', 'Restoration activities focused on re-establishing instream flow regimes (e.g. water storage and releases, reducing water withdrawals, etc). Includes maintenance and effectiveness monitoring of instream flow.'],
	['Floodplain connectivity', 'Restoration activities that improves floodplain connectivity. For example, activities that include the development of alcoves, side channels, off-channels and groundwater channels that lie adjacent to and connect to the main river stem. Includes maintenance and effectiveness monitoring of floodplain connectivity.'],
	['Watershed planning and assessment', 'Broad implementation of high-level watershed recovery plans including stakeholder involvement and management action. Includes watershed assessments to identify restoration options and sequencing.'],
	['Nutrient supplementation', 'Activities focussed on improving the physical, chemical and biological characteristics of freshwater stream and lake habitats (e.g. carcass placement, stream and lake fertilization, etc.).'],
	['NA', 'No restoration activities were completed.']
] AS resact
WITH resact
	MERGE (n:RESTORATION_ACTIVITY {uid: resact[0]})
		SET
			n.name = resact[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Habitat Outcome Metric
//
UNWIND [
	['Number of obstructions removed', 'The total number of obstructions removed for fish passage. Obstructions include dams, road crossings, berms, tidal gates, culverts or any other feature that impedes the upstream or downstream movement of fish.'],
	['Number of fish screens installed', 'The total number of fish screens installed to prevent fish from being drawn into a aqueduct, water intake, dam, or other diversion on a river, lake, or waterway.'],
	['Stream lengths (km) habitat made accessible', 'The total square-metres of habitat maintained after fish passage restoration activities have been implemented (e.g. removal or remediation of an obstruction). Obstructions include dams, road crossings, berms, tidal gates, culverts or any other feature that impedes the upstream or downstream movement of fish.'],
	['Square-metres habitat maintained', 'The total stream lengths (km) of habitat maintained after fish passage restoration activities have been implemented (e.g. removal or remediation of an obstruction). Obstructions include dams, road crossings, berms, tidal gates, culverts or any other feature that impedes the upstream or downstream movement of fish.'],
	['Stream lengths (m) habitat maintained', 'The total square-metres of habitat monitored after fish passage restoration activities have been implemented (e.g. removal or remediation of an obstruction). Obstructions include dams, road crossings, berms, tidal gates, culverts or any other feature that impedes the upstream or downstream movement of fish.'],
	['Square-metres habitat monitored', 'The total stream lengths (km) of habitat monitored after fish passage restoration activities have been implemented (e.g. removal or remediation of an obstruction). Obstructions include dams, road crossings, berms, tidal gates, culverts or any other feature that impedes the upstream or downstream movement of fish.'],
	['Stream lengths (m) habitat monitored', 'The total square-metres of habitat (e.g. riparian, instream, floodplain, estuarine, nearshore, etc.) made accessible for fish passage after the removal or remediation of an obstruction. Obstructions include dams, road crossings, berms, tidal gates, culverts or any other feature that impedes the upstream or downstream movement of fish.'],
	['Square-metres habitat made accessible', 'The total stream lengths (km) of habitat (e.g. riparian, instream, floodplain etc.) made accessible for fish passage after the removal or remediation of an obstruction. Obstructions include dams, road crossings, berms, tidal gates, culverts or any other feature that impedes the upstream or downstream movement of fish.'],
	['Square-metres riparian habitat treated', 'The total square-metres of riparian habitat treated through activities such as riparian planting, stand management, riparian fencing, bank stabilization, invasive species control, and riparian treatment.'],
	['Square-metres riparian habitat created', 'The total square-metres of riparian habitat created through activities such as riparian planting.'],
	['Stream lengths (m) riparian habitat treated', 'The total stream lengths (m) of riparian habitat treated through activities such as riparian planting, riparian fencing, bank stabilization, invasive species control, and riparian treatment.'],
	['Stream lengths (m) riparian habitat created', 'The total stream lengths (m) of riparian habitat created through activities such as riparian planting. '],
	['Square-metres riparian habitat maintained', 'The total square-metres of riparian habitat maintained after riparian restoration activities have been implemented (e.g. riparian planting, riparian fencing, bank stabilization, invasive species control, and riparian treatment).'],
	['Stream lengths (m) riparian habitat maintained', 'The total stream lengths (m) of riparian habitat maintained after riparian restoration activities have been implemented (e.g. riparian planting, riparian fencing, bank stabilization, invasive species control, and riparian treatment).'],
	['Square-metres riparian habitat monitored', 'The total square-metres of riparian habitat monitored after riparian restoration activities have been implemented (e.g. riparian planting, riparian fencing, bank stabilization, invasive species control, and riparian treatment).'],
	['Stream lengths (m) riparian habitat monitored', 'The total stream lengths (m) of riparian habitat monitored after riparian restoration activities have been implemented (e.g. riparian habitat treated or created through riparian planting, riparian fencing, bank stabilization, invasive species control, and riparian treatment).'],
	['Square-metres estuarine habitat treated', 'The total square-metres of estuarine habitat treated through activities such as distributary channeling, breaching, marsh building, estuarine vegetation transplanting, and invasive species control.'],
	['Square-metres estuarine habitat created', 'The total square-metres of estuarine habitat created through activities such as marsh building and eelgrass planting.'],
	['Square-metres estuarine habitat maintained', 'The total square-metres of estuarine habitat maintained after estuarine restoration activities have been implemented (e.g. distributary channeling, breaching, marsh building, eelgrass planting, and invasive species control).'],
	['Square-metres estuarine habitat monitored', 'The total square-metres of estuarine habitat monitored after estuarine restoration activities have been implemented (e.g. distributary channeling, breaching, marsh building, eelgrass planting, and invasive species control).'],
	['Square-metres nearshore and marine habitat treated', 'The total square-metres of nearshore and marine habitat treated through activities such as nearshore and marine vegetation transplanting, shoreline stabilization, and invasive species control.'],
	['Square-metres nearshore and marine habitat created', 'The total square-metres of nearshore and marine habitat created through activities such as bull-kelp planting and saltmarsh bench creation.'],
	['Length (m) marine shoreline treated', 'he total length (m) of marine shoreline treated through activities such as nearshore and marine vegetation transplanting, saltmarsh bench creation, shoreline stabilization, invasive species control.'],
	['Length (m) marine shoreline created', 'The total length (m) of marine shoreline created through activities such as bull-kelp planting and saltmarsh bench creation.'],
	['Square-metres nearshore and marine habitat maintained', 'The total square-metres of nearshore and marine habitat maintained after nearshore/marine restoration activities have been implemented (e.g. bull-kelp planting, saltmarsh bench creation, shoreline stabilization, invasive species control).'],
	['Lengths (m) marine shoreline maintained', 'The total length (m) of marine shoreline maintained after nearshore/marine restoration activities have been implemented (e.g. bull-kelp planting, saltmarsh bench creation, shoreline stabilization, invasive species control).'],
	['Square-metres nearshore and marine habitat monitored', 'The total square-metres of nearshore and marine habitat monitored after nearshore/marine restoration activities have been implemented (e.g. bull-kelp planting, saltmarsh bench creation, shoreline stabilization, invasive species control).'],
	['Length (m) marine shoreline monitored', 'The total length (m) of marine shoreline monitored after nearshore/marine restoration activities have been implemented (e.g. bull-kelp planting, saltmarsh bench creation, shoreline stabilization, invasive species control).'],
	['Square-metres instream habitat treated', 'The total square-metres of instream habitat treated through activities such as the placement of natural and/or man-made materials (e.g. LWD, rocks, boulders, and gravel) to support channel structure and function.'],
	['Square-metres instream habitat created', 'The total square-metres of instream habitat created through activities such as the placement of natural and/or man-made materials (e.g. LWD, rocks, boulders, and gravel) to support channel structure and function.'],
	['Stream lengths (m) instream habitat treated', 'The total stream lengths (m) of instream habitat treated through activities such as the placement of natural and/or man-made materials (e.g. LWD, rocks, boulders, and gravel) to support channel structure and function.'],
	['Stream lengths (m) instream habitat created', 'The total stream lengths (m) of instream habitat created through activities such as the placement of natural and/or man-made materials (e.g. LWD, rocks, boulders, and gravel) to support channel structure and function.'],
	['Square-metres instream habitat maintained', 'The total square-metres of instream habitat maintained after instream restoration activities have been implemented (e.g. placement of natural and/or man-made materials such as LWD, rocks, boulders, and gravel).'],
	['Stream lengths (m) instream habitat maintained', 'The total stream lengths (m) of instream habitat maintained after instream restoration activities have been implemented (e.g. placement of natural and/or man-made materials such as LWD, rocks, boulders, and gravel).'],
	['Square-metres instream habitat monitored', 'The total square-metres of instream habitat monitored after instream restoration activities have been implemented (e.g. placement of natural and/or man-made materials such as LWD, rocks, boulders, and gravel).'],
	['Stream lengths (m) instream habitat monitored', 'The total stream lengths (m) of instream habitat monitored after instream restoration activities have been implemented (e.g. placement of natural and/or man-made materials such as LWD, rocks, boulders, and gravel).'],
	['Number of water use plans developed/implemented', 'The total number of water use plans developed and implemented to manage flow releases during critical flow periods.'],
	['Number of real-time hydrometer stations installed', 'The total number of real-time hydrometer stations installed measuring water flows, levels, sediment, and temperature.'],
	['Number of real-time hydrometer stations maintained', 'The total number of real-time hydrometers stations maintained after installment that measure water flows, levels, sediment, and temperature.'],
	['Square-metres floodplain habitat treated', 'The total square-metres of floodplain habitat treated resulting in improved floodplain connectivity. Floodplain restoration activities may include restoring or building new alcoves, side channels, off-channels, and groundwater channels.'],
	['Square-metres floodplain habitat created', 'The total square-metres of floodplain habitat created resulting in improved floodplain connectivity. Floodplain restoration activities may include restoring or building new alcoves, side channels, off-channels, and groundwater channels.'],
	['Square-metres floodplain habitat made accessible', 'The total square-metres of floodplain habitat made accessible through activities such as the removal of an obstruction(s) or the restoration of a floodplain feature such as alcoves, side channels, off-channels, and groundwater channels'],
	['Square-metres floodplain habitat maintained', 'The total square-metres of floodplain habitat maintained after floodplain restoration activities have been implemented (i.e. after the creation of alcoves, side channels, off-channels, and groundwater channels).'],
	['Square-metres floodplain habitat monitored', 'The total square-metres of floodplain habitat monitored after floodplain restoration activities have been implemented (i.e. after the creation of alcoves, side channels, off-channels, and groundwater channels).'],
	['Number of watershed plans and assessments completed', 'The total number of watershed plans and assessments produced through technical committees, working groups, etc.'],
	['Number of recovery plans completed', 'The total number of recovery plans completed through COSEWIC, SARA, etc. processes.'],
	['Mass (kg) of fertilizer applied', 'The total mass (kg) of fertilizer applied to a waterbody with the goal of enhancing nutrients and productivity.'],
	['Volume (L) of fertilizer applied', 'The total volume (L) of fertilizer applied to a waterbody with the goal of enhancing nutrients and productivity.'],
	['Number of salmon carcasses placed', 'The total number of salmon carcasses placed near a waterbody with the goal of enhancing nutrient and productivity.'],
	['Biomass (kg) of salmon carcasses placed', 'The total biomass (kg) of salmon carcasses placed near a waterbody with the goal of enhancing nutrient and productivity.']
] AS hbtoutmtr
WITH hbtoutmtr
	MERGE (n:HABITAT_OUTCOME_METRIC {uid: hbtoutmtr[0]})
		SET
			n.name = hbtoutmtr[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Socio-Economic Outcome
//
UNWIND [
	['Number of volunteers involved', 'Number of volunteers involved in the planning and/or implementation of a restoration project.'],
	['Number of hours of volunteer time donated', 'Number of volunteer hours donated to the planning and/or implementation of a restoration project.'],
	['Number of volunteer person days donated', 'Number of volunteer days donated to the planning and/or implementation of a restoration project.'],
	['Number of schools involved', 'Number of schools involved in the planning and/or implementation of a restoration project.'],
	['Number of classes involved', 'Number of classes involved in the planning and/or implementation of a restoration project.'],
	['Number of jobs created', 'Number of part-time and/or full-time employment opportunities created that employ indigenous and non-indigenous peoples.'],
	['Number of employment days created', 'Number of days of part-time and/or full-time employment opportunities created that employ indigenous and non-indigenous peoples.'],
	['Number of public engagement events', 'Number of days of public engagement events hosted as part of a restoration project. Includes educational/stewardship activities, local stakeholders engagement meetings, etc.'],
	['Number of people trained', 'Number of people trained as part of a restoration project to support project planning, implementation, maintenance, and/or monitoring activities.']
] AS socecoout
WITH socecoout
	MERGE (n:SOCIAL_OUTCOME_METRIC {uid: socecoout[0]})
		SET
			n.name = socecoout[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Monitoring objectives
//
UNWIND [
	['Baseline information', 'Monitoring to collect baseline information at a proposed restoration site to inform restoration prioritization or to support feasibility analysis.'],
	['Construction impacts', 'Monitoring conducted during the implementation of a restoration project, typically while construction is occurring to ensures restoration activities are not harming the site during implementation.'],
	['Infrastructure inspection and design', 'Monitoring to determine whether or not the project was constructed as designed, if the project matches the project plan, and if the structural elements of the projects are in place and functioning.'],
	['Biological and productivity', 'Monitoring to quantify the productivity of a restored or newly constructed habitat by measuring abundance, density, and production of target fish species (e.g. biomass or numbers of juveniles per unit area), number of juvenile fry or smolts from a spawning channel, condition factors, water quality (e.g. temperature, DO, pH), and other measures.'],
	['Habitat structure', 'Monitoring to quantify the productivity or change in habitat structure of a restored or newly constructed habitat by measuring abundance, density, and production of vegetation, instream sedimentation, instream LWD, bank stabilization, and other measures.'],
	['Other', 'Other monitoring objectives you would like to comment on that was not provided in our list.']
] AS monobj
WITH monobj
	MERGE (n:MONITORING_OBJECTIVE {uid: monobj[0]})
		SET
			n.name = monobj[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//
//
UNWIND [
	['Aerial surveys', 'Monitoring that employs aerial surveys.'],
	['eDNA', 'Monitoring that employs environmental DNA (eDNA) collection from the environment (e.g. water, soil, feces).'],
	['Electrofishing', 'Monitoring that employs an electrical current to survey fish.'],
	['Hydrological modelling', 'Monitoring that employs statistical modeling to simulate water flows and other water characteristics.'],
	['Invasive species surveys', 'Monitoring that employs invasive species surveys to determine changes in the abundance, density, production, and distribution of invasive species.'],
	['Physical habitat surveys', 'Monitoring that employs surveys to determine amount of LWD, percent shade, substrate and sediment type, soil quality, and bank/shoreline stability.'],
	['Vegetation surveys', 'Monitoring that employs vegetation surveys to determine vegetation cover, vegetation diversity, plant survival, and stem density.'],
	['Nets and traps', 'Monitoring that employs nets (e.g. gill, seine) and traps (e.g. fyke, minnow) to survey fish and fish habitat.'],
	['Photo point monitoring', 'Monitoring that employs repeated photo point monitoring to determine physical and visual changes at a restoration site.'],
	['PIT tagging and telemetry', 'Monitoring that employs PIT Tagging and telemetry to track fish movement, fish escapement and returns, and fish counts.'],
	['Snorkel surveys', 'Monitoring that employs snorkeling to survey fish.'],
	['Temperature loggers', 'Monitoring that employs temperature loggers to monitor changes in water temperature.'],
	['Hydrometer installments', 'Monitoring that employs hydrometer data to monitor changes in water flows.'],
	['Water sampling', 'Monitoring that employs water sampling techniques to monitor changes in water chemistry (e.g. dissolved oxygen, salinity, pH, nutrients) and quality.'],
	['Qualitative visual assessment', 'Monitoring that employs qualitative visual assessment of a restoration site to determine fish utilization, fish and riparian species, changes to infrastructure, etc.'],
	['Other', 'Other monitoring activities provided as a list using the following format:  Capture-mark-recapture, Underwater video, PIT tagging']
] AS monact
WITH monact
	MERGE (n:MONITORING_ACTIVITY {uid: monact[0]})
		SET
			n.name = monact[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//
//
UNWIND [
	['BA', 'Before-after design'],
	['CI', 'Control-impact design'],
	['BACI', 'Before-after-control-impact design'],
	['Multi-BACI', 'Multiple before-after-control-impact design'],
	['Unknown', ''],
	['None', ''],
	['Other', '']
] AS mondsg
WITH mondsg
	MERGE (n:MONITORING_DESIGN {uid: mondsg[0]})
		SET
			n.name = mondsg[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//
//
UNWIND [
	['Fall'],
	['Spring'],
	['Summer'],
	['Winter']
] AS seamon
WITH seamon
	MERGE (n:SEASON_MONITORED {uid: seamon[0]});
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Load PARR project data from the import/ directory
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.json('parr_projects_2.1.json')
    YIELD value AS map
  RETURN map
", "
  WITH map
    CREATE (n:PROJECT {uid: apoc.create.uuid()})
      SET
        n.data_source = map.data_source,
        n.number_of_sites = map.number_of_sites,
        n.rru_involvement = map.rru_involvement,
        n.reporting_fiscal_year = map.reporting_fiscal_year,
        n.pid = map.project_id,
        n.name = map.project_name,
        n.desc = map.project_description,
        n.goals = map.goals,
        n.project_duration = map.project_duration,
        n.year_project_was_initiated = map.year_project_was_initiated,
        n.year_project_was_last_modified = map.year_project_was_last_modified,
        n.number_of_indigenous_partners = map.number_of_indigenous_partners,
        n.location = POINT({latitude:map.latitude_in_decimal_degrees, longitude:map.longitude_in_decimal_degrees, crs: 'WGS-84'}),
        n.sep_rru_in_kind_contributions = map.sep_rru_in_kind_contributions,
        n.sep_rru_cash_contributions = map.sep_rru_cash_contributions,
        n.sep_cip_in_kind_contributions = map.sep_cip_in_kind_contributions,
        n.sep_cip_cash_contributions = map.sep_cip_cash_contributions,
        n.was_this_a_g_c_funded_project = map.was_this_a_g_c_funded_project,
        n.g_c_cash_contributions = map.g_c_cash_contributions,
        n.other_cash_contributions = map.other_cash_contributions,
        n.other_in_kind_contributions = map.other_in_kind_contributions,
        n.amount_of_money_you_spent_on_the_project_within_this_fiscal_year = map.what_was_the_amount_of_money_you_spent_on_the_project_within_this_fiscal_year,
        n.the_total_cost_of_the_project = map.what_is_the_total_cost_of_the_project,
        n.outcome_value = map.outcome_value,
        n.outcome_value_2 = map.outcome_value_2,
        n.primary_socio_economic_outcome = map.what_was_the_primary_socio_economic_outcome,
        n.value_of_the_primary_socio_economic_outcome = map.provide_the_value_of_the_primary_socio_economic_outcome,
				n.secondary_socio_economic_outcome = map.what_was_the_secondary_socio_economic_outcome,
        n.value_of_the_secondary_socio_economic_outcome = map.provide_the_value_of_the_secondary_socio_economic_outcome,
        n.was_project_monitoring_completed = map.was_project_monitoring_completed,
        n.number_of_years_of_monitoring_before_restoration = map.number_of_years_of_monitoring_before_restoration,
        n.number_of_years_of_monitoring_after_restoration = map.number_of_years_of_monitoring_after_restoration,
        n.key_lessons_learned = n.key_lessons_learned,
        n.are_sara_listed_aquatic_species_present = map.are_sara_listed_aquatic_species_present,
        n.are_aquatic_invasive_species_present = map.are_aquatic_invasive_species_present,
				n.other_information = map.other_information
  WITH map, n
    FOREACH (area IN map.dfo_area |
      MERGE (dfo_area:DFO_AREA {uid: area})
      MERGE (dfo_area)<-[:IN_DFO_AREA]-(n)
    )
    FOREACH (p IN map.project_contacts |
      MERGE (person:CONTACT_PERSON {name: p.name})
        SET
          person.tel = p.tel,
          person.email = p.email
      MERGE (person)<-[:HAS_PROJECT_CONTACT]-(n)
    )
    FOREACH (p IN map.project_lead_organization |
			FOREACH (_ IN CASE p IN ['', 'N/A'] WHEN TRUE THEN [] ELSE [1] END |
	      MERGE (pr_org:ORGANIZATION:LEAD_ORGANIZATION {uid: p})
	      MERGE (pr_org)<-[:HAS_LEAD_ORGANIZATION]-(n)
			)
    )
    FOREACH (p IN map.project_partners |
			FOREACH (_ IN CASE p IN ['', 'N/A'] WHEN TRUE THEN [] ELSE [1] END |
	      MERGE (pr_ppn:ORGANIZATION {uid: p})
	      MERGE (pr_ppn)<-[:HAS_PROJECT_PARTNER]-(n)
			)
    )
    FOREACH (p IN map.policy_and_program_connections |
      MERGE (pr_policy:POLICY_PROGRAM {uid: p})
      MERGE (pr_policy)<-[:HAS_POLICY_PROGRAM]-(n)
    )
    FOREACH (_ IN CASE map.watershed_name IS NOT NULL AND map.watershed_name <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (pr_loc:WATERSHED {uid: map.watershed_name})
      MERGE (pr_loc)<-[:HAS_WATERSHED]-(n)
    )
    FOREACH (p IN map.g_c_funding_sources |
      MERGE (pr_fndsrc:GC_FUNDING_SOURCE {uid: p})
      MERGE (pr_fndsrc)<-[:GC_FUNDING_PROGRAM]-(n)
    )
    FOREACH (p IN map.other_funding_sources |
      MERGE (pr_ofs:ORGANIZATION {uid: p})
      MERGE (pr_ofs)<-[:HAS_OTHER_FUNDING_SOURCE]-(n)
    )
    FOREACH (_ IN CASE map.project_phase IS NOT NULL AND map.project_phase <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (pr_phase:PROJECT_PHASE {uid: map.project_phase})
      MERGE (pr_phase)<-[:HAS_PROJECT_PHASE]-(n)
    )
    FOREACH (p IN map.primary_project_activities |
      MERGE (pr_prmact:PROJECT_ACTIVITY {uid: p})
      MERGE (pr_prmact)<-[:HAS_PRIMARY_ACTIVITY]-(n)
    )
    FOREACH (p IN map.ecosystem_type |
      MERGE (ecosystyp:ECO_SYSTEM_TYPE {uid: p})
      MERGE (ecosystyp)<-[:HAS_ECO_SYSTEM_TYPE]-(n)
    )
    FOREACH (p IN map.target_species |
      MERGE (target_species:TARGET_SPECIES {uid: p})
      MERGE (target_species)<-[:HAS_TARGET_SPECIES]-(n)
    )
    FOREACH (p IN map.life_stage |
      MERGE (lfestg:LIFE_STAGE {uid: p})
      MERGE (lfestg)<-[:HAS_LIFE_STAGE]-(n)
    )
    FOREACH (_ IN CASE map.what_was_the_primary_restoration_activity IS NOT NULL AND map.what_was_the_primary_restoration_activity <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (resact:RESTORATION_ACTIVITY {uid: map.what_was_the_primary_restoration_activity})
      MERGE (resact)<-[:HAS_PRIMARY_RESTORATION_ACTIVITY]-(n)
    )
    FOREACH (_ IN CASE map.outcome_metric IS NOT NULL AND map.outcome_metric <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (hbtoutmtr:HABITAT_OUTCOME_METRIC {uid: map.outcome_metric})
      MERGE (hbtoutmtr)<-[:HAS_PRIMARY_OUTCOME_METRIC]-(n)
    )
    FOREACH (_ IN CASE map.what_was_the_secondary_restoration_activity IS NOT NULL AND map.what_was_the_secondary_restoration_activity <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (resact:RESTORATION_ACTIVITY {uid: map.what_was_the_secondary_restoration_activity})
      MERGE (resact)<-[:HAS_SECONDARY_RESTORATION_ACTIVITY]-(n)
    )
    FOREACH (_ IN CASE map.outcome_metric_2 IS NOT NULL AND map.outcome_metric_2 <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (hbtoutmtr:HABITAT_OUTCOME_METRIC {uid: map.outcome_metric_2})
      MERGE (hbtoutmtr)<-[:HAS_SECONDARY_OUTCOME_METRIC]-(n)
    )
    FOREACH (p IN map.monitoring_objectives |
      MERGE (monobj:MONITORING_OBJECTIVE {uid: p})
      MERGE (monobj)<-[:HAS_MONITORING_OBJECTIVE]-(n)
    )
    FOREACH (p IN map.monitoring_activities |
      MERGE (monact:MONITORING_ACTIVITY {uid: p})
      MERGE (monact)<-[:HAS_MONITORING_ACTIVITY]-(n)
    )
    FOREACH (_ IN CASE map.monitoring_design IS NOT NULL AND map.monitoring_design <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (mondsg:MONITORING_DESIGN {uid: map.monitoring_design})
      MERGE (mondsg)<-[:HAS_MONITORING_DESIGN]-(n)
    )
    FOREACH (p IN map.season_monitored |
      MERGE (seamon:SEASON_MONITORED {uid: p})
      MERGE (seamon)<-[:HAS_SEASON_MONITORED]-(n)
    )
    FOREACH (p IN map.life_stage_monitored |
      MERGE (lfestgmon:LIFE_STAGE {uid: p})
      MERGE (lfestgmon)<-[:HAS_LIFE_STAGE_MONITORED]-(n)
    )
    FOREACH (p IN map.other_benefitting_species |
      MERGE (other_species:SPECIES {uid: p})
      MERGE (other_species)<-[:HAS_OTHER_BENEFITTING_SPECIES]-(n)
    )
",
{
    batchSize:100, iterateList:true, parallel:false
});
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Call the nlp micro service to process organization's name
//
MATCH (n:ORGANIZATION)
	WITH n, [apoc.map.fromPairs([['u', 'uid'], ['c', n.uid]])] AS input
    CALL custom.nlp_import(n, 'http://nlp:8000/process/', apoc.convert.toJson(input))
      YIELD result
RETURN 1;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Load PARR_PR name file from the import/ directory
// Call the nlp micro service to process the documents.
//
CALL apoc.periodic.iterate(
"
	MATCH (n:PROJECT)
		WITH n, [
			apoc.map.fromPairs([['u', 'name'], ['c', n.name]]),
			apoc.map.fromPairs([['u', 'desc'], ['c', n.desc]]),
			apoc.map.fromPairs([['u', 'goals'], ['c', CASE n.goals IS NULL WHEN TRUE THEN '' ELSE n.goals END]]),
			apoc.map.fromPairs([['u', 'primary_socio_economic_outcome'], ['c', CASE n.primary_socio_economic_outcome IS NULL WHEN TRUE THEN '' ELSE n.primary_socio_economic_outcome END]]),
			apoc.map.fromPairs([['u', 'secondary_socio_economic_outcome'], ['c', CASE n.secondary_socio_economic_outcome IS NULL WHEN TRUE THEN '' ELSE n.secondary_socio_economic_outcome END]]),
			apoc.map.fromPairs([['u', 'key_lessons_learned'], ['c', CASE n.key_lessons_learned IS NULL WHEN TRUE THEN '' ELSE n.key_lessons_learned END]])
		] AS input
	RETURN n, input
", "
	WITH n, input
  	CALL custom.nlp_import(n, 'http://nlp:8000/process/', apoc.convert.toJson(input))
      YIELD result
	RETURN 1;
",
{
    batchSize:100, iterateList:true, parallel:false
});
//
////////////////////////////////////////////////////////////////////////////////
