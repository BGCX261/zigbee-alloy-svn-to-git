/** 
 * @file	zigbee_join/base/config.als
 * @brief	Facts that define and constrain model behavior 
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 28
 * @since	2008, April 17
 *
 */
module zigbee_join/base/config

open util/relation
open zigbee_join/base/node
open zigbee_join/base/packet
open zigbee_join/base/util
open zigbee_join/base/update


fact NodeParameters {
	// Node constants
	all n: Node {
		n.aResponseWaitTime = 4
		n.aMaxFrameRetries = 3
		n.aMaxLostBeacons = 4
		n.nwkcMaxNeighborTableSize = 3
	}
	// all extended addresses are different
	no n1,n2: Node {
		n1!=n2
		n1.aExtendedAddress = n2.aExtendedAddress
	}

}



fact Reachability 
{
	all t: Time | symmetric[hear.t] and irreflexive[hear.t]
}


fact NoNeighborSharing
{
	no nbr: Neighbor, t: Time {
		some n1,n2: Node {
			n1 != n2
			nbr in n1.nwkNeighborTable.t
			nbr in n2.nwkNeighborTable.t
}	}	}


fact PacketTransmission
{
	all p: Packet, t: Time, n: Node {
		sub[p.@t',p.@t] <= p.source.node.aMaxFrameRetries
		(lte[t,p.@t] or gt[t,p.@t']) => no p.nodes.t
		else {
			n.canHear[p.source.node,t] <=> n in p.nodes.t
}	}	}


// No change in network level attributes except from explicit update events
fact NwkUpdates
{ 
	all n: Node, t: Time, attr: NwkAttribute {
		(n.attrChanged[attr,t] or some n.updatesAt[attr,t]) => 
			some u: n.updatesAt[attr,t] | n.setAttr[attr,u.value,t]
} 	}


// No change in neighbor attributes except from explicit update events
fact NeighborUpdates
{
	all n: Neighbor, t: Time, attr: NeighborAttribute {
		(n.attrChanged[attr,t] or some n.updatesAt[attr,t]) => 
			some u: n.updatesAt[attr,t] | n.setAttr[attr,u.value,t]
} 	}


// Source events contain their censequences
fact EventSources
{
	all e: AtomEvent, s: LongEvent {
		e.source=s => s.spans[e]
	}
	all e,s: LongEvent {
		e.source=s => e.interafter[s]
	}
	all e,s: NodeEvent {
		e.source=s => s.spans[e] and e.node = s.node
	}
}
