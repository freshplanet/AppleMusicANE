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
public class AppleMusicPlaybackState {


	/***************************
	 *
	 * PUBLIC
	 *
	 ***************************/

	/**
	 * The music player is stopped.
	 */
	static public const STOPPED   : AppleMusicPlaybackState = new AppleMusicPlaybackState(Private, "stopped");
	/**
	 * The music player is playing.
	 */
	static public const PLAYING   : AppleMusicPlaybackState = new AppleMusicPlaybackState(Private, "playing");
	/**
	 * The music player is paused.
	 */
	static public const PAUSED : AppleMusicPlaybackState = new AppleMusicPlaybackState(Private, "paused");
	/**
	 * The music player has been interrupted, such as by an incoming phone call.
	 */
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
