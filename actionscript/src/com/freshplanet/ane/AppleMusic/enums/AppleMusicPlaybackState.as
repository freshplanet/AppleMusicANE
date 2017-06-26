/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 13/12/2016.
 */
package com.freshplanet.ane.AppleMusic.enums {
public class AppleMusicPlaybackState {


	/***************************
	 *
	 * PUBLIC
	 *
	 ***************************/


	static public const STOPPED   : AppleMusicPlaybackState = new AppleMusicPlaybackState(Private, "stopped");
	static public const PLAYING   : AppleMusicPlaybackState = new AppleMusicPlaybackState(Private, "playing");
	static public const PAUSED : AppleMusicPlaybackState = new AppleMusicPlaybackState(Private, "paused");
	static public const INTERRUPTED   : AppleMusicPlaybackState = new AppleMusicPlaybackState(Private, "interrupted");

	public static function fromValue(value:String):AppleMusicPlaybackState {

		switch (value)
		{
			case STOPPED.value:
				return STOPPED;
				break;
			case PLAYING.value:
				return PLAYING;
				break;
			case PAUSED.value:
				return PAUSED;
				break;
			case INTERRUPTED.value:
				return INTERRUPTED;
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

	public function AppleMusicPlaybackState(access:Class, value:String) {

		if (access != Private)
			throw new Error("Private constructor call!");

		_value = value;
	}
}
}

final class Private {}
