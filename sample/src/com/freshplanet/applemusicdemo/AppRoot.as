/**
 * Created by mateo on 22/06/2017.
 */


package com.freshplanet.applemusicdemo {
import com.freshplanet.ane.AppleMusic.AirAppleMusic;
import com.freshplanet.ane.AppleMusic.VOs.AirAppleMusicPlaylist;
import com.freshplanet.ane.AppleMusic.VOs.AirAppleMusicSong;
import com.freshplanet.ane.AppleMusic.enums.AirAppleMusicCloudServiceCapabilities;
import com.freshplanet.ane.AppleMusic.enums.AirAppleMusicPlaybackState;
import com.freshplanet.ane.AppleMusic.events.AirAppleMusicAuthorizationEvent;
import com.freshplanet.ane.AppleMusic.events.AirAppleMusicCatalogSearchEvent;
import com.freshplanet.ane.AppleMusic.events.AirAppleMusicCloudServiceEvent;
import com.freshplanet.ane.AppleMusic.events.AirAppleMusicErrorEvent;
import com.freshplanet.ane.AppleMusic.events.AirAppleMusicEvent;

import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.themes.TopcoatLightMobileTheme;
import starling.display.Quad;
import starling.events.Event;

public class AppRoot extends LayoutGroup {

	private var _uiView:UIView;
	private var _searchOffset:int = 0;
	private var _searchLimit:int = 10;

	public function AppRoot() {
		super();
		new TopcoatLightMobileTheme();
	}

	override protected function initialize():void {
		super.initialize();


		this.layout = new AnchorLayout();
		this.backgroundSkin = new Quad(1,1, 0x37547d);
		var layoutData:AnchorLayoutData;

		layoutData = new AnchorLayoutData();
		layoutData.top = 0;
		layoutData.left = 0;
		layoutData.right = 0;
		layoutData.bottom = 0;

		_uiView = new UIView();
		_uiView.layoutData = layoutData;
		addChild(_uiView);

		_uiView.addEventListener(UIView.CHECK_MEDIA_LIBRARY_AUTHORIZATION, onActionTriggered);
		_uiView.addEventListener(UIView.CHECK_CLOUD_SERVICE_AUTHORIZATION, onActionTriggered);
		_uiView.addEventListener(UIView.REQUEST_AUTHORIZATION, onActionTriggered);
		_uiView.addEventListener(UIView.PLAY_MEDIA_LIBRARY_SONGS, onActionTriggered);
		_uiView.addEventListener(UIView.TOGGLE_PLAY_PAUSE, onActionTriggered);
		_uiView.addEventListener(UIView.SKIP, onActionTriggered);
		_uiView.addEventListener(UIView.STOP, onActionTriggered);
		_uiView.addEventListener(UIView.SKIP_TO_BEGINNING, onActionTriggered);
		_uiView.addEventListener(UIView.SKIP_TO_PREVIOUS, onActionTriggered);
		_uiView.addEventListener(UIView.CURRENT_PLAYBACK_STATE, onActionTriggered);
		_uiView.addEventListener(UIView.NOW_PLAYING_ITEM, onActionTriggered);
		_uiView.addEventListener(UIView.SEARCH, onActionTriggered);
		_uiView.addEventListener(UIView.PRESENT_TRIAL, onActionTriggered);
		_uiView.addEventListener(UIView.GET_PLAYLISTS, onActionTriggered);

		AirAppleMusic.logEnabled = true;
		AirAppleMusic.instance.initialize("eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlVXRTQ1REtXRjcifQ.eyJpc3MiOiIyRFFFMjQ1NUVQIiwiaWF0IjoxNTA1MjMyMjIwLCJleHAiOjE1MDUyNzU0MjB9.fYIJApiM8lu7v3n0O0mfnG5Pdhvh3qF3HcIMS2LwaubJuzg79dBODcBTyj_kz-Jg4xudbIT-d839BHqZaApvBg");
		AirAppleMusic.instance.addEventListener(AirAppleMusicAuthorizationEvent.AUTHORIZATION_DID_UPDATE, onAuthorizationDidUpdate);
		AirAppleMusic.instance.addEventListener(AirAppleMusicCloudServiceEvent.CLOUD_SERVICE_DID_UPDATE, onCloudServiceDidUpdate);
		AirAppleMusic.instance.addEventListener(AirAppleMusicEvent.MUSIC_PLAYER_DID_UPDATE_STATE, onMusicPlayerDidUpdateState);
		AirAppleMusic.instance.addEventListener(AirAppleMusicEvent.SUBSCRIPTION_TRIAL_NOT_ELIGIBLE, onSubscriptionTrialNotEligible);
		AirAppleMusic.instance.addEventListener(AirAppleMusicEvent.DID_DISMISS_SUBSCRIPTION_TRIAL_DIALOG, onDidDismissSubscriptionTrialDialog);
		AirAppleMusic.instance.addEventListener(AirAppleMusicCatalogSearchEvent.RECEIVED_SEARCH_RESULTS, onReceivedAppleMusicSearchResults);
		AirAppleMusic.instance.addEventListener(AirAppleMusicErrorEvent.ERROR_REQUESTING_STOREFRONT_COUNTRY_CODE, onErrorEvent);
		AirAppleMusic.instance.addEventListener(AirAppleMusicErrorEvent.ERROR_REQUESTING_CLOUD_SERVICE_CAPABILITIES, onErrorEvent);
		AirAppleMusic.instance.addEventListener(AirAppleMusicErrorEvent.ERROR_PRESENTING_TRIAL_DIALOG, onErrorEvent);
		AirAppleMusic.instance.addEventListener(AirAppleMusicErrorEvent.ERROR_PERFORMING_STOREFRONTS_LOOKUP, onErrorEvent);
		AirAppleMusic.instance.addEventListener(AirAppleMusicErrorEvent.ERROR_PERFORMING_APPLE_MUSIC_CATALOG_SEARCH, onErrorEvent);
		AirAppleMusic.instance.addEventListener(AirAppleMusicErrorEvent.ERROR_ADDING_SONG_TO_PLAYLIST, onErrorEvent);

	}

    private function onErrorEvent(event:AirAppleMusicErrorEvent):void {
		trace("Error occurred with type: ", event.type, " and message: ", event.message);

        trace("CLOUD CAPABILITIES :" , AirAppleMusic.instance.cloudServiceCapabilities);
    }

	private function onSubscriptionTrialNotEligible(event:AirAppleMusicEvent):void {
		trace("onSubscriptionTrialNotEligible");
	}

	private function onDidDismissSubscriptionTrialDialog(event:AirAppleMusicEvent):void {
		trace("onDidDismissSubscriptionTrialDialog");
	}

	var searchSongs:Vector.<com.freshplanet.ane.AppleMusic.VOs.AirAppleMusicSong>;
    var playlists:Vector.<com.freshplanet.ane.AppleMusic.VOs.AirAppleMusicPlaylist>;

	private function onReceivedAppleMusicSearchResults(event:AirAppleMusicCatalogSearchEvent):void {
		trace("GOT SEARCH RESULTS ", event.results.length);
        searchSongs = event.results;

		var playlist:AirAppleMusicPlaylist = playlists[0];
		var song:AirAppleMusicSong = searchSongs[0];
		trace("Adding song : ", song.songName, " to playlist ", playlist.name);
		trace("dasdas");
//		AirAppleMusic.instance.playSongs(new <AirAppleMusicSong>[song]);
		AirAppleMusic.instance.addSongToPlaylist(playlist, song);
//		AirAppleMusic.instance.playSongs(event.results);
	}

	private function onMusicPlayerDidUpdateState(event:AirAppleMusicEvent):void {
		trace("MUSIC PLAYER DID UPDATE STATE");
		// check playing status, now playing item
	}

	private function onCloudServiceDidUpdate(event:AirAppleMusicCloudServiceEvent):void {
		var capabilities : uint = AirAppleMusic.instance.cloudServiceCapabilities;
		if (capabilities & AirAppleMusicCloudServiceCapabilities.None)
		{
			trace("Cloud service did update AppleMusicCloudServiceCapabilities.None");
		}
		if (capabilities & AirAppleMusicCloudServiceCapabilities.AddToCloudMusicLibrary)
		{
			trace("Cloud service did update AppleMusicCloudServiceCapabilities.AddToCloudMusicLibrary");
		}
		if (capabilities & AirAppleMusicCloudServiceCapabilities.MusicCatalogPlayback)
		{
			trace("Cloud service did update AppleMusicCloudServiceCapabilities.MusicCatalogPlayback");
		}
		if (capabilities & AirAppleMusicCloudServiceCapabilities.MusicCatalogSubscriptionEligible)
		{
			trace("Cloud service did update AppleMusicCloudServiceCapabilities.MusicCatalogSubscriptionEligible");
		}

		var storefrontCountryCode:String = AirAppleMusic.instance.cloudServiceStorefrontCountryCode;
		trace("storefrontCountryCode ", storefrontCountryCode);
	}

	private function onAuthorizationDidUpdate(event:AirAppleMusicAuthorizationEvent):void {
		trace("Authorization did update :: type: ", event.authorizationType.value, " status: ", event.authorizationStatus.value);

	}

	private function onActionTriggered(event:Event):void {

		var actionID:String = event.type;
		switch (actionID) {
			case UIView.CHECK_MEDIA_LIBRARY_AUTHORIZATION:
				trace("CHECK_MEDIA_LIBRARY_AUTHORIZATION: ", AirAppleMusic.instance.mediaLibraryAuthorizationStatus.value);
				break;
			case UIView.CHECK_CLOUD_SERVICE_AUTHORIZATION:
				trace("CHECK_CLOUD_SERVICE_AUTHORIZATION: ", AirAppleMusic.instance.cloudServiceAuthorizationStatus.value);
				break;
			case UIView.REQUEST_AUTHORIZATION:
                AirAppleMusic.instance.requestAuthorization();
				break;
			case UIView.PLAY_MEDIA_LIBRARY_SONGS:
				var songs:Vector.<AirAppleMusicSong> = AirAppleMusic.instance.getMediaLibrarySongs();
                AirAppleMusic.instance.playSongs(songs);
				break;
			case UIView.TOGGLE_PLAY_PAUSE:
                AirAppleMusic.instance.togglePlayPause;
				break;
			case UIView.SKIP:
                AirAppleMusic.instance.skipToNextSong();
				break;
			case UIView.STOP:
                AirAppleMusic.instance.stopPlayback();
				break;
			case UIView.SKIP_TO_BEGINNING:
                AirAppleMusic.instance.skipToSongBeginning();
				break;
			case UIView.SKIP_TO_PREVIOUS:
                AirAppleMusic.instance.skipToPreviousSong();
				break;
			case UIView.NOW_PLAYING_ITEM:
				var song:AirAppleMusicSong = AirAppleMusic.instance.nowPlayingItem;
				trace("NOW PLAYING SONG : ", song != null ? song.songName : "null");
				trace("NOW PLAYING SONG TYPE : ", song != null ? song.type.value : "null");
				break;
			case UIView.CURRENT_PLAYBACK_STATE:
				var state:AirAppleMusicPlaybackState = AirAppleMusic.instance.playbackState;
				trace("CURRENT_PLAYBACK_STATE : ", state.value);
				break;
			case UIView.SEARCH:
                AirAppleMusic.instance.performAppleMusicCatalogSearch("vaya con dios",_searchLimit,_searchOffset);
				_searchOffset += _searchLimit;
				break;
			case UIView.PRESENT_TRIAL:
                AirAppleMusic.instance.presentTrialDialogIfEligible();
				break;
            case UIView.GET_PLAYLISTS:

                playlists = AirAppleMusic.instance.getMediaLibraryPlaylists();
                trace("playlists");
                break;
			default:
				break;

		}

	}


}
}
