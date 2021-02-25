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
	MERGE (n:DFO_Area {uid: dfo_area[0]})
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
	MERGE (n:PR_Policy {uid: pr_policy[0]})
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
	MERGE (n:PR_FndSrc {uid: pr_fndsrc[0]})
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
	MERGE (n:PR_Phase {uid: pr_phase[0]})
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
	MERGE (n:PR_PrmAct {uid: pr_prmact[0]})
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
	MERGE (n:EcoSysTyp {uid: ecosystyp[0]})
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
	MERGE (n:TgtSpc {uid: tgtspc[0]})
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
	MERGE (n:LfeStg {uid: lfestg[0]})
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
	MERGE (n:ResAct {uid: resact[0]})
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
	MERGE (n:HbtOutMtr {uid: hbtoutmtr[0]})
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
	MERGE (n:SocEcoOut {uid: socecoout[0]})
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
	MERGE (n:MonObj {uid: monobj[0]})
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
	MERGE (n:MonAct {uid: monact[0]})
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
	MERGE (n:MonDsg {uid: mondsg[0]})
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
	MERGE (n:SeaMon {uid: seamon[0]});
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//
//
UNWIND [
	['Returning adult', 'Migrating adult and spawner stages.'],
	['Estuarine juvenile', 'Marine and estuarine rearing life stages as juveniles grow into adults.'],
	['Freshwater juvenile', 'Freshwater rearing and over-wintering life stages including fry, parr, and migrating smolt.'],
	['Incubation', 'Inter-gravel development phase including the egg and alevin life cycle stages.']
] AS lfestgmon
WITH lfestgmon
	MERGE (n:LfeStgMon {uid: lfestgmon[0]})
		SET
			n.name = lfestgmon[1];
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Load PARR project data from the import/ directory
//
CALL apoc.periodic.iterate(
"
  CALL apoc.load.json('parr_projects_2.0.json')
    YIELD value AS map
  RETURN map
", "
  WITH map
    CREATE (n:PARR_PR {uid: apoc.create.uuid()})
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
        n.was_project_monitoring_completed = map.was_project_monitoring_completed,
        n.number_of_years_of_monitoring_before_restoration = map.number_of_years_of_monitoring_before_restoration,
        n.number_of_years_of_monitoring_after_restoration = map.number_of_years_of_monitoring_after_restoration,
        n.key_lessons_learned = n.key_lessons_learned,
        n.are_sara_listed_aquatic_species_present = map.are_sara_listed_aquatic_species_present,
        n.are_aquatic_invasive_species_present = map.are_aquatic_invasive_species_present
  WITH map, n
    FOREACH (area IN map.dfo_area |
      MERGE (dfo_area:DFO_Area {uid: area})
      MERGE (dfo_area)<-[:PR_IN_AREA]-(n)
    )
    FOREACH (p IN map.project_contacts |
      MERGE (person:Person {name: p.name})
        SET
          person.tel = p.tel,
          person.email = p.email
      MERGE (person)<-[:PR_HAS_CNT]-(n)
    )
    FOREACH (p IN map.project_lead_organization |
      MERGE (pr_org:PR_ORG {uid: p})
      MERGE (pr_org)<-[:PR_HAS_LOG]-(n)
    )
    FOREACH (p IN map.project_partners |
      MERGE (pr_ppn:PR_ORG {uid: p})
      MERGE (pr_ppn)<-[:PR_HAS_PPN]-(n)
    )
    FOREACH (p IN map.policy_and_program_connections |
      MERGE (pr_policy:PR_Policy {uid: p})
      MERGE (pr_policy)<-[:PR_HAS_POL]-(n)
    )
    FOREACH (_ IN CASE map.watershed_name IS NOT NULL AND map.watershed_name <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (pr_loc:PR_LOC {uid: map.watershed_name})
      MERGE (pr_loc)<-[:PR_AT_WSH]-(n)
    )
    FOREACH (p IN map.g_c_funding_sources |
      MERGE (pr_fndsrc:PR_FndSrc {uid: p})
      MERGE (pr_fndsrc)<-[:PR_HAS_FDS]-(n)
    )
    FOREACH (p IN map.other_funding_sources |
      MERGE (pr_ofs:PR_ORG {uid: p})
      MERGE (pr_ofs)<-[:PR_HAS_OFS]-(n)
    )
    FOREACH (_ IN CASE map.project_phase IS NOT NULL AND map.project_phase <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (pr_phase:PR_Phase {uid: map.project_phase})
      MERGE (pr_phase)<-[:PR_AT_PHASE]-(n)
    )
    FOREACH (p IN map.primary_project_activities |
      MERGE (pr_prmact:PR_PrmAct {uid: p})
      MERGE (pr_prmact)<-[:PR_HAS_PMA]-(n)
    )
    FOREACH (p IN map.ecosystem_type |
      MERGE (ecosystyp:EcoSysTyp {uid: p})
      MERGE (ecosystyp)<-[:PR_HAS_ECO]-(n)
    )
    FOREACH (p IN map.target_species |
      MERGE (target_species:TgtSpc {uid: p})
      MERGE (target_species)<-[:PR_HAS_TSP]-(n)
    )
    FOREACH (p IN map.life_stage |
      MERGE (lfestg:LfeStg {uid: p})
      MERGE (lfestg)<-[:PR_HAS_LSG]-(n)
    )
    FOREACH (_ IN CASE map.what_was_the_primary_restoration_activity IS NOT NULL AND map.what_was_the_primary_restoration_activity <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (resact:ResAct {uid: map.what_was_the_primary_restoration_activity})
      MERGE (resact)<-[:PR_HAS_POC]-(n)
    )
    FOREACH (_ IN CASE map.outcome_metric IS NOT NULL AND map.outcome_metric <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (hbtoutmtr:HbtOutMtr {uid: map.outcome_metric})
      MERGE (hbtoutmtr)<-[:PR_HAS_POM]-(n)
    )
    FOREACH (_ IN CASE map.what_was_the_secondary_restoration_activity IS NOT NULL AND map.what_was_the_secondary_restoration_activity <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (resact:ResAct {uid: map.what_was_the_secondary_restoration_activity})
      MERGE (resact)<-[:PR_HAS_SOC]-(n)
    )
    FOREACH (_ IN CASE map.outcome_metric_2 IS NOT NULL AND map.outcome_metric_2 <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (hbtoutmtr:HbtOutMtr {uid: map.outcome_metric_2})
      MERGE (hbtoutmtr)<-[:PR_HAS_SOM]-(n)
    )
    FOREACH (p IN map.monitoring_objectives |
      MERGE (monobj:MonObj {uid: p})
      MERGE (monobj)<-[:PR_HAS_MOO]-(n)
    )
    FOREACH (p IN map.monitoring_activities |
      MERGE (monact:MonAct {uid: p})
      MERGE (monact)<-[:PR_HAS_MOO]-(n)
    )
    FOREACH (_ IN CASE map.monitoring_design IS NOT NULL AND map.monitoring_design <> '' WHEN TRUE THEN [1] ELSE [] END |
      MERGE (mondsg:MonDsg {uid: map.monitoring_design})
      MERGE (mondsg)<-[:PR_HAS_MOD]-(n)
    )
    FOREACH (p IN map.season_monitored |
      MERGE (seamon:SeaMon {uid: p})
      MERGE (seamon)<-[:PR_HAS_SMO]-(n)
    )
    FOREACH (p IN map.life_stage_monitored |
      MERGE (lfestgmon:LfeStgMon {uid: p})
      MERGE (lfestgmon)<-[:PR_HAS_SMO]-(n)
    )
    FOREACH (p IN map.life_stage_monitored |
      MERGE (lfestgmon:LfeStgMon {uid: p})
      MERGE (lfestgmon)<-[:PR_HAS_SMO]-(n)
    )
    FOREACH (p IN map.other_benefitting_species |
      MERGE (other_species:OthSpc {uid: p})
      MERGE (other_species)<-[:PR_HAS_OBS]-(n)
    )
",
{
    batchSize:100, iterateList:true, parallel:false
});
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
MATCH (p:PR_ORG)
  WHERE p.uid IN ["", "N/A"]
	DETACH DELETE p;
