/**
 * Created by mateo on 22/06/2017.
 */


package com.freshplanet.applemusicdemo {
import com.freshplanet.ane.AppleMusic.AppleMusic;
import com.freshplanet.ane.AppleMusic.VOs.AppleMusicSong;
import com.freshplanet.ane.AppleMusic.enums.AppleMusicAuthorizationStatus;
import com.freshplanet.ane.AppleMusic.enums.AppleMusicAuthorizationType;
import com.freshplanet.ane.AppleMusic.enums.AppleMusicCloudServiceCapabilities;
import com.freshplanet.ane.AppleMusic.enums.AppleMusicPlaybackState;
import com.freshplanet.ane.AppleMusic.events.AppleMusicAuthorizationEvent;
import com.freshplanet.ane.AppleMusic.events.AppleMusicCatalogSearchEvent;
import com.freshplanet.ane.AppleMusic.events.AppleMusicCloudServiceEvent;
import com.freshplanet.ane.AppleMusic.events.AppleMusicEvent;

import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.themes.TopcoatLightMobileTheme;

import flash.display.Bitmap;

import flash.display.BitmapData;

import flash.events.StatusEvent;
import flash.sampler.StackFrame;

import starling.core.Starling;

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

		AppleMusic.instance.initialize("eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkZHWTlWODNGV00ifQ.eyJpc3MiOiIyRFFFMjQ1NUVQIiwiaWF0IjoxNDk4Mzk4OTAzLCJleHAiOjE0OTg0NDIxMDN9.j-7eTCXbdEuYZa2DKsz7Ux_MbvQsCDgI9pb_zHPAEFugW83kpYDMzMGU1agKm0C7N5aH8CCxgY8dKVfuYBZUXQ");
		AppleMusic.instance.addEventListener(AppleMusicAuthorizationEvent.AUTHORIZATION_DID_UPDATE, onAuthorizationDidUpdate);
		AppleMusic.instance.addEventListener(AppleMusicCloudServiceEvent.CLOUD_SERVICE_DID_UPDATE, onCloudServiceDidUpdate);
		AppleMusic.instance.addEventListener(AppleMusicEvent.MUSIC_PLAYER_DID_UPDATE_STATE, onMusicPlayerDidUpdateState);
		AppleMusic.instance.addEventListener(AppleMusicEvent.SUBSCRIPTION_TRIAL_NOT_ELIGIBLE, onSubscriptionTrialNotEligible);
		AppleMusic.instance.addEventListener(AppleMusicEvent.DID_DISMISS_SUBSCRIPTION_TRIAL_DIALOG, onDidDismissSubscriptionTrialDialog);
		AppleMusic.instance.addEventListener(AppleMusicCatalogSearchEvent.RECEIVED_SEARCH_RESULTS, onReceivedAppleMusicSearchResults);

	}

	private function onSubscriptionTrialNotEligible(event:AppleMusicEvent):void {
		trace("onSubscriptionTrialNotEligible");
	}

	private function onDidDismissSubscriptionTrialDialog(event:AppleMusicEvent):void {
		trace("onDidDismissSubscriptionTrialDialog");
	}

	private function onReceivedAppleMusicSearchResults(event:AppleMusicCatalogSearchEvent):void {
		trace("GOT SEARCH RESULTS ", event.results.length);
		AppleMusic.instance.playSongs(event.results);
	}

	private function onMusicPlayerDidUpdateState(event:AppleMusicEvent):void {
		trace("MUSIC PLAYER DID UPDATE STATE");
		// check playing status, now playing item
	}

	private function onCloudServiceDidUpdate(event:AppleMusicCloudServiceEvent):void {
		var capabilities : uint = AppleMusic.instance.cloudServiceCapabilities;
		if (capabilities & AppleMusicCloudServiceCapabilities.None)
		{
			trace("Cloud service did update AppleMusicCloudServiceCapabilities.None");
		}
		if (capabilities & AppleMusicCloudServiceCapabilities.AddToCloudMusicLibrary)
		{
			trace("Cloud service did update AppleMusicCloudServiceCapabilities.AddToCloudMusicLibrary");
		}
		if (capabilities & AppleMusicCloudServiceCapabilities.MusicCatalogPlayback)
		{
			trace("Cloud service did update AppleMusicCloudServiceCapabilities.MusicCatalogPlayback");
		}
		if (capabilities & AppleMusicCloudServiceCapabilities.MusicCatalogSubscriptionEligible)
		{
			trace("Cloud service did update AppleMusicCloudServiceCapabilities.MusicCatalogSubscriptionEligible");
		}

		var storefrontCountryCode:String = AppleMusic.instance.cloudServiceStorefrontCountryCode;
		trace("storefrontCountryCode ", storefrontCountryCode);
	}

	private function onAuthorizationDidUpdate(event:AppleMusicAuthorizationEvent):void {
		trace("Authorization did update :: type: ", event.authorizationType.value, " status: ", event.authorizationStatus.value);

	}

	private function onActionTriggered(event:Event):void {

		var actionID:String = event.type;
		switch (actionID) {
			case UIView.CHECK_MEDIA_LIBRARY_AUTHORIZATION:
				trace("CHECK_MEDIA_LIBRARY_AUTHORIZATION: ", AppleMusic.instance.mediaLibraryAuthorizationStatus.value);
				break;
			case UIView.CHECK_CLOUD_SERVICE_AUTHORIZATION:
				trace("CHECK_CLOUD_SERVICE_AUTHORIZATION: ", AppleMusic.instance.cloudServiceAuthorizationStatus.value);
				break;
			case UIView.REQUEST_AUTHORIZATION:
				AppleMusic.instance.requestAuthorization();
				break;
			case UIView.PLAY_MEDIA_LIBRARY_SONGS:
				var songs:Vector.<AppleMusicSong> = AppleMusic.instance.getMediaLibrarySongs();
				AppleMusic.instance.playSongs(songs);
				break;
			case UIView.TOGGLE_PLAY_PAUSE:
				AppleMusic.instance.togglePlayPause();
				break;
			case UIView.SKIP:
				AppleMusic.instance.skipToNextSong();
				break;
			case UIView.STOP:
				AppleMusic.instance.stopPlayback();
				break;
			case UIView.SKIP_TO_BEGINNING:
				AppleMusic.instance.skipToSongBeginning();
				break;
			case UIView.SKIP_TO_PREVIOUS:
				AppleMusic.instance.skipToPreviousSong();
				break;
			case UIView.NOW_PLAYING_ITEM:
				var song:AppleMusicSong = AppleMusic.instance.nowPlayingItem;
				trace("NOW PLAYING SONG : ", song != null ? song.songName : "null");
				trace("NOW PLAYING SONG TYPE : ", song != null ? song.type.value : "null");
				break;
			case UIView.CURRENT_PLAYBACK_STATE:
				var state:AppleMusicPlaybackState = AppleMusic.instance.playbackState;
				trace("CURRENT_PLAYBACK_STATE : ", state.value);
				break;
			case UIView.SEARCH:
				AppleMusic.instance.performAppleMusicCatalogSearch("vaya con dios",_searchLimit,_searchOffset);
				_searchOffset += _searchLimit;
				break;
			case UIView.PRESENT_TRIAL:
				AppleMusic.instance.presentTrialDialogIfEligible();
				break;
			default:
				break;

		}

	}


}
}
