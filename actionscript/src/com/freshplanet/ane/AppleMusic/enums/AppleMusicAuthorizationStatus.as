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
package com.freshplanet.ane.AppleMusic.enums {
public class AppleMusicAuthorizationStatus {


	/***************************
	 *
	 * PUBLIC
	 *
	 ***************************/


	/**
	 * Authorized
 	 */
	static public const AUTORIZED   : AppleMusicAuthorizationStatus = new AppleMusicAuthorizationStatus(Private, "authorized");
	/**
	 * Denied
	 */
	static public const DENIED   : AppleMusicAuthorizationStatus = new AppleMusicAuthorizationStatus(Private, "denied");
	/**
	 * Not determined - not yet requested
	 */
	static public const NOT_DETERMINED   : AppleMusicAuthorizationStatus = new AppleMusicAuthorizationStatus(Private, "not_determined");
	/**
	 * Restricted
	 */
	static public const RESTRICTED   : AppleMusicAuthorizationStatus = new AppleMusicAuthorizationStatus(Private, "restricted");

	public static function fromValue(value:String):AppleMusicAuthorizationStatus {

		switch (value)
		{
			case AUTORIZED.value:
				return AUTORIZED;
				break;
			case DENIED.value:
				return DENIED;
				break;
			case NOT_DETERMINED.value:
				return NOT_DETERMINED;
				break;
			case RESTRICTED.value:
				return RESTRICTED;
				break;
			default:
				return null;
			break;
		}
	}

	/**
	 * Raw string value
	 */
	public function get value():String {
		return _value;
	}

	/***************************
	 *
	 * PRIVATE
	 *
	 ***************************/

	private var _value:String = null;

	public function AppleMusicAuthorizationStatus(access:Class, value:String) {

		if (access != Private)
			throw new Error("Private constructor call!");

		_value = value;
	}
}
}

final class Private {}