//
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
WITH [
	['A-Tlegay Fisheries Society', ['A-A\'Tlegay Fisheries', 'A-Tlegay Fisheries']],
  ['Adams Lake Indian Band', ['Adams Lake Nation']],
  ['Ahousaht First Nation', ['Ahousaht']],
  ['Alberni Valley Enhancement Society', ['Alberni Fish and Game', 'Alberni Valley Enhancement', 'Alberni Valley Enhancement Association', 'Alberni Valley Enhancement Hatchery']],
  ['BC Cattleman\'s First Nation', ['BC Cattleman\'s Association']],
  ['BC Hydro Fish Wildlife Compensation Program', ['BC Hydro Fish and Wildlife Compensation Program', 'BC Hydro Fish and Wildlife Conservation Program', 'British Columbia Hydro Fish and Wildlife Compensation Program']],
  ['BC Ministry of Environment & Climate Change', ['BC Ministry of Environment', 'BC Ministry of Environment and Climate Change']],
  ['BC Hydro', ['BCHdyro', 'BCHydro']],
  ['Barkley Salmon Working Group', ['Barkley Group']],
  ['Bonaparte Indian Band', ['Bonaparte Nation']],
  ['Bowerman Contracting Ltd.', ['Bowerman Contracting']],
  ['Brad Berry Enterprises Ltd.', ['Brad Berry Excavating']],
  ['British Columbia Conservation Federation (BCCF)', ['British Columbia Conservation Federation']],
  ['British Columbia Conservation Foundation', ['British Columbia Conservation Foundation Lantzville', 'British Columbia Conservation Foundation Living Rivers', 'British Columbia Conservation Foundation Living Rivers Fund']],
  ['British Columbia Institute of Technology', ['British Columbia Institute of Technology Ecological Restoration students', 'British Columbia Institute of Technology Rivers Institute']],
  ['BC Ministry of Forests', ['BC Ministry of Forests Lands Natural Resource Operations and Rural Development', 'British Columbia Ministry of Forests', 'British Columbia Ministry of Forests Lands Natural Resource Operations and Rural Development', 'Ministry of Forest Lands Natural Resource Operations and Development', 'Ministry of Forests', 'Ministry of Forests Lands Natural Resource Operations and Rural Development']],
  ['Brooklyn Creek Watershed Society', ['Brooklyn Creek Stewards']],
  ['Bulkley Valley Rod & Gun Club', ['Bulkley Valley Rod and Gun Club']],
  ['CN Rails', ['CN Rail']],
  ['Canada Summer Jobs Program', ['Canada Summer Jobs']],
  ['Canadian Wildlife Services of Canada', ['Canadian Wildlife Service of Canada', 'Canadian Wildlife Services']],
  ['Carrier Sekani Tribal Council', ['Carrier Sekani Tribal Council members', 'Carrier/Sekani Tribal Council']],
  ['Catalyst Paper', ['Catalyst']],
  ['Cayoose Creek Band', ['Cayoose Creek Indian Band']],
  ['City of Chilliwack', ['City of Chilliwack Environmental Engineering Department', 'City of Chilliwack Operations Department']],
  ['City of Courtenay', ['City of Courtenay Parks Department']],
  ['Coldwater Indian Band', ['Coldwater Band']],
  ['Columbia Basin Trust', ['Columbia Basin Trust Ecosystem Enhancement Program']],
  ['Community Volunteers', ['Community Members', 'Community volunteers']],
  ['Comox Valley Project Watershed Society', ['Comox Valley Project Watershed', 'Comox Valley Project Watersehd (CVPW)']],
  ['Courtenay Fish and Game', ['Courtenay and District Fish and Game Protective Association']],
  ['Cowichan Tribes', ['Cowichan', 'Cowichan Tribes Fisheries Committee']],
  ['Cowichan Lake & River Stewardship Society', ['Cowichan Lake River Stewardship Society', 'Cowichan Lake Stewardship Enhancement Society', 'Cowichan Lake and River Stewardhip Society', 'Cowichan Lake and River Stewardship Society']],
  ['Cowichan Lake Research Station', ['Cowichan Research Station']],
  ['Cowichan Valley Naturalists Society', ['Cowichan Valley Naturalists', 'Cowichan Naturalists']],
  ['Cowichan Community Land Trust', ['Cowichan Land Trust']],
  ['Current Environmental Ltd.', ['Current Environmental']],
  ['D. Burt and Associates Ltd.', ['D. Burt and Associates']],
  ['Dave Polster Environmental Services', ['Dave Polster']],
  ['Discovery Coast Greenways Land Trust', ['Discovery Coast Greenways Lang Trust']],
  ['Douglas Lake and Louis Creek Ranch', ['Douglas Lake Ranch']],
  ['Ducks Unlimited Canada', ['Ducks Unlimited']],
  ['Echo Ecological Enterprises Ltd.', ['Echo Ecological']],
  ['Eco Canada', ['EcoCanada']],
  ['Ehattesaht First Nation', ['Ehattesaht First Nations Fisheries']],
  ['En\'owkin Center', ['En\'Owkin Centre', 'Enowkin Centre']],
  ['Environment Canada', ['Environment Canada and Climate Change', 'Environment and Climate Change Canada']],
  ['Fanny Bay Salmonid Enhancement Society', ['Fanny Bay Enhancement Society', 'Fanny Bay Salmon Enhancement', 'Fanny Bay Salmon Enhancement Society']],
  ['Fisheries and Oceans Canada (DFO)', ['Fisheries and Ocean Canada', 'Fisheries and Oceans', 'Fisheries and Oceans Canada']],
  ['Fisheries and Oceans Canada Stock Assessment', ['Fisheries and Oceans Canada (Stock Assessment']],
  ['Fisheries and Oceans Canada Community Involvement Program', ['Fisheries and Oceans Community Involvement Program', 'Fisheries and Oceans Stock Assessment/ Salmonid Enhancement Program Community Involvement']],
  ['Fraser Valley Watersheds Coalition', ['Fraser Valley Watershed Coalition', 'Fraser Valley Watersheds Coalition community volunteers and University of the Fraser Valley students']],
  ['Friends of Cortes Island Society', ['Friends of Cortes Island Streamkeepers']],
  ['Gitanyow First Nation', ['Gitanyow Band', 'Gitanyow First Nations']],
  ['Gitxaala Nation', ['Gitxaala First Nation']],
  ['Gitxsan First Nation', ['Gitxsan First Nations']],
  ['Habitat Conservation Trust Foundation', ['HCTF', 'Habitat Conservation Trust Fund']],
  ['Haisla Nation Council', ['Haisla First Nation', 'Haisla Nation']],
  ['Hemmera Envirochem Inc.', ['Hemmera Environchem Inc.', 'Hemmera']],
  ['Huu-ay-aht First Nation', ['Huu-ay-aht', 'Huu-ay-aht First Nations']],
  ['Innergex Renewable Energy Inc.', ['Innergex']],
  ['Instream Fisheries Research Inc.', ['Instream', 'Instream Fisheries']],
  ['Island Timberlands', ['Island Timber']],
  ['K\'ómoks First Nation', ['K\'omoks First Nation', 'K\'ómoks First Nations', 'K’omoks First Nation', 'K’ómoks First Nation']],
  ['Ka:’yu:’k’t’h’/Chek’tles7et’h First Nations', ['Ka:’yu:’k’t’h’/Che:k’tles7et’h’ First Nations']],
  ['Katzie First Nation', ['Katzie Nation']],
  ['Kerr Wood Leidal', ['Kerr Wood Leidal. InStream Fisheries', 'Kerr Wood Leidel']],
  ['Kingfisher Interpretive Center', ['Kingfisher Interpretative Centre Society', 'Kingfisher Interpretive Centre Society']],
  ['Kitasoo/Xai-Xais', ['Kitasoo Band Council', 'Kitasoo/Xai\'Xais First Nations', 'Kitasoo/Xais\'Xai First Nations']],
  ['Kitsumkalum First Nation', ['Kitsumkalum Indian Band']],
  ['Kwantlen First Nation', ['Kwantlen First Nations']],
  ['L\'heidli T\'enneh First Nation', ['L\'heidli Tenneh', 'Lheidli T\'enneh First Nation']],
  ['LGL Limited Environmental Research Associates Ltd.', ['LGL Limited', 'LGL Ltd.']],
  ['Lake Babine Nation', ['Lake Babine Firsta Nation']],
  ['Lake Trail Environmental Consulting', ['Lake Trail Environmental']],
  ['Lakelse Watershed Society', ['Lakelse Lake Watershed Stewards Society']],
  ['Landowners', ['Land Owners', 'Landowner', 'Property Owners', 'Property landowners']],
  ['Lower Fraser Valley Fisheries Alliance', ['Lower Fraser Fisheries Alliance']],
  ['Lower Nicola Indian Band', ['Lower Nicola Tribal Council']],
  ['M4 Enterprises', ['M4']],
  ['M.C. Wright Associates Ltd.', ['M.C. Wright and Associates']],
  ['Maa-nulth Treaty Society', ['Maa-nulth']],
  ['Metlakatla First Nation', ['Metlakatla Band']],
  ['Ministry of Environment', ['Ministry of Environment (British Columbia Parks)', 'Ministry of Environment and Climate Change Strategy']],
  ['Ministry of Transportation and Infrastructure', ['Ministry of Highways', 'Ministry of T ransportation and Infrastructure', 'Ministry of Transportation']],
  ['Mountain Equipment Coop Community Contribution', ['Mountain Equipment Co-op']],
  ['Musqueam Indian Band', ['Musqueam Band', 'Musqueam First Nation']],
  ['National Wetland Conservation Fund', ['National Wetlands Conservation Fund']],
  ['Nature Conservancy of Canada', ['Nature Conservancy Canada']],
  ['Nechako Environment & Water Stewardship Society', ['Nechako Environment and Water Stewardship Society']],
  ['North Coast Skeena First Nations', ['North Coast Skeen First Nations']],
  ['North Coast Skeena First Nations Stewardship Society', ['North Coast - Skeena First Nations Stewardship Society', 'North Coast Skeen First Nations Stewardship Society']],
  ['North Shore Wetland Partners Society', ['North Shore Wetland Partners']],
  ['Northwest Hydraulic Consultants Ltd.', ['Northwest Hydraulic Consultants']],
  ['Nuu chah nulth WCVI Aquatic Management Society', ['Nuu chah nuluth WCVI Aquatic Management Society']],
  ['Nuu-chah-nulth', ['Nuu-chah-nulth Tribal Council', 'Nuu-chch-nulth Tribal Council']],
  ['Office of the Wet\'suwet\'en', ['Office of Wet\'suwet\'en']],
  ['Pacific Salmon Foundation', ['Pacific Samon Foundation', 'Pacific Salmon Foundation - Community Salmon Program']],
  ['Patagonia Tides Foundation', ['Patagonia']],
  ['Phil and Jennie Gaglardi Academy', ['Phil and Jennie Gaglardi']],
  ['Polster Environmental Services Ltd.', ['Polster Environmental Services']],
  ['Port of Metro Vancouver', ['Port Metro Vancouver']],
  ['Precision Identification', ['Precision identification']],
  ['Province of BC', ['Province of British Columbia']],
  ['Quesnel River Environmental Restoration', ['Quesnel River Environmetnal']],
  ['Raincoast Conservation', ['Raincoast Conservation Foundation']],
  ['Recreational Fisheries Conservation Partnership Program', ['Recreational Fisheries Conservation Partnerships Program']],
  ['Ridgeline Excavating Ltd.', ['Ridgeline Excavating']],
  ['Royal Bank of Canada Blue Water Fund', ['Royal Bank of Canada Blue Water']],
  ['SeaChange Marine Conservation Society', ['SeaChange']],
  ['Seaspan Marine Corporation', ['Seaspan Marine']],
  ['Secwepemc Fisheries Commission', ['Secwepemc Fisheries Commision', 'Secwepempc Fisheries Commission', 'Secwepmc Fisheries Commission']],
  ['Seymour River Salmonid Society', ['Seymour River Salmoid Society', 'Seymour Salmonid Society']],
  ['Shuswap Indian Band', ['Shuswap Nation Tribal Council']],
  ['Sidney Anglers Association', ['Sidney Anglers', 'Sidney Angler’s Association']],
  ['SkeenaWild Conservation Trust', ['Skeena Wild', 'SkeenaWild']],
  ['Skeetchestn Indian Band', ['Skeetchestn Band']],
  ['Snuneymuxw First Nation', ['Snuneymuwx First Nation']],
  ['South Coast Conservation Land Management Program', ['South Coast Conservation Lands Management Program']],
  ['Splitrock Environmental Sek\'wel\'was LP', ['Splitrock Environmental Sekw\'el\'was LP']],
  ['Sport Fishing Advisory Board (SFAB)', ['Sports Fish Advisory Board']],
  ['Squamish Environmental Society', ['Squamish Environment Society']],
  ['Squamish Nation', ['Squamish First Nation', 'Squamish First Nations']],
  ['Squamish Streamkeepers', ['Squamish Streamkeepers volunteers']],
  ['Squamish Windsport Society', ['Squamish Windsports Society']],
  ['St’át’imc Eco-Resources Ltd.', ['St’at’imc Eco-Resources']],
  ['Takla Lake First Nation', ['Talka Lake First Nation']],
  ['Thornton Creek Salmon Enhancement Society', ['Thornton Creek Enhancement Society']],
  ['TimberWest Forest Corp', ['TimberWest', 'Timberwest']],
  ['Tk’emlups Nation', ['Tk\'emlups te Secwepemc', 'Tk\'emlúps te Secwe̓pemc Nation']],
  ['Tl\'azt\'en Nation', ['Tl\'azt\'en First Nation']],
  ['Toquaht First Nation', ['Toquaht', 'Toquaht Nation']],
  ['Tseshaht First Nation', ['Tseshaht']],
  ['Tsleil-Waututh Nation', ['Tsleil- Waututh Nation', 'Tsleil-Waututh First Nation', 'Tsleil-Waututh First Nations', 'Tsleil-waututh Nation']],
  ['Uchuklesaht Tribe', ['Uchucklesaht', 'Uchucklesaht First Nation']],
  ['University of Northern BC', ['University of Northern British Columbia']],
  ['University of British Columbia', ['University ofBritish Columbia']],
  ['Upper Fraser Fisheries Conservation Alliance (UFFCA)', ['Upper Fraser Fisheries Conservation Alliance']],
  ['Wallis Environmental Aquatics Ltd.', ['Wallis Environmental Aquatics', 'Wallis Environmental Aquatics Contracting', 'Wallis Environmetnal Aquatics']],
  ['Wei Wai Kum First Nation', ['We Wai Kai First Bation', 'Wei Wai Kai First Nation']],
  ['West Vancouver Streamkeepers Society', ['West Vancouver Streamkeepers']],
  ['Western Forest Products Ltd.', ['Western Forest Products', 'Western Forest Products)']],
  ['Yuulu?il?ath First Nation', ['Yuułuʔiłʔath', 'Yuułuʔiłʔatḥ']],
  ['Colville Tribes', ['Colville Confederated Tribes', 'Confederated Colville Tribes', 'Coville Confederate Tribes']]
] AS same_terms_list
UNWIND same_terms_list AS same_terms
WITH same_terms[0] AS first_term, same_terms[1] AS the_rest
MATCH (e1:PR_ORG {uid: first_term})
WITH e1, the_rest
	MATCH (e2:PR_ORG)
		WHERE e2.uid IN the_rest
WITH [e1] + COLLECT(e2) AS nodes
	CALL apoc.refactor.mergeNodes(nodes, {properties: {uid: "discard"}, mergeRels:true})
		YIELD node
RETURN node;
//
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Load PARR_PR name file from the import/ directory
// Call the nlp micro service to process the documents.
//
MATCH (n:PR_ORG)
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
	MATCH (n:PARR_PR)
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
