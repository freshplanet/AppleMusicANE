/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 22/06/2017.
 */
package com.freshplanet.ane.AppleMusic.events {
public class AppleMusicCloudServiceEvent extends AppleMusicEvent {

	static public const CLOUD_SERVICE_DID_UPDATE :String = "AppleMusicCloudServiceEvent_cloudServiceDidUpdate";

	public function AppleMusicCloudServiceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
	}
}
}
