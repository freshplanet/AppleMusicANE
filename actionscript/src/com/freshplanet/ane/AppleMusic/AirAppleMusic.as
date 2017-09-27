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
import com.freshplanet.ane.AppleMusic.VOs.AirAppleMusicPlaylist;
import com.freshplanet.ane.AppleMusic.VOs.AirAppleMusicSong;
import com.freshplanet.ane.AppleMusic.enums.AirAppleMusicAuthorizationStatus;
import com.freshplanet.ane.AppleMusic.enums.AirAppleMusicAuthorizationType;
import com.freshplanet.ane.AppleMusic.enums.AirAppleMusicPlaybackState;
import com.freshplanet.ane.AppleMusic.enums.AirAppleMusicSongType;
import com.freshplanet.ane.AppleMusic.events.AirAppleMusicAuthorizationEvent;
import com.freshplanet.ane.AppleMusic.events.AirAppleMusicCloudServiceEvent;
import com.freshplanet.ane.AppleMusic.events.AirAppleMusicErrorEvent;
import com.freshplanet.ane.AppleMusic.events.AirAppleMusicEvent;
import com.freshplanet.ane.AppleMusic.events.AirAppleMusicCatalogSearchEvent;
import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.system.Capabilities;

public class AirAppleMusic extends EventDispatcher {

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
        return  isIOS && instance.isIOSVersionAtLeast103;
	}

	public function get isIOSVersionAtLeast103():Boolean {
		return _extContext.call("isSupported");
	}

	/**
	 * Is the ANE supported on the current platform
	 */
	public function get nativeLogger():INativeLogger {
        return _logger;
    }

    /**
     * AirAppleMusic instance
     */
    static public function get instance():AirAppleMusic {
		return _instance != null ? _instance : new AirAppleMusic()
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
	public function get mediaLibraryAuthorizationStatus():AirAppleMusicAuthorizationStatus {
		var statusRaw:String = _extContext.call("mediaLibraryAuthorizationStatus") as String;
		return AirAppleMusicAuthorizationStatus.fromValue(statusRaw);
	}

	/**
	 * Get current Cloud Service authorization status
	 */
	public function get cloudServiceAuthorizationStatus():AirAppleMusicAuthorizationStatus {
		var statusRaw:String = _extContext.call("cloudServiceAuthorizationStatus") as String;
		return AirAppleMusicAuthorizationStatus.fromValue(statusRaw);
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
	 * Request Cloud Service capabilities from service
	 */
	public function requestCloudServiceCapabilities():void {
		_extContext.call("requestCloudServiceCapabilities");
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
	public function getMediaLibrarySongs():Vector.<AirAppleMusicSong> {
		var itemsString:String = _extContext.call("getMediaLibrarySongs") as String;
		var mediaLibrarySongs:Vector.<AirAppleMusicSong> = parseAppleMusicSongItemsArrayJSON(itemsString);

		for (var i:int = 0; i < mediaLibrarySongs.length; i++) {
			var song:AirAppleMusicSong = mediaLibrarySongs[i];
			song.artwork = _extContext.call("getMediaLibrarySongArtwork", song.id) as BitmapData;

		}

		return mediaLibrarySongs;
	}

    /**
	 * Get playlists from Media Library
     */
    public function getMediaLibraryPlaylists():Vector.<AirAppleMusicPlaylist> {
        var itemsString:String = _extContext.call("getMediaLibraryPlaylists") as String;
        var mediaLibraryPlaylists:Vector.<AirAppleMusicPlaylist> = parsePlaylistsItemsArrayJSON(itemsString);
		return mediaLibraryPlaylists;
    }

    /**
     * Add song to playlist
     */
    public function addSongToPlaylist(playlist:AirAppleMusicPlaylist, song:AirAppleMusicSong):void {
        _extContext.call("addToPlaylist", playlist.id, song.id, song.type.value);
    }

	/**
	 * Get playlists from Media Library
	 */
	public function addSongToPlaylistById(playlistId:String, songId:String, songType:AirAppleMusicSongType):void {
		_extContext.call("addToPlaylist", playlistId, songId, songType.value);
	}

	/**
	 * Play songs. Songs must be previously aquired through <code>getMediaLibrarySongs</code> or <code>performAppleMusicCatalogSearch</code>
	 */
	public function playSongs(songs:Vector.<AirAppleMusicSong>):void {
		if(songs == null)
			return;
		var songIDsArray:Array = [];
		for (var i:int = 0; i < songs.length; i++) {
			var song:AirAppleMusicSong = songs[i];
			songIDsArray.push(song.id);
		}
		_extContext.call("playSongs", songIDsArray);
	}

	/**
	 * Play Apple Music API songs by id
	 */
	public function playSongsByProductId(songIDs:Array):void {
		if(songIDs == null)
			return;
		_extContext.call("playSongsByProductId", songIDs);
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
	public function get playbackState():AirAppleMusicPlaybackState {
		var playbackStateRaw:String = _extContext.call("playbackState") as String;
		return AirAppleMusicPlaybackState.fromValue(playbackStateRaw);
	}

	/**
	 * Get item currently playing in music player
	 */
	public function get nowPlayingItem():AirAppleMusicSong {
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

    /**
     * Open Apple Music app
     */
    public function openAppleMusic():void {
        _extContext.call("openAppleMusicApp");
    }

    /**
     * Open application Music Settings
     */
    public function openMusicSettings():void {
        _extContext.call("openAppleMusicSettings");
    }

	// --------------------------------------------------------------------------------------//
	//																						 //
	// 									 	PRIVATE API										 //
	// 																						 //
	// --------------------------------------------------------------------------------------//

	static private const EXTENSION_ID:String = "com.freshplanet.ane.AirAppleMusic";
	static private var _instance:AirAppleMusic = null;

	private var _extContext:ExtensionContext = null;
	private var _logger:INativeLogger;

	/**
	 * "private" singleton constructor
	 */
	public function AirAppleMusic() {

		super();

		if (_instance)
			throw new Error("singleton class, use .instance");

		_extContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
		_extContext.addEventListener(StatusEvent.STATUS, _handleStatusEvent);

		if (isIOS)
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
        else if (event.code == AirAppleMusicAuthorizationEvent.AUTHORIZATION_DID_UPDATE)
        {

	        var authorizationType:AirAppleMusicAuthorizationType = null;
	        var authorizationStatus:AirAppleMusicAuthorizationStatus = null;
	        try {
	            var authorizationData : Object = JSON.parse(event.level);
	            authorizationType = AirAppleMusicAuthorizationType.fromValue(authorizationData.type);
	            authorizationStatus= AirAppleMusicAuthorizationStatus.fromValue(authorizationData.status);
	        }
	        catch (e:Error) {
	            _log(e.message);
	        }

	        this.dispatchEvent(new AirAppleMusicAuthorizationEvent(AirAppleMusicAuthorizationEvent.AUTHORIZATION_DID_UPDATE, authorizationType, authorizationStatus));
        }
        else if (event.code == AirAppleMusicCloudServiceEvent.CLOUD_SERVICE_DID_UPDATE)
        {
	        this.dispatchEvent(new AirAppleMusicCloudServiceEvent(AirAppleMusicCloudServiceEvent.CLOUD_SERVICE_DID_UPDATE));
        }
        else if (event.code == AirAppleMusicEvent.MUSIC_PLAYER_DID_UPDATE_STATE || event.code == AirAppleMusicEvent.SUBSCRIPTION_TRIAL_NOT_ELIGIBLE || event.code == AirAppleMusicEvent.DID_DISMISS_SUBSCRIPTION_TRIAL_DIALOG)
        {
	        this.dispatchEvent(new AirAppleMusicEvent(event.code));
        }
        else if (event.code == AirAppleMusicCatalogSearchEvent.RECEIVED_SEARCH_RESULTS)
        {
	        var resultsString:String = event.level;
	        var searchResults:Vector.<AirAppleMusicSong> = parseAppleMusicSongItemsArrayJSON(resultsString);
	        this.dispatchEvent(new AirAppleMusicCatalogSearchEvent(AirAppleMusicCatalogSearchEvent.RECEIVED_SEARCH_RESULTS, searchResults));
        }
        else if (
				event.code == AirAppleMusicErrorEvent.ERROR_PERFORMING_APPLE_MUSIC_CATALOG_SEARCH ||
				event.code == AirAppleMusicErrorEvent.ERROR_PERFORMING_STOREFRONTS_LOOKUP ||
				event.code == AirAppleMusicErrorEvent.ERROR_PRESENTING_TRIAL_DIALOG ||
				event.code == AirAppleMusicErrorEvent.ERROR_REQUESTING_CLOUD_SERVICE_CAPABILITIES ||
				event.code == AirAppleMusicErrorEvent.ERROR_ADDING_SONG_TO_PLAYLIST ||
				event.code == AirAppleMusicErrorEvent.ERROR_REQUESTING_STOREFRONT_COUNTRY_CODE
		)
            this.dispatchEvent(new AirAppleMusicErrorEvent(event.code, event.level));
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

	private static function get isIOS():Boolean {
		return Capabilities.manufacturer.indexOf("iOS") > -1;
	}

	/**
	 * Parse json song results array received from native implementation
	 * @param jsonString
	 * @return
	 */
	private function parseAppleMusicSongItemsArrayJSON(jsonString:String):Vector.<AirAppleMusicSong> {
        if(!jsonString)
            return null;
		var result:Vector.<AirAppleMusicSong> = new <AirAppleMusicSong>[];
		var songsArray:Array = JSON.parse(jsonString) as Array;
		for (var i:int = 0; i < songsArray.length; i++) {
			var songObject:Object = songsArray[i];
			result.push(new AirAppleMusicSong(songObject.song_id, songObject.song_name, songObject.album_name, songObject.artist_name, songObject.song_duration, AirAppleMusicSongType.fromValue(songObject.song_type), songObject.artwork_url, songObject.artwork_width, songObject.artwork_height));
		}

		return result;
	}

    /**
     * Parse json playlist results array received from native implementation
     * @param jsonString
     * @return
     */
    private function parsePlaylistsItemsArrayJSON(jsonString:String):Vector.<AirAppleMusicPlaylist> {
        if(!jsonString)
			return null;
		var result:Vector.<AirAppleMusicPlaylist> = new <AirAppleMusicPlaylist>[];
        var playlistsArray:Array = JSON.parse(jsonString) as Array;
        for (var i:int = 0; i < playlistsArray.length; i++) {
            var playlistObject:Object = playlistsArray[i];
            result.push(new AirAppleMusicPlaylist(playlistObject.playlist_id, playlistObject.playlist_name));
        }

        return result;
    }

	/**
	 * Parse json song received from native implementation
	 * @param jsonString
	 * @return
	 */
	private function parseAppleMusicSongItemJSON(jsonString:String):AirAppleMusicSong {
        if(!jsonString)
            return null;
		var songObject:Object = JSON.parse(jsonString);
		return new AirAppleMusicSong(songObject.song_id, songObject.song_name, songObject.album_name, songObject.artist_name, songObject.song_duration, AirAppleMusicSongType.fromValue(songObject.song_type), songObject.artwork_url, songObject.artwork_width, songObject.artwork_height);
	}

	}
}





