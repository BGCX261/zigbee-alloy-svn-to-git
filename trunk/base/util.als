/** 
 * @file	zigbee_join/base/util.als
 * @brief	Utilities for operations with nodes 
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 17
 * @since	2008, April 17
 *
 */
module zigbee_join/base/util

open util/relation
open zigbee_join/base/node as node


pred Node.isNeighborTableFull[t: Time]
{
    #this.nwkNeighborTable.t >= this.nwkcMaxNeighborTableSize 
}

pred Node.isCoordinatorOrRouter[t: Time] 
{
	this.nwkDeviceType.t in DEVICE_COORDINATOR+DEVICE_ROUTER
}

pred Node.canHear[n: Node,t: Time] { n in this.hear.t }



fun Node.allocateNetworkAddress[t: Time]: set ShortAddr
{	// TODO: implement address allocation mechanism (3.6.1.6 and 3.6.1.6)
	ShortAddr - this.nwkNetworkAddress.t - this.nwkNeighborTable.t.networkAddress.t
}

fun Node.parent[t: Time]: lone Neighbor
{{	
	n: Neighbor {
		n in this.nwkNeighborTable.t
		n.relationship.t = RELATION_PARENT
	}
}}

fun Node.child[t: Time, extAddr: ExtAddr]: lone Neighbor
{{	
	n: Neighbor {
		n in this.nwkNeighborTable.t
		n.extendedAddress = extAddr
		n.relationship.t in RELATION_CHILD
	}
}}

fun Node.suitableParents[t: Time, deviceType: DeviceType]: Neighbor
{{	p: Neighbor {
	p in this.nwkNeighborTable.t
	p.permitJoining.t=True
	deviceType=DEVICE_ROUTER => isTrue[p.routerCapacity.t]
	else isTrue[p.endDeviceCapacity.t]
	this.linkCost[p]<=3
	some p.potentialParent.t => p.potentialParent.t=True
	// TODO: The device shall have the most recent update id
}}}

fun Node.linkCost[n: Neighbor]: Int {
	// TODO: how shall we calculate link cost? 
	3
}

