package com.freshplanet.ane.AppleMusic.events {
public class AirAppleMusicErrorEvent extends AirAppleMusicEvent {

    static public const ERROR_REQUESTING_CLOUD_SERVICE_CAPABILITIES     :String = "AppleMusicErrorEvent_errorRequestingCloudServiceCapabilities";
    static public const ERROR_PRESENTING_TRIAL_DIALOG                   :String = "AppleMusicErrorEvent_errorPresentingTrialDialog";
    static public const ERROR_REQUESTING_STOREFRONT_COUNTRY_CODE        :String = "AppleMusicErrorEvent_errorRequestingStorefrontCountryCode";
    static public const ERROR_PERFORMING_STOREFRONTS_LOOKUP             :String = "AppleMusicErrorEvent_errorPerformingStorefrontsLookup";
    static public const ERROR_PERFORMING_APPLE_MUSIC_CATALOG_SEARCH     :String = "AppleMusicErrorEvent_errorPerformingAppleMusicCatalogSearch";
    static public const ERROR_ADDING_SONG_TO_PLAYLIST                   :String = "AppleMusicErrorEvent_errorAddingSongToPlaylist";

    private var _message:String;

    public function AirAppleMusicErrorEvent(type:String, message:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        _message = message;
    }

    public function get message():String {
        return _message;
    }
}
}
