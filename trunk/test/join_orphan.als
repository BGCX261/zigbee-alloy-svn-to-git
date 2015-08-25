/** 
 * @file	zigbee_join/test/join_orphan.als
 * @brief	Tests for JoinOrphan primitive 
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 17
 * @since	2008, April 17
 *
 */
module zigbee_join/test/join_orphan

open zigbee_join/base as z
open zigbee_join/mac/scan_orphan as scan_orphan
open zigbee_join/mac/orphan_indication as mac_orphan_indication
open zigbee_join/nwk/join_orphan as join_orphan
open zigbee_join/nwk/orphan_indication as nwk_orphan_indication


pred Success { some r: JoinOrphan |  r.status = SUCCESS }  
pred NoNetworks { some r: JoinOrphan | r.status = NWK_NO_NETWORKS }  


run Success for 5 but 10 Event
run NoNetworks
 for 5
