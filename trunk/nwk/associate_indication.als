/** 
 * @file	zigbee_join/nwk/associate_indication.als
 * @brief	NWK layer indication of arriving AssociationRequest
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, May 3
 * @since	2008, May 3
 */
module zigbee_join/nwk/associate_indication

open zigbee_join/base as z

// NWK layer handler of MLME-ASSOCIATE.indication/response
sig NwkAssociateIndication extends NwkIndication {
	// Indication
	deviceAddress: 	ExtAddr,
	deviceType: DeviceType,
	
	// Response
	assocShortAddress: ShortAddr,
	status: Status,
	
	// NWK updates
	private add, del: lone NwkUpdate
} {
	// Find children with extended address equal to deviceAddress
	let children = { n: node.nwkNeighborTable.t | n.relationship.t=RELATION_CHILD and n.extendedAddress=deviceAddress } {
		some children => {
			// if device type matches then return its network address
			let child = { c: children | c.deviceType.t=deviceType } |
			some child => {
				assocShortAddress = child.networkAddress.t
				status = SUCCESS
				no add+del
			}
			// else remove children from neighbor table and restart
			else update[del,node,nwkNeighborTable,node.nwkNeighborTable.t-children]
		}
		else no del
	
		(no children or some del) => let t = { tm: Time | some del => tm=del.t else tm=t } {
			node.isNeighborTableFull[t]	=> {
				assocShortAddress = SHORTADDR_0xFF
				status = MAC_PAN_AT_CAPACITY
				no add
			}
			else {
				// allocate new network address and neighbor table entry
				assocShortAddress in node.allocateNetworkAddress[t]
				some add
				add = addChild[deviceAddress,assocShortAddress,deviceType]
				add.after[t]
				status = SUCCESS
			}	
		}
	}
	noEventsExcept[add+del]
}

// Utility function to imitate imperative-style call of the indication
fun NodeEvent.associateIndication[deviceAddress: ExtAddr, deviceType: DeviceType]: NwkAssociateIndication
{{	r: NwkAssociateIndication {
	this.call[r]
	r.@deviceAddress = deviceAddress
	r.@deviceType = deviceType
}}}


