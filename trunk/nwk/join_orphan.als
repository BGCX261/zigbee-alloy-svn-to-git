/** 
 * @file	zigbee_join/nwk/join_orphan.als
 * @brief	NWK layer request to join a network through orphaning
 * @author	Elena Tomina, Andrey Kupriyanov
 * @date	2008, April 28
 * @since	2008, April 8
 *
 * Model of NLME-JOIN.request/confirm with RejoinNetwork=0x01(orphaning)
 */
module zigbee_join/nwk/join_orphan

open zigbee_join/base as z
open zigbee_join/mac/scan_orphan as scan_orphan

// NLME-JOIN.request/confirm with RejoinNetwork=0x01
sig JoinOrphan extends NwkRequest 
{
	// Request: no parameters

	// Confirm
	status: 	Status,
	networkAddress: ShortAddr,
	
	// MAC requests	
	scan: ScanOrphan,
	
	// NWK updates
	upNA: lone NwkUpdate -- update of nwkNetworkAddress
} {
	call[scan]
	scan.status=SUCCESS => {
		update[upNA,node,nwkNetworkAddress,scan.shortAddress]
		upNA.after[scan]
		networkAddress = scan.shortAddress
		status = SUCCESS
	}
	else {
		no upNA
		networkAddress = SHORTADDR_0xFF
		status = NWK_NO_NETWORKS
	}
	noEventsExcept[scan+upNA]
}

fun NodeEvent.joinOrphan[]: JoinOrphan
{{	r: JoinOrphan {
	this.call[r]
}}}

