/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 13/12/2016.
 */
package com.freshplanet.ane.AppleMusic.enums {
public class AppleMusicAuthorizationType {


	/***************************
	 *
	 * PUBLIC
	 *
	 ***************************/


	static public const MEDIA_LIBRARY   : AppleMusicAuthorizationType = new AppleMusicAuthorizationType(Private, "media_library");
	static public const CLOUD_SERVICE   : AppleMusicAuthorizationType = new AppleMusicAuthorizationType(Private, "cloud_service");

	public static function fromValue(value:String):AppleMusicAuthorizationType {

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

	public function AppleMusicAuthorizationType(access:Class, value:String) {

		if (access != Private)
			throw new Error("Private constructor call!");

		_value = value;
	}
}
}

final class Private {}
