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
import com.freshplanet.ane.AppleMusic.enums.AirAppleMusicAuthorizationStatus;
import com.freshplanet.ane.AppleMusic.enums.AirAppleMusicAuthorizationType;

public class AirAppleMusicAuthorizationEvent extends AirAppleMusicEvent {

	/**
	 * Media Library or Cloud Service authorization changed
	 */
	static public const AUTHORIZATION_DID_UPDATE :String = "AppleMusicAuthorizationEvent_authorizationDidUpdate";


	private var _authorizationType:AirAppleMusicAuthorizationType;
	private var _authorizationStatus:AirAppleMusicAuthorizationStatus;

	/**
	 * AirAppleMusicAuthorizationEvent
	 * @param type
	 * @param authorizationType
	 * @param authorizationStatus
	 * @param bubbles
	 * @param cancelable
	 */
	public function AirAppleMusicAuthorizationEvent(type:String, authorizationType:AirAppleMusicAuthorizationType, authorizationStatus:AirAppleMusicAuthorizationStatus, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_authorizationType = authorizationType;
		_authorizationStatus = authorizationStatus;
	}

	/**
	 * Type of authorization that changed
	 */
	public function get authorizationType():AirAppleMusicAuthorizationType {
		return _authorizationType;
	}

	/**
	 * New status of authorization
	 */
	public function get authorizationStatus():AirAppleMusicAuthorizationStatus {
		return _authorizationStatus;
	}
}
}
