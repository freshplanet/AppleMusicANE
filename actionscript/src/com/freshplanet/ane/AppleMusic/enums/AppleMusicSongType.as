/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 13/12/2016.
 */
package com.freshplanet.ane.AppleMusic.enums {
public class AppleMusicSongType {


	/***************************
	 *
	 * PUBLIC
	 *
	 ***************************/


	static public const MEDIA_LIBRARY   : AppleMusicSongType = new AppleMusicSongType(Private, "media_library_song");
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
