/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 13/12/2016.
 */
package com.freshplanet.ane.AppleMusic.enums {
public class AppleMusicAuthorizationStatus {


	/***************************
	 *
	 * PUBLIC
	 *
	 ***************************/


	static public const AUTORIZED   : AppleMusicAuthorizationStatus = new AppleMusicAuthorizationStatus(Private, "authorized");
	static public const DENIED   : AppleMusicAuthorizationStatus = new AppleMusicAuthorizationStatus(Private, "denied");
	static public const NOT_DETERMINED   : AppleMusicAuthorizationStatus = new AppleMusicAuthorizationStatus(Private, "not_determined");
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
