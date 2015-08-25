/** 
 * @file	zigbee_join/base/random_event.als
 * @brief	Description of random events in ZigBee network
 * @author	Alexey Danilov (adanxelan@gmail.com)
 * @date	2008, April 24
 */
 
module zigbee_join/base/random_event

open zigbee_join/base/event as event
open zigbee_join/base/types as types


abstract sig RandomEvent extends AtomEvent
{}
{
	no  source
}

sig LinkFailureEvent extends RandomEvent
{
	nodeA, nodeB: Node		
}
{
	nodeA != nodeB
	no t':Time | gt[t',t] and nodeB in nodeA.hear.t'
}

abstract sig NodeRandomEvent extends RandomEvent
{
	node: Node
}

sig NodeDisappearEvent extends NodeRandomEvent 
{}
{
	no t':Time | gt[t',t] and
	(	
		some node.nwkNetworkAddress.t'
		or
		some node.nwkNeighborTable.t'
		or
		some node.nwkDeviceType.t'
		or
		some node.depth.t'
		or
		some node.permitJoining.t'
		or
		some node.routerCapacity.t'
		or
		some node.endDeviceCapacity.t'
		or
		some node.hear.t'
	)
}


run {some NodeDisappearEvent}