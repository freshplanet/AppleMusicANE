/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 22/06/2017.
 */
package com.freshplanet.ane.AppleMusic.events {
import flash.events.Event;

public class AppleMusicEvent extends Event {

	static public const MUSIC_PLAYER_DID_UPDATE_STATE :String = "AppleMusicEvent_musicPlayerDidUpdateState";

	static public const SUBSCRIPTION_TRIAL_NOT_ELIGIBLE :String = "AppleMusicEvent_subscriptionTrialNotEligible";
	static public const DID_DISMISS_SUBSCRIPTION_TRIAL_DIALOG :String = "AppleMusicEvent_didDismissSubscriptionTrialDialog";

	public function AppleMusicEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
	}

}
}
