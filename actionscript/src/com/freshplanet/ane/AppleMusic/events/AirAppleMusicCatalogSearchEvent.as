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
package com.freshplanet.ane.AppleMusic.events {
import com.freshplanet.ane.AppleMusic.VOs.AirAppleMusicSong;

public class AirAppleMusicCatalogSearchEvent extends AirAppleMusicEvent {

	/**
	 * Receiving search results for Apple Music Catalog search. Use this in conjunction with <code>performAppleMusicCatalogSearch</code>
	 */
	static public const RECEIVED_SEARCH_RESULTS :String = "AppleMusicSearchEvent_receivedSearchResults";

	private var _results:Vector.<AirAppleMusicSong>;

	/**
	 * AirAppleMusicCatalogSearchEvent
	 * @param type
	 * @param results
	 * @param bubbles
	 * @param cancelable
	 */
	public function AirAppleMusicCatalogSearchEvent(type:String, results:Vector.<AirAppleMusicSong>, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_results = results;
	}

	/**
	 * Results of the preformed Apple Music Catalog search
	 */
	public function get results():Vector.<AirAppleMusicSong> {
		return _results;
	}
}
}
