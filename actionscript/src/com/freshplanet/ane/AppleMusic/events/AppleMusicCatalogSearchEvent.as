/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 24/06/2017.
 */
package com.freshplanet.ane.AppleMusic.events {
import com.freshplanet.ane.AppleMusic.VOs.AppleMusicSong;

public class AppleMusicCatalogSearchEvent extends AppleMusicEvent {

	static public const RECEIVED_SEARCH_RESULTS :String = "AppleMusicSearchEvent_receivedSearchResults";
	private var _results:Vector.<AppleMusicSong>;

	public function AppleMusicCatalogSearchEvent(type:String, results:Vector.<AppleMusicSong>, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_results = results;
	}

	public function get results():Vector.<AppleMusicSong> {
		return _results;
	}
}
}
