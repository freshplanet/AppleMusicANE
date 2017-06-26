/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 22/06/2017.
 */
package com.freshplanet.ane.AppleMusic.events {
import com.freshplanet.ane.AppleMusic.enums.AppleMusicAuthorizationStatus;
import com.freshplanet.ane.AppleMusic.enums.AppleMusicAuthorizationType;

public class AppleMusicAuthorizationEvent extends AppleMusicEvent {

	static public const AUTHORIZATION_DID_UPDATE :String = "AppleMusicAuthorizationEvent_authorizationDidUpdate";

	private var _authorizationType:AppleMusicAuthorizationType;
	private var _authorizationStatus:AppleMusicAuthorizationStatus;

	public function AppleMusicAuthorizationEvent(type:String, authorizationType:AppleMusicAuthorizationType, authorizationStatus:AppleMusicAuthorizationStatus, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_authorizationType = authorizationType;
		_authorizationStatus = authorizationStatus;
	}

	public function get authorizationType():AppleMusicAuthorizationType {
		return _authorizationType;
	}

	public function get authorizationStatus():AppleMusicAuthorizationStatus {
		return _authorizationStatus;
	}
}
}
