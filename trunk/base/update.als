/** 
 * @file	zigbee_join/base/update.als
 * @brief	Update events for NWK layer and Neighbor attributes
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, May 3
 * @since	2008, April 17
 */
module zigbee_join/base/update

open zigbee_join/base/neighbor as neighbor
open zigbee_join/base/node as node
open zigbee_join/base/event as event


// Updates for network level attributes

	
sig NwkUpdate extends AtomEvent {
	target: Node,
	attr: NwkAttribute,
	value: set univ
}{
	some source
	source in NwkEvent

	attr=nwkNetworkAddress => value in ShortAddr
	attr=nwkNeighborTable => value in Neighbor
	attr=nwkDeviceType => value in DeviceType
	attr=depth => value in Natural
	attr in permitJoining+routerCapacity+endDeviceCapacity => value in Bool	
}

fun Node.updatesAt[attr: NwkAttribute, t: Time]: NwkUpdate
{{
	u: NwkUpdate | u.target=this and u.@attr=attr and u.@t=t 
}}

pred NodeEvent.update[target: Node, attr: NwkAttribute, value: univ]
{ some e: NwkUpdate {
	this.call[e]
	e.@target = target
	e.@attr = attr
	e.@value = value
}}

pred NodeEvent.updateAt[target: Node, attr: NwkAttribute, value: univ, t: Time]
{ some e: NwkUpdate {
	this.call[e]
	e.@t = t
	e.@target = target
	e.@attr = attr
	e.@value = value
}}

pred NodeEvent.update[e: NwkUpdate, target: Node, attr: NwkAttribute, value: univ]
{	
	this.call[e]
	e.@target = target
	e.@attr = attr
	e.@value = value
}

fun NodeEvent.update[target: Node, attr: NwkAttribute, value: univ]: NwkUpdate
{{
	e: NwkUpdate {
		this.call[e]
		e.@target = target
		e.@attr = attr
		e.@value = value
	 }
}}

fun NodeEvent.addChild[extAddr: ExtAddr,netAddr: ShortAddr, devType: DeviceType]: NwkUpdate
{{	u: NwkUpdate | some child: Neighbor {
		this.update[u,this.node,nwkNeighborTable,this.node.nwkNeighborTable.(u.t.prev)+child]
		child.extendedAddress = extAddr
		child.networkAddress.(u.t) = netAddr
		child.deviceType.(u.t) = devType
		child.relationship.(u.t) = RELATION_CHILD
	}
}}


// Updates for neighbor table entry attributes


sig NeighborUpdate extends AtomEvent {
	target: Neighbor,
	attr: NeighborAttribute,
	value: univ
} {
	some source
	source in NwkEvent

	attr=networkAddress => value in ShortAddr
	attr=deviceType => value in DeviceType
	attr=relationship => value in Relation
	attr=depth => value in Natural
	attr in permitJoining + routerCapacity + endDeviceCapacity + potentialParent
		=> value in Bool
}	

fun Neighbor.updatesAt[attr: NeighborAttribute, t: Time]: NeighborUpdate
{{
	u: NeighborUpdate | u.target=this and u.@attr=attr and u.@t=t 
}}

pred NodeEvent.update[target: Neighbor,attr: NeighborAttribute, value: univ]
{ some e: NeighborUpdate {
	this.call[e]
	e.@target = target
	e.@attr = attr
	e.@value = value
}}


fun NodeEvent.update[target: Neighbor,attr: NeighborAttribute, value: univ]: NeighborUpdate
{
	{ e: NeighborUpdate | this.update[target,attr,value] }
}

pred NodeEvent.update[e: NeighborUpdate, target: Neighbor, attr: NeighborAttribute, value: univ]
{	
	this.call[e]
	e.@target = target
	e.@attr = attr
	e.@value = value
}

pred NodeEvent.updateAt[target: Neighbor,attr: NeighborAttribute, value: univ, t: Time]
{ 
	some e: NeighborUpdate {
		this.call[e]
		e.@t = t
		e.@target = target
		e.@attr = attr
		e.@value = value
	}
}
