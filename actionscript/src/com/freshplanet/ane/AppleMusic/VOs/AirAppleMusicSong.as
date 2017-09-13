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
package com.freshplanet.ane.AppleMusic.VOs {
import com.freshplanet.ane.AppleMusic.enums.AirAppleMusicSongType;
import flash.display.BitmapData;

public class AirAppleMusicSong {

	private var _id:String;
	private var _songName:String;
	private var _albumName:String;
	private var _artistName:String;
	private var _type:AirAppleMusicSongType;
	private var _duration:Number;
	private var _artwork:BitmapData;
	private var _artworkURL:String;
	private var _artworkWidth:Number;
	private var _artworkHeight:Number;

	/**
	 * AirAppleMusicSong
	 * @param id
	 * @param songName
	 * @param albumName
	 * @param artistName
	 * @param duration
	 * @param type
	 * @param artworkURL
	 * @param artworkWidth
	 * @param artworkHeight
	 */
	public function AirAppleMusicSong(id:String, songName:String, albumName:String, artistName:String, duration:Number, type:AirAppleMusicSongType, artworkURL:String, artworkWidth:Number, artworkHeight:Number) {
		_id = id;
		_songName = songName;
		_albumName = albumName;
		_artistName = artistName;
		_duration = duration;
		_type = type;
		_artworkURL = artworkURL;
		_artworkWidth = artworkWidth;
		_artworkHeight = artworkHeight;
	}

	/**
	 * Song id
	 */
	public function get id():String {
		return _id;
	}

	/**
	 * Name of the song
	 */
	public function get songName():String {
		return _songName;
	}

	/**
	 * Album name
	 */
	public function get albumName():String {
		return _albumName;
	}

	/**
	 * Artist name
	 */
	public function get artistName():String {
		return _artistName;
	}

	/**
	 * Type of the song (Media Library or Apple Music Catalog)
	 */
	public function get type():AirAppleMusicSongType {
		return _type;
	}

	/**
	 * Song duration
	 */
	public function get duration():Number {
		return _duration;
	}

	/**
	 * BitmapData of the artwork of the song. Used for Media Library songs
	 */
	public function get artwork():BitmapData {
		return _artwork;
	}

	public function set artwork(value:BitmapData):void {
		_artwork = value;
		_artworkWidth = value ? value.width : NaN;
		_artworkHeight = value ? value.height : NaN;
	}

	/**
	 * Artwork image width
	 */
	public function get artworkWidth():Number {
		return _artworkWidth;
	}

	/**
	 * Artwork image height
	 */
	public function get artworkHeight():Number {
		return _artworkHeight;
	}

	/**
	 * Artwork URL used for Apple Music Catalog songs
	 */
	public function get artworkURL():String {
		return _artworkURL;
	}
}
}
