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
public class AppleMusicCloudServiceEvent extends AppleMusicEvent {

	/**
	 * Cloud Service Capabilities or Storefront country code changed
	 */
	static public const CLOUD_SERVICE_DID_UPDATE :String = "AppleMusicCloudServiceEvent_cloudServiceDidUpdate";

	/**
	 * AppleMusicCloudServiceEvent
	 * @param type
	 * @param bubbles
	 * @param cancelable
	 */
	public function AppleMusicCloudServiceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
	}
}
}
