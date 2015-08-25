/** 
 * @file	zigbee_join/nwk/discovery.als
 * @brief	Discover networks (routers) operating within the POS
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 14
 * @since	2008, April 12
 *
 * We assume that each router transmits a beacon at every time step 
 */
module zigbee_join/nwk/discovery

open zigbee_join/base as z


sig Discovery  extends NodeEvent {

	// Request
	scanDuration: Int,

	// Confirm
	status: Status,
	
	// NWK updates
	neighborTableUpdates: set NwkUpdate,
	neighborUpdates: set NeighborUpdate
}
{
	sub[t',t] = scanDuration
	all tm: Time | gte[tm,t] and lte[tm,t'] => {
		all r: Node | r.isCoordinatorOrRouter[tm] and node.canHear[r,tm] => {
			let n = {n: Neighbor | n in node.nwkNeighborTable.tm and n.extendedAddress = r.aExtendedAddress} |
			some n => syncNeighborWithNode[n,r,tm]
		}
	}
}
run { some d: Discovery {
	all t: Time | !d.node.isNeighborTableFull[t] 
	d.scanDuration = 1 
	some n,r1,r2: Node, t: Time {
		r1.nwkDeviceType.t=DEVICE_ROUTER 
		n.canHear[r1,t]
		d.node = n
		n.canHear[r2,t.next]
	}
} } for 5 but 10 NeighborUpdate




pred NodeEvent.syncNeighborWithNode[nbr: Neighbor, node: Node, t: Time]
{
	nbr.extendedAddress = node.aExtendedAddress
//	TODO: extend this predicate
//	this.update[nbr,networkAddress,node.nwkNetworkAddress.t,t]

}



