/** 
 * @file	zigbee_join/nwk/join_direct.als
 * @brief	NWK layer request to join a device to the network directly
 * @author	Elena Tomina, Andrey Kupriyanov
 * @date	2008, April 10
 * @since	2008, April 8
 *
 * Model of NLME-DIRECT-JOIN.request/confirm
 */
module zigbee_join/nwk/join_direct

open zigbee_join/base as z


sig JoinDirect extends NodeEvent 
{
	// Request
	deviceAddress:	ExtAddr,
	deviceType:	DeviceType,

	// Confirm
	status: Status,

	// NWK updates
	upNT: lone NwkUpdate -- update of nwkNeighborTable
} {

	deviceAddress in node.nwkNeighborTable.t.extendedAddress 
		=> status = NWK_ALREADY_PRESENT
	else {
		node.isNeighborTableFull[t] => status = NWK_NEIGHBOR_TABLE_FULL
		else {
			some n: Neighbor {
				update[upNT,node,nwkNeighborTable,node.nwkNeighborTable.t+n]
				n.extendedAddress = deviceAddress
				let ut=upNT.@t {
					n.networkAddress.ut in node.allocateNetworkAddress[t]
					n.deviceType.ut = deviceType
					n.relationship.ut = RELATION_CHILD
			}	}
			status = SUCCESS
	}	}	
	status!=SUCCESS => no upNT
	noEventsExcept[upNT]

}

fun NodeEvent.joinDirect[deviceAddress: ExtAddr, deviceType: DeviceType]: JoinDirect
{{	r: JoinDirect {
	this.call[r]
	r.@deviceAddress = deviceAddress
	r.@deviceType	 = deviceType
}}}

