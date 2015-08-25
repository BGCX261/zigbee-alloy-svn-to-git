/** 
 * @file	zigbee_join/base/node.als
 * @brief	Zigbee node 
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 17
 * @since	2008, April 1
 *
 */
module zigbee_join/base/node

open zigbee_join/base/neighbor as neighbor


sig Node {
	// MAC layer constants
	aExtendedAddress: ExtAddr,
	aResponseWaitTime: Int,
	aMaxFrameRetries: Int,
	aMaxLostBeacons: Int,
	
	// NWK layer constants
	nwkcMaxNeighborTableSize: Int,
	
	// NWK layer attributes
	nwkNetworkAddress: ShortAddr one -> Time,
	nwkNeighborTable: set Neighbor -> Time,
	
	nwkDeviceType: DeviceType one -> Time,

	// Additional information broadcasted in beacon payload
	depth:  Natural lone -> Time,
	permitJoining:  Bool lone -> Time,
	routerCapacity:  Bool lone -> Time,
	endDeviceCapacity:  Bool lone -> Time,
	
	// Service attributes
	hear: set Node	-> Time 	-- reachability relation
} 


abstract sig NwkAttribute {}
one sig 
	nwkNetworkAddress,
	nwkNeighborTable,
	nwkDeviceType,
	depth,
	permitJoining,
	routerCapacity,
	endDeviceCapacity
extends NwkAttribute {}


pred Node.attrChanged[attr: NwkAttribute, t: Time]
{
	t!=first
	attr=nwkNetworkAddress => this.nwkNetworkAddress.t != this.nwkNetworkAddress.(t.prev)
	attr=nwkNeighborTable => this.nwkNeighborTable.t != this.nwkNeighborTable.(t.prev)
	attr=nwkDeviceType => this.nwkDeviceType.t != this.nwkDeviceType.(t.prev)
	attr=depth => this.depth.t != this.depth.(t.prev)
	attr=permitJoining => this.permitJoining.t != this.permitJoining.(t.prev)
	attr=routerCapacity => this.routerCapacity.t != this.routerCapacity.(t.prev)
	attr=endDeviceCapacity => this.endDeviceCapacity.t != this.endDeviceCapacity.(t.prev)

}


pred Node.setAttr[attr: NwkAttribute, value: univ, t: Time]
{
	attr=nwkNetworkAddress => this.nwkNetworkAddress.t = value
	attr=nwkNeighborTable => this.nwkNeighborTable.t = value
	attr=nwkDeviceType => this.nwkDeviceType.t = value
	attr=depth => this.depth.t = value
	attr=permitJoining => this.permitJoining.t = value
	attr=routerCapacity => this.routerCapacity.t = value
	attr=endDeviceCapacity => this.endDeviceCapacity.t = value

}
