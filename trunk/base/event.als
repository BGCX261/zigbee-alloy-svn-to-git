/** 
 * @file	zigbee_join/base/event.als
 * @brief	Description of timed events
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, May 3
 * @since	2008, April 1
 *
 * Reduction of complete ZigBee model to test the join-leave behaviour
 */
module zigbee_join/base/event

open zigbee_join/base/types as types
open zigbee_join/base/node as node


abstract sig Event {
	source: lone LongEvent
} 

// // No other events originating from this
pred Event.noEvents[]
{
	no e: Event | e.@source=this
}

// No other events originating from this, except explicitly specified
pred Event.noEventsExcept[events: set Event]
{
	all e: Event | e.@source=this => e in events
}


abstract sig AtomEvent extends Event {
	t: Time
}

abstract sig LongEvent extends Event {
	t,t': Time 
} { 
	gt[t',t] 
}


pred LongEvent::spans[e: AtomEvent]
{
	lte[this.t,e.t]
	gte[this.t',e.t]
}

pred LongEvent::spans[e: LongEvent]
{
	lte[this.t,e.t]
	gte[this.t',e.t']
}

pred AtomEvent.before[t: Time] { lt[this.@t,t] }

pred AtomEvent.before[e: AtomEvent] { lt[this.t,e.t] }

pred AtomEvent.before[e: LongEvent] { lt[this.t,e.t] }

pred LongEvent.before[e: AtomEvent] { lt[this.t',e.t] }

pred LongEvent.before[e: LongEvent] { lt[this.t',e.t] }


pred AtomEvent.after[t: Time] { gt[this.@t,t] }

pred AtomEvent.after[e: AtomEvent] { gt[this.t,e.t] }

pred AtomEvent.after[e: LongEvent] { gt[this.t,e.t'] }

pred LongEvent.after[e: AtomEvent] { gt[this.t,e.t] }

pred LongEvent.after[e: LongEvent] { gt[this.t,e.t'] }



pred LongEvent.disjointed[e: LongEvent]
{
	this.after[e] or e.after[this]
}

pred LongEvent.interferes[e: LongEvent]
{
	!this.disjointed[e]
}

pred LongEvent.interafter[e: LongEvent]
{
	this.interferes[e]
	gte[this.t,e.t]
}


// Event that happens at a specific node
abstract sig NodeEvent extends LongEvent {
	node: Node
} 

abstract sig PhyEvent extends LongEvent {} {
	some source
	source in MacRequest+MacIndication
}

abstract sig MacEvent extends NodeEvent {} {
	some source
}
abstract sig MacRequest extends MacEvent {
} {
	source in NwkRequest 
}
abstract sig MacIndication extends MacEvent {} {
	source in PhyEvent
}

abstract sig NwkEvent extends NodeEvent {} {
	some source
}
abstract sig NwkRequest extends NwkEvent {} {
	source in AplEvent
}
abstract sig NwkIndication extends NwkEvent {} {
	source in MacIndication	
}

abstract sig AplEvent extends NodeEvent {} {
	no source
}


pred NodeEvent.isCallerOf[e: NodeEvent]
{
	this.node = e.node
	this.spans[e]
	e.source = this
}

pred NodeEvent.call[e: NodeEvent]
{
	this.node = e.node
	this.spans[e]
	e.source = this
}

pred NodeEvent.call[e: AtomEvent]
{
	this.spans[e]
	e.source = this
}


pred NodeEvent.contains[e: NodeEvent]
{
	this.spans[e]
	this.node = e.node
}




run { some Event }

