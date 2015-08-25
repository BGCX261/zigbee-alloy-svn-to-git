/** 
 * @file	zigbee_join/base/neighbor.als
 * @brief	Neighbor Table Entry of ZigBee NWK layer
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 17
 * @since	2008, April 1		
 *
 */
module zigbee_join/base/neighbor

open zigbee_join/base/types as types

sig Neighbor {
	
// 	Mandatory and optional data that are used in normal network operation (Table 3.48)
//	(all of the fields except specially indicated are mandatory)

	extendedAddress:	ExtAddr,
	networkAddress: 	ShortAddr one -> Time,

	deviceType: 		DeviceType one -> Time,
	relationship: 		Relation one -> Time,

//	Information that may be used during network discovery and rejoining. 
//	(all of the fields are optional)

	depth:				Natural lone -> Time,

	permitJoining:		Bool lone -> Time,
	routerCapacity:		Bool lone -> Time,
	endDeviceCapacity:	Bool lone -> Time,	
	potentialParent:	Bool lone -> Time
}

abstract sig NeighborAttribute {}
one sig
	networkAddress,
	deviceType,
	relationship,
	depth,
	permitJoining,
	routerCapacity,
	endDeviceCapacity,
	potentialParent
extends NeighborAttribute {}
 

pred Neighbor.attrChanged[attr: NeighborAttribute, t: Time]
{
	t!=first
	attr=networkAddress => this.networkAddress.t != this.networkAddress.(t.prev)
	attr=deviceType => this.deviceType.t != this.deviceType.(t.prev)
	attr=relationship => this.relationship.t != this.relationship.(t.prev)
	attr=depth => this.depth.t != this.depth.(t.prev)
	attr=permitJoining => this.permitJoining.t != this.permitJoining.(t.prev)
	attr=routerCapacity => this.routerCapacity.t != this.routerCapacity.(t.prev)
	attr=endDeviceCapacity => this.endDeviceCapacity.t != this.endDeviceCapacity.(t.prev)
	attr=potentialParent => this.potentialParent.t != this.potentialParent.(t.prev)
}


pred Neighbor.setAttr[attr: NeighborAttribute, value: univ, t: Time]
{
	attr=networkAddress => this.networkAddress.t = value
	attr=deviceType => this.deviceType.t = value
	attr=relationship => this.relationship.t = value
	attr=depth => this.depth.t = value
	attr=permitJoining => this.permitJoining.t = value
	attr=routerCapacity => this.routerCapacity.t = value
	attr=endDeviceCapacity => this.endDeviceCapacity.t = value
	attr=potentialParent => this.potentialParent.t = value
}

