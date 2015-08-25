/** 
 * @file	zigbee_join/test/join_direct.als
 * @brief	Tests for JoinDirect primitive 
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 17
 * @since	2008, April 17
 *
 */
module zigbee_join/test/join_direct

open zigbee_join/base as z
open zigbee_join/nwk/join_direct as join_direct

pred Success { some r: JoinDirect | r.status = SUCCESS }  
pred AlreadyPresent { some r: JoinDirect | r.status = NWK_ALREADY_PRESENT }  
pred NeighborTableFull { some r: JoinDirect | r.status = NWK_NEIGHBOR_TABLE_FULL }  

run Success
run AlreadyPresent
run NeighborTableFull
 