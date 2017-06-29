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
public class AppleMusicSongType {


	/***************************
	 *
	 * PUBLIC
	 *
	 ***************************/


	/**
	 * Media Library song type
 	 */
	static public const MEDIA_LIBRARY   : AppleMusicSongType = new AppleMusicSongType(Private, "media_library_song");
	/**
	 * Apple Music Catalog song type
	 */
	static public const APPLE_MUSIC_CATALOG   : AppleMusicSongType = new AppleMusicSongType(Private, "apple_music_catalog_song");

	public static function fromValue(value:String):AppleMusicSongType {

		switch (value)
		{
			case MEDIA_LIBRARY.value:
				return MEDIA_LIBRARY;
				break;
			case APPLE_MUSIC_CATALOG.value:
				return APPLE_MUSIC_CATALOG;
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

	public function AppleMusicSongType(access:Class, value:String) {

		if (access != Private)
			throw new Error("Private constructor call!");

		_value = value;
	}
}
}

final class Private {}
