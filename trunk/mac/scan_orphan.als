/** 
 * @file	zigbee_join/mac/scan_orphan.als
 * @brief	MAC layer request perform orphan network scan
 * @author	Elena Tomina, Andrey Kupriyanov
 * @date	2008, April 28
 * @since	2008, April 8
 *
 * Models of MLME-SCAN.request/confirm (with ScanType=0x03 - orphan scan),
 * MLME-ORPHAN.indication/response, 
 * and MAC command frames "Orphan Notification", "Coordinator Realignment"
 */
module zigbee_join/mac/scan_orphan

open zigbee_join/base as z

// MLME-SCAN.request/confirm
sig ScanOrphan extends MacRequest {
	// Request: no parameters
	
	// Confirm
	status: Status,
	shortAddress: 	ShortAddr,
	
	// Packets
	notification: OrphanNotification,
	realignment: lone CoordinatorRealignment
} {
	sendTo[notification,t,SHORTADDR_0xFF]
	
	sub[t',t] <= node.aResponseWaitTime
	some realignment => {
		t' = receptionTime[realignment]
		realignment in receive[CoordinatorRealignment,t,t']
		realignment.destinationAddress = node.aExtendedAddress
		shortAddress = realignment.shortAddress
		status = SUCCESS
	}
	else {
		sub[t',t] = node.aResponseWaitTime
		status = MAC_NO_BEACON
	}
	noEventsExcept[notification]
}

// Utility function to imitate imperative-style call of the request
fun NodeEvent.scanOrphan[]: ScanOrphan
{{	r: ScanOrphan {
	this.call[r]
}}}


fact OrphanNotification
{
	all p: OrphanNotification {
		one e: ScanOrphan {
			p.source=e
			e.notification = p
		}
	}
}
