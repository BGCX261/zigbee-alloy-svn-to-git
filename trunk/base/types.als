/** 
 * @file	zigbee_join/base/types.als
 * @brief	Signatures and constants common to all ZigBee model components 
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 17
 * @since	2008, April 1		
 *
 * Reduction of complete ZigBee model to test the join-leave behaviour
 */
module zigbee_join/base/types

open util/boolean as bool
open util/natural as natural
open util/ordering[Time] as to

sig
	Time {}

abstract sig Status {}
one sig 
	SUCCESS 
extends Status {}

abstract sig NwkStatus extends Status {}
one sig 
	NWK_NOT_PERMITTED,				-- 0xc3 An NLME-JOIN.request has been disallowed
	NWK_ALREADY_PRESENT, 			-- 0xc5 A device with the address supplied to the NLMEDIRECT-JOIN.request is already present in the neighbor table of the device on which the NLMEDIRECT-JOIN.request was issued.
	NWK_NEIGHBOR_TABLE_FULL, 		-- 0xc7 An NLME-JOIN-DIRECTLY.request has failed because there is no more room in the neighbor table.
	NWK_UNKNOWN_DEVICE, 			-- 0xc8 An NLME-LEAVE.request has failed because the device addressed in the parameter list is not in the neighbor table of the issuing device.
	NWK_NO_NETWORKS 				-- 0xca An NLME-JOIN.request has been issued in an environment where no networks are detectable.
extends NwkStatus {}


abstract sig MacStatus extends Status {}
one sig 
	MAC_NO_BEACON,
	MAC_NO_DATA,
	MAC_PAN_AT_CAPACITY,
	MAC_PAN_ACCESS_DENIED
extends MacStatus {}


// Short or long address
abstract sig Addr {}


sig ShortAddr extends Addr {}
one sig 
	SHORTADDR_0x00,
	SHORTADDR_0x01,
	SHORTADDR_0x02,
	SHORTADDR_0x03,
	SHORTADDR_0xFF
extends ShortAddr {}


sig ExtAddr extends Addr {}
one sig 
	EXTADDR_0x00,
	EXTADDR_0x01,
	EXTADDR_0x02,
	EXTADDR_0x03,
	EXTADDR_0xFF
extends ExtAddr {}


abstract sig DeviceType {}
one sig
	DEVICE_COORDINATOR,
	DEVICE_ROUTER,
	DEVICE_ENDDEVICE
extends DeviceType {}

abstract sig Relation {}
one sig
	RELATION_PARENT,		-- 0x00=neighbor is the parent
	RELATION_CHILD,			-- 0x01=neighbor is a child
	RELATION_SIBLING,		-- 0x02=neighbor is a sibling
	RELATION_NONE,			-- 0x03=none of the above
	RELATION_PREVCHILD,		-- 0x04=previous child
	RELATION_UNAUTHCHILD	-- 0x05=unauthenticated child
extends Relation {}

fun  Time.sub[t: Time]: Int
{
	#prevs[this] - #prevs[t]
}

