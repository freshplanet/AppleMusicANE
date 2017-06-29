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
package com.freshplanet.ane.AppleMusic {
import com.freshplanet.ane.AppleMusic.VOs.AppleMusicSong;
import com.freshplanet.ane.AppleMusic.enums.AppleMusicAuthorizationStatus;
import com.freshplanet.ane.AppleMusic.enums.AppleMusicAuthorizationType;
import com.freshplanet.ane.AppleMusic.enums.AppleMusicPlaybackState;
import com.freshplanet.ane.AppleMusic.enums.AppleMusicSongType;
import com.freshplanet.ane.AppleMusic.events.AppleMusicAuthorizationEvent;
import com.freshplanet.ane.AppleMusic.events.AppleMusicCloudServiceEvent;
import com.freshplanet.ane.AppleMusic.events.AppleMusicEvent;
import com.freshplanet.ane.AppleMusic.events.AppleMusicCatalogSearchEvent;
import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.system.Capabilities;

public class AppleMusic extends EventDispatcher {

	// --------------------------------------------------------------------------------------//
	//																						 //
	// 									   PUBLIC API										 //
	// 																						 //
	// --------------------------------------------------------------------------------------//

	/**
	 * If <code>true</code>, logs will be displayed at the ActionScript level.
	 */
	public static var logEnabled:Boolean = false;


	/**
	 * Is the ANE supported on the current platform
	 */
	static public function get isSupported():Boolean {
        return Capabilities.manufacturer.indexOf("iOS") > -1;
	}

	/**
	 * Is the ANE supported on the current platform
	 */
	public function get nativeLogger():INativeLogger {
        return _logger;
    }

    /**
     * AppleMusic instance
     */
    static public function get instance():AppleMusic {
		return _instance != null ? _instance : new AppleMusic()
	}

	/**
	 * Initialize
	 * @param developerToken Apple Music developer token
	 */
	public function initialize(developerToken:String):void {
		_extContext.call("initialize", developerToken);
	}

	/**
	 * Get current Media Library authorization status
	 */
	public function get mediaLibraryAuthorizationStatus():AppleMusicAuthorizationStatus {
		var statusRaw:String = _extContext.call("mediaLibraryAuthorizationStatus") as String;
		return AppleMusicAuthorizationStatus.fromValue(statusRaw);
	}

	/**
	 * Get current Cloud Service authorization status
	 */
	public function get cloudServiceAuthorizationStatus():AppleMusicAuthorizationStatus {
		var statusRaw:String = _extContext.call("cloudServiceAuthorizationStatus") as String;
		return AppleMusicAuthorizationStatus.fromValue(statusRaw);
	}

	/**
	 * Request authorization for Media Library and Cloud Services
	 */
	public function requestAuthorization():void {
		_extContext.call("requestAuthorization");
	}

	/**
	 * Get current Cloud Service capabilities
	 */
	public function get cloudServiceCapabilities():uint {
		return _extContext.call("cloudServiceCapabilities") as uint;
	}

	/**
	 * Get Cloud Service Storefront country code
	 */
	public function get cloudServiceStorefrontCountryCode():String {
		return _extContext.call("cloudServiceStorefrontCountryCode") as String;
	}

	/**
	 * Get songs from Media Library
	 */
	public function getMediaLibrarySongs():Vector.<AppleMusicSong> {
		var itemsString:String = _extContext.call("getMediaLibrarySongs") as String;
		var mediaLibrarySongs:Vector.<AppleMusicSong> = parseAppleMusicSongItemsArrayJSON(itemsString);

		for (var i:int = 0; i < mediaLibrarySongs.length; i++) {
			var song:AppleMusicSong = mediaLibrarySongs[i];
			song.artwork = _extContext.call("getMediaLibrarySongArtwork", song.id) as BitmapData;

		}

		return mediaLibrarySongs;
	}

	/**
	 * Play songs. Songs must be previously aquired through <code>getMediaLibrarySongs</code> or <code>performAppleMusicCatalogSearch</code>
	 */
	public function playSongs(songs:Vector.<AppleMusicSong>):void {
		if(songs == null)
			return;
		var songIDsArray:Array = [];
		for (var i:int = 0; i < songs.length; i++) {
			var song:AppleMusicSong = songs[i];
			songIDsArray.push(song.id);
		}
		_extContext.call("playSongs", songIDsArray);
	}

	/**
	 * Toggle music player play / pause
	 */
	public function togglePlayPause():void {
		_extContext.call("togglePlayPause");
	}

	/**
	 * Skip to NEXT song
	 */
	public function skipToNextSong():void {
		_extContext.call("skipToNextSong");
	}

	/**
	 * Skip to PREVIOUS song
	 */
	public function skipToPreviousSong():void {
		_extContext.call("skipToPreviousSong");
	}

	/**
	 * Skip to beginning of the song
	 */
	public function skipToSongBeginning():void {
		_extContext.call("skipToSongBeginning");
	}

	/**
	 * Stop music player playback
	 */
	public function stopPlayback():void {
		_extContext.call("stopPlayback");
	}

	/**
	 * Get current music player playback state
	 */
	public function get playbackState():AppleMusicPlaybackState {
		var playbackStateRaw:String = _extContext.call("playbackState") as String;
		return AppleMusicPlaybackState.fromValue(playbackStateRaw);
	}

	/**
	 * Get item currently playing in music player
	 */
	public function get nowPlayingItem():AppleMusicSong {
		var itemString:String = _extContext.call("nowPlayingItem") as String;
		if (itemString == null)
			return null;
		return parseAppleMusicSongItemJSON(itemString);

	}

	/**
	 * Search Apple Music catalog
	 * @param searchText search keywords
	 * @param limit number of results to receive
	 * @param offset used for paging. Will skip first <code>offset</code> results
	 */
	public function performAppleMusicCatalogSearch(searchText:String, limit:int, offset:int):void {
		_extContext.call("performAppleMusicCatalogSearch", searchText, limit, offset);
	}

	/**
	 * Present trial if eligible.
	 * @param affiliateKey
	 * @param affiliateCampaignKey
	 */
	public function presentTrialDialogIfEligible(affiliateKey:String = null, affiliateCampaignKey:String = null):void {
		_extContext.call("presentTrialDialogIfEligible", affiliateKey == null ? "" : affiliateKey, affiliateCampaignKey == null ? "" : affiliateCampaignKey);
	}

	// --------------------------------------------------------------------------------------//
	//																						 //
	// 									 	PRIVATE API										 //
	// 																						 //
	// --------------------------------------------------------------------------------------//

	static private const EXTENSION_ID:String = "com.freshplanet.ane.AppleMusic";
	static private var _instance:AppleMusic = null;

	private var _extContext:ExtensionContext = null;
	private var _logger:INativeLogger;

	/**
	 * "private" singleton constructor
	 */
	public function AppleMusic() {

		super();

		if (_instance)
			throw new Error("singleton class, use .instance");

		_extContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
		_extContext.addEventListener(StatusEvent.STATUS, _handleStatusEvent);

		if (isSupported)
			_logger = new NativeLogger(_extContext);
		else
			_logger = new DefaultLogger();

		_instance = this;
	}

	/**
	 * Handle status event from native implementation
	 * @param event
	 */
    private function _handleStatusEvent(event:StatusEvent):void {

        if (event.code == "log")
            _log(event.level);
        else if (event.code == AppleMusicAuthorizationEvent.AUTHORIZATION_DID_UPDATE)
        {

	        var authorizationType:AppleMusicAuthorizationType = null;
	        var authorizationStatus:AppleMusicAuthorizationStatus = null;
	        try {
	            var authorizationData : Object = JSON.parse(event.level);
	            authorizationType = AppleMusicAuthorizationType.fromValue(authorizationData.type);
	            authorizationStatus= AppleMusicAuthorizationStatus.fromValue(authorizationData.status);
	        }
	        catch (e:Error) {
	            _log(e.message);
	        }

	        this.dispatchEvent(new AppleMusicAuthorizationEvent(AppleMusicAuthorizationEvent.AUTHORIZATION_DID_UPDATE, authorizationType, authorizationStatus));
        }
        else if (event.code == AppleMusicCloudServiceEvent.CLOUD_SERVICE_DID_UPDATE)
        {
	        this.dispatchEvent(new AppleMusicCloudServiceEvent(AppleMusicCloudServiceEvent.CLOUD_SERVICE_DID_UPDATE));
        }
        else if (event.code == AppleMusicEvent.MUSIC_PLAYER_DID_UPDATE_STATE || event.code == AppleMusicEvent.SUBSCRIPTION_TRIAL_NOT_ELIGIBLE || event.code == AppleMusicEvent.DID_DISMISS_SUBSCRIPTION_TRIAL_DIALOG)
        {
	        this.dispatchEvent(new AppleMusicEvent(event.code));
        }
        else if (event.code == AppleMusicCatalogSearchEvent.RECEIVED_SEARCH_RESULTS)
        {
	        var resultsString:String = event.level;
	        var searchResults:Vector.<AppleMusicSong> = parseAppleMusicSongItemsArrayJSON(resultsString);
	        this.dispatchEvent(new AppleMusicCatalogSearchEvent(AppleMusicCatalogSearchEvent.RECEIVED_SEARCH_RESULTS, searchResults));
        }
        else
            this.dispatchEvent(event);
    }

	/**
	 * Trace log messages if enabled
	 * @param strings
	 */
	private function _log(...strings):void {
		if (logEnabled) {

			strings.unshift(EXTENSION_ID);
			trace.apply(null, strings);
		}

	}

	/**
	 * Parse json song results array received from native implementation
	 * @param jsonString
	 * @return
	 */
	private function parseAppleMusicSongItemsArrayJSON(jsonString:String):Vector.<AppleMusicSong> {

		var result:Vector.<AppleMusicSong> = new <AppleMusicSong>[];

		var songsArray:Array = JSON.parse(jsonString) as Array;
		for (var i:int = 0; i < songsArray.length; i++) {
			var songObject:Object = songsArray[i];
			result.push(new AppleMusicSong(songObject.song_id, songObject.song_name, songObject.album_name, songObject.artist_name, songObject.song_duration, AppleMusicSongType.fromValue(songObject.song_type), songObject.artwork_url, songObject.artwork_width, songObject.artwork_height));
		}

		return result;
	}

	/**
	 * Parse json song received from native implementation
	 * @param jsonString
	 * @return
	 */
	private function parseAppleMusicSongItemJSON(jsonString:String):AppleMusicSong {
		var songObject:Object = JSON.parse(jsonString);
		return new AppleMusicSong(songObject.song_id, songObject.song_name, songObject.album_name, songObject.artist_name, songObject.song_duration, AppleMusicSongType.fromValue(songObject.song_type), songObject.artwork_url, songObject.artwork_width, songObject.artwork_height);
	}

	}
}





