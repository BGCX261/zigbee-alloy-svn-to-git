/** 
 * @file	zigbee_join/mac/associate.als
 * @brief	MAC layer request to join a network through association
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, May 3
 * @since	2008, April 1
 *
 */
module zigbee_join/mac/associate

open zigbee_join/base as z




sig Associate extends MacRequest {
	// Request
	coordAddress: Addr,
	deviceType: DeviceType,

	// Confirm
	assocShortAddress: ShortAddr,
	status: Status,

	// Packets
	request: AssociationRequest,
	response: lone AssociationResponse
} {
	request.destinationAddress = coordAddress
	request.deviceType = deviceType
	send[request,t]
	
	sub[t',t] <= node.aResponseWaitTime
	some response => {
		t' = receptionTime[response]
		response in receive[AssociationResponse,t,t']
		assocShortAddress = response.shortAddress
		status = response.associationStatus
	}
	else {
		sub[t',t] = node.aResponseWaitTime
		status = MAC_NO_DATA
	}
	noEventsExcept[request]
}


fun NodeEvent.associate[coordAddress: ExtAddr, deviceType: DeviceType]: Associate
{{	r: Associate {
	this.call[r]
	r.@coordAddress = coordAddress
	r.@deviceType = deviceType
}}}


fact AssociationRequest
{
	all p: AssociationRequest {
		one e: Associate {
			p.source=e
			e.request = p
		}
	}
}