/** 
 * @file	zigbee_join/base/packet.als
 * @brief	Packet formats and utilities
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 11
 * @since	2008, April 11
 *
 */
module zigbee_join/base/packet

open zigbee_join/base/event as node


abstract sig Packet extends PhyEvent {
	sourceAddress: Addr,
	destinationAddress: Addr,	-- this field should be set by sender

	nodes: set Node -> Time		-- current position of the packet

}

pred NodeEvent.send[p: Packet,t: Time]
{
	p.@t = t
	p.source = this
	p.sourceAddress = this.node.aExtendedAddress
}

pred NodeEvent.sendTo[p: Packet,t: Time, destAddr: Addr]
{
	p.destinationAddress = destAddr
	this.send[p,t]
}

run { some p: Packet, t: Time | #p.nodes.t=3 } for 6

// Returns the set of packets of specified type, received from t1 to t2
fun NodeEvent.receive[type: set Packet, t1,t2: Time]: set Packet
{{ p: Packet {
	p in type
	p.destinationAddress = this.node.aExtendedAddress
	or p.destinationAddress in SHORTADDR_0xFF
	some t: Time {
		gte[t,t1]
		lte[t,t2]
		this.node in p.nodes.t
	}	
}}}

pred NodeEvent.receivedBefore[p1,p2: Packet]
{
	some t: Time |this.node in p1.nodes.t and no t': Time {
		lt[t',t]
		this.node in p2.nodes.t'
	}
}


fun NodeEvent.receiveFirst[type: set Packet, t1,t2: Time]: lone Packet
{{ 	p: Packet | let received=this.receive[type,t1,t2] {
		p in received
		all p2: received-p | this.receivedBefore[p,p2]
}}}

fun NodeEvent.receptionTime[p: Packet]: Time
{{ 
	t: Time {
		this.node in p.nodes.t
		no t': Time {
			lt[t',t]
			this.node in p.nodes.t'		
		}
	}
}}


sig AssociationRequest extends Packet {
	deviceType: DeviceType
}

sig AssociationResponse extends Packet {
	shortAddress: ShortAddr,
	associationStatus: Status
} 


sig OrphanNotification extends Packet {
} 


sig CoordinatorRealignment extends Packet {
	coordinatorShortAddress: ShortAddr,
	shortAddress: ShortAddr
}
