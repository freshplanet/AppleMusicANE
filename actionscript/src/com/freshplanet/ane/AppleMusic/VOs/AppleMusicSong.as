/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 23/06/2017.
 */
package com.freshplanet.ane.AppleMusic.VOs {
import com.freshplanet.ane.AppleMusic.enums.AppleMusicSongType;

import flash.display.BitmapData;

public class AppleMusicSong {

	private var _id:String;
	private var _songName:String;
	private var _albumName:String;
	private var _artistName:String;
	private var _type:AppleMusicSongType;
	private var _duration:Number;
	private var _artwork:BitmapData;
	private var _artworkURL:String;
	private var _artworkWidth:Number;
	private var _artworkHeight:Number;

	public function AppleMusicSong(id:String, songName:String, albumName:String, artistName:String, duration:Number, type:AppleMusicSongType, artworkURL:String, artworkWidth:Number, artworkHeight:Number) {
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

	public function get id():String {
		return _id;
	}

	public function get songName():String {
		return _songName;
	}

	public function get albumName():String {
		return _albumName;
	}

	public function get artistName():String {
		return _artistName;
	}

	public function get type():AppleMusicSongType {
		return _type;
	}

	public function get duration():Number {
		return _duration;
	}

	public function get artwork():BitmapData {
		return _artwork;
	}

	public function set artwork(value:BitmapData):void {
		_artwork = value;
		_artworkWidth = value ? value.width : NaN;
		_artworkHeight = value ? value.height : NaN;
	}


}
}
