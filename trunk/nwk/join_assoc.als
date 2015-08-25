/** 
 * @file	zigbee_join/nwk/join_assoc.als
 * @brief	NWK layer request to join a network through association
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 10
 * @since	2008, April 1
 *
 * Reduction of complete ZigBee model to test the join-leave behaviour
 */
module zigbee_join/nwk/join_assoc

open zigbee_join/base as z
open zigbee_join/mac/associate as associate


// Model of NLME-JOIN with RejoinNetwork = 0x00 (join through association)
sig JoinAssoc extends NwkRequest {

	// Request
	deviceType: DeviceType,

	// Confirm
	status: Status,
	networkAddress: ShortAddr,
	
	// NWK updates
	updateAddress: lone NwkUpdate,
	updateParents: set NeighborUpdate,
	
	// MAC requests
	macAssocs: set Associate,

	// Service
	suitableParent: macAssocs lone -> one Neighbor,
} {
	all req: macAssocs | let sp = suitableParent[req], sps = node.suitableParents[req.@t,deviceType] {
		sp in sps
		sp.depth.t = min[sps.depth.t]
		req = associate[sp.extendedAddress,deviceType]
		no req2: macAssocs-req | req.interferes[req2]
		(some req2: macAssocs-req | req2.after[req]) => req.status != SUCCESS
		req.status in MAC_PAN_AT_CAPACITY+MAC_PAN_ACCESS_DENIED
		=> some upd: updateParents {
			upd = update[sp,potentialParent,False]
			upd.after[req]
			all req2: macAssocs-req | req2.after[req] => upd.before[req2]
		}
	}
	no macAssocs => status = NWK_NOT_PERMITTED
	else {
		some req: macAssocs | req.status=SUCCESS => {
			some upd: updateParents {
				upd = update[suitableParent[req],relationship,RELATION_PARENT]
				upd.after[req]
			}
			updateAddress = update[node,nwkNetworkAddress,req.assocShortAddress]
			updateAddress.after[req]
			status = SUCCESS
			networkAddress = req.assocShortAddress
		}
		else some lastReq: macAssocs {
			all req: macAssocs-lastReq | lastReq.after[req]
			status = lastReq.status
		}
	}
	noEventsExcept[updateAddress+updateParents+macAssocs]
	#updateParents=#macAssocs
	
	status!=SUCCESS => networkAddress = SHORTADDR_0xFF 
}

// Utility function to imitate imperative-style call of the request
fun NodeEvent.joinAssoc[deviceType: DeviceType]: JoinAssoc
{{	r: JoinAssoc {
	this.call[r]
	r.@deviceType = deviceType
}}}



