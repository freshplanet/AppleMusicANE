/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 03/10/2017.
 */
package com.freshplanet.ane.AppleMusic.events {
import com.freshplanet.ane.AppleMusic.VOs.AirAppleMusicPlaylist;

public class AirAppleMusicPlaylistEvent extends AirAppleMusicEvent {

	static public const PLAYLIST_DATA : String = "AppleMusicPlaylistEvent_playlistData";

	private var _playlist:AirAppleMusicPlaylist;

	public function AirAppleMusicPlaylistEvent(type:String, playlist:AirAppleMusicPlaylist, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_playlist = playlist;
	}

	public function get playlist():AirAppleMusicPlaylist {
		return _playlist;
	}
}
}
