/** 
 * @file	zigbee_join/nwk/orphan_indication.als
 * @brief	NWK layer indication of arriving OrphanNotification
 * @author	Elena Tomina, Andrey Kupriyanov
 * @date	2008, April 30
 * @since	2008, April 28
 *
 */
module zigbee_join/nwk/orphan_indication

open zigbee_join/base as z


// NWK layer handler of MLME-ORPHAN.indication/response
sig NwkOrphanIndication extends NwkIndication {
	// Indication
	orphanAddress: 	ExtAddr,
	
	// Response
	shortAddress: ShortAddr,
	associatedMember: Bool

} {
	// Find child with extended address equal to orphanAddress
	let orphan = node.nwkNeighborTable.t & relationship.t.RELATION_CHILD & extendedAddress.orphanAddress {
		some orphan => {
			shortAddress = orphan.networkAddress.t
			associatedMember = True
		}
		else associatedMember = False	
	}
	//noEvents
}


// Utility function to imitate imperative-style call of the indication
fun MacEvent.orphanIndication[orphanAddress: ExtAddr]: NwkOrphanIndication
{{	r: NwkOrphanIndication {
	this.call[r]
	r.@orphanAddress = orphanAddress
}}}


