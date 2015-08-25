/** 
 * @brief	Tests for association primitives
 * @author	Andrey Kupriyanov
 * @date	2008, April 17
 * @since	2008, April 17
 *
 */
module zigbee_join/test/associate

open zigbee_join/base as z
open zigbee_join/nwk/associate_indication as nwk_associate_indication
open zigbee_join/mac/associate_indication as mac_associate_indication
open zigbee_join/mac/associate as associate
open zigbee_join/nwk/join_assoc as join_assoc


pred Success { some r: JoinAssoc | r.status = SUCCESS }

run Success for 5 but 7 Time, 10 Event


