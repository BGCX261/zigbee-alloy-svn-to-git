/** 
 * @brief	MAC layer handling of AssociateRequest packet
 * @author	Andrey Kupriyanov
 * @date	2008, May 3
 * @since	2008, May 3
 *
 */
module zigbee_join/mac/associate_indication

open zigbee_join/base as z
open zigbee_join/nwk/associate_indication as associate_indication


// MLME-ORPHAN.indication/response
sig MacAssociateIndication extends MacIndication 
{
	// NWK layer indications
	indication: NwkAssociateIndication,

	// Packets
	request: AssociationRequest,
	response: AssociationResponse	
} {
	// Each AssociateIndication is a result of one AssociateRequest packet
	request in receive[AssociationRequest,t,t]
	indication = associateIndication[request.sourceAddress,request.deviceType]
	
	// Send AssociationResponse packet
	response.shortAddress = indication.assocShortAddress
	response.associationStatus = indication.status
	sendTo[response,t',request.sourceAddress]

	noEventsExcept[indication+response]
}

fact AssociationRequest
{
	all p: AssociationRequest, n: Node, t: Time {
		lone e: MacAssociateIndication {
			e.source=p
			e.node = n
			e.@t = t
		}
	}
}

fact AssociationResponse
{
	all p: AssociationResponse {
		one e: MacAssociateIndication {
			p.source=e
			e.response = p
		}
	}
}
