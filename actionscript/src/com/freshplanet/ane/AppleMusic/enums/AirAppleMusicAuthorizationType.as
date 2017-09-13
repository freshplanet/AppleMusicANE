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
public class AirAppleMusicAuthorizationType {


	/***************************
	 *
	 * PUBLIC
	 *
	 ***************************/

	/**
	 * Media Library authorization type
	 */
	static public const MEDIA_LIBRARY   : AirAppleMusicAuthorizationType = new AirAppleMusicAuthorizationType(Private, "media_library");
	/**
	 * Cloud Service authorization type
	 */
	static public const CLOUD_SERVICE   : AirAppleMusicAuthorizationType = new AirAppleMusicAuthorizationType(Private, "cloud_service");

	public static function fromValue(value:String):AirAppleMusicAuthorizationType {

		switch (value)
		{
			case MEDIA_LIBRARY.value:
				return MEDIA_LIBRARY;
				break;
			case CLOUD_SERVICE.value:
				return CLOUD_SERVICE;
				break;
			default:
				return null;
			break;
		}
	}

	public function get value():String {
		return _value;
	}

	/***************************
	 *
	 * PRIVATE
	 *
	 ***************************/

	private var _value:String = null;

	public function AirAppleMusicAuthorizationType(access:Class, value:String) {

		if (access != Private)
			throw new Error("Private constructor call!");

		_value = value;
	}
}
}

final class Private {}
