/**
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.freshplanet.ane.AppleMusic.events {
import flash.events.Event;

public class AppleMusicEvent extends Event {

	/**
	 * Music played updated the state ( play/pause/stop, next item began playback...)
 	 */
	static public const MUSIC_PLAYER_DID_UPDATE_STATE :String = "AppleMusicEvent_musicPlayerDidUpdateState";

	/**
	 * When attempting to present trial dialog, this event will be received in case the user is not eligible
	 */
	static public const SUBSCRIPTION_TRIAL_NOT_ELIGIBLE :String = "AppleMusicEvent_subscriptionTrialNotEligible";
	/**
	 * Trial dialog was dismissed by the user
	 */
	static public const DID_DISMISS_SUBSCRIPTION_TRIAL_DIALOG :String = "AppleMusicEvent_didDismissSubscriptionTrialDialog";

	public function AppleMusicEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
	}

}
}
