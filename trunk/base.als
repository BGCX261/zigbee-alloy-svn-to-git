/** 
 * @file	zigbee_join/base.als
 * @brief	Main "include" file for the model components
 * @author	Andrey Kupriyanov (akupriyanov@acm.org)
 * @date	2008, April 17
 * @since	2008, April 17
 *
 * We consider just ONE network, operating at ONE channel.
 *
 * We assume that all devices in the network admit the same timing,
 * i.e. the same BeaconOrder and SuperframeOrder, and that this timing
 * is enough for all devices to operate correctly. 
 *
 * We do not model beacon packets explicitly. Instead we assume that
 * each router in the network transmits a beacon every N time steps.
 *
 * All reachability and conflicts issues are modeled by reachability
 * relation, hear (Node -> set Node -> Time): node.hear.t contains
 * the set of other nodes this one can hear at time t.
 */
module zigbee_join/base

open zigbee_join/base/types as types
open zigbee_join/base/node as node
open zigbee_join/base/neighbor as neighbor
open zigbee_join/base/event as event
open zigbee_join/base/packet as packet
open zigbee_join/base/util as util
open zigbee_join/base/update as update
open zigbee_join/base/config as config
