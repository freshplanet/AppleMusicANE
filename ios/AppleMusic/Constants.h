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

#ifndef Constants_h
#define Constants_h


#endif /* Constants_h */
static NSString *const kAppleMusicAPIBaseURLString = @"api.music.apple.com";


/* COMMON EVENTS */
static NSString *const kAuthorizationEvent_AUTHORIZATION_DID_UPDATE = @"AppleMusicAuthorizationEvent_authorizationDidUpdate";
static NSString *const kCloudServiceEvent_CLOUD_SERVICE_DID_UPDATE  = @"AppleMusicCloudServiceEvent_cloudServiceDidUpdate";
static NSString *const kAppleMusicEvent_MUSIC_PLAYER_DID_UPDATE_STATE  = @"AppleMusicEvent_musicPlayerDidUpdateState";
static NSString *const kAppleMusicEvent_SUBSCRIPTION_TRIAL_NOT_ELIGIBLE  = @"AppleMusicEvent_subscriptionTrialNotEligible";
static NSString *const kAppleMusicEvent_DID_DISMISS_SUBSCRIPTION_TRIAL_DIALOG  = @"AppleMusicEvent_didDismissSubscriptionTrialDialog";
static NSString *const kAppleMusicSearchEvent_RECEIVED_SEARCH_RESULTS  = @"AppleMusicSearchEvent_receivedSearchResults";
static NSString *const kAirAppleMusicPlaylistEvent_PLAYLIST_DATA = @"AppleMusicPlaylistEvent_playlistData";
static NSString *const kAirAppleMusicEvent_ADDED_SONG_TO_PLAYLIST = @"AppleMusicEvent_addedSongToPlaylist";

static NSString *const kAirAppleMusicErrorEvent_ERROR_REQUESTING_CLOUD_SERVICE_CAPABILITIES = @"AppleMusicErrorEvent_errorRequestingCloudServiceCapabilities";
static NSString *const kAirAppleMusicErrorEvent_ERROR_PRESENTING_TRIAL_DIALOG = @"AppleMusicErrorEvent_errorPresentingTrialDialog";
static NSString *const kAirAppleMusicErrorEvent_ERROR_REQUESTING_STOREFRONT_COUNTRY_CODE = @"AppleMusicErrorEvent_errorRequestingStorefrontCountryCode";
static NSString *const kAirAppleMusicErrorEvent_ERROR_PERFORMING_STOREFRONTS_LOOKUP = @"AppleMusicErrorEvent_errorPerformingStorefrontsLookup";
static NSString *const kAirAppleMusicErrorEvent_ERROR_PERFORMING_APPLE_MUSIC_CATALOG_SEARCH = @"AppleMusicErrorEvent_errorPerformingAppleMusicCatalogSearch";
static NSString *const kAirAppleMusicErrorEvent_ERROR_ADDING_SONG_TO_PLAYLIST = @"AppleMusicErrorEvent_errorAddingSongToPlaylist";
static NSString *const kAirAppleMusicErrorEvent_ERROR_CREATE_PLAYLIST = @"AppleMusicErrorEvent_errorCreatePlaylist";


/* AUTHORIZATION TYPE */
static NSString *const kAuthorizationType_MEDIA_LIBRARY = @"media_library";
static NSString *const kAuthorizationType_CLOUD_SERVICE = @"cloud_service";

/* SONG TYPE */
static NSString *const kSongType_MEDIA_LIBRARY = @"media_library_song";
static NSString *const kSongType_APPLE_MUSIC_CATALOG = @"apple_music_catalog_song";

/* AUTHORISATION STATUS */
static NSString *const kAuthorizationStatus_AUTHORIZED = @"authorized";
static NSString *const kAuthorizationStatus_NOT_DETERMINED = @"not_determined";
static NSString *const kAuthorizationStatus_DENIED = @"denied";
static NSString *const kAuthorizationStatus_RESTRICTED = @"restricted";

/* PLAYBACK STATE */
static NSString *const kPlaybackState_PLAYING = @"playing";
static NSString *const kPlaybackState_STOPPED = @"stopped";
static NSString *const kPlaybackState_PAUSED = @"paused";
static NSString *const kPlaybackState_INTERRUPTED = @"interrupted";

/* DATA KEYS */
static NSString *const kSTATUS = @"status";
static NSString *const kTYPE = @"type";

static NSString *const kSONG_ID = @"song_id";
static NSString *const kSONG_TYPE = @"song_type";
static NSString *const kSONG_NAME = @"song_name";
static NSString *const kARTIST_NAME = @"artist_name";
static NSString *const kALBUM_NAME = @"album_name";
static NSString *const kSONG_DURATION = @"song_duration";
static NSString *const kSONG_URL = @"song_url";

static NSString *const kSONG_ARTWORK_WIDTH = @"artwork_width";
static NSString *const kSONG_ARTWORK_HEIGHT = @"artwork_height";
static NSString *const kSONG_ARTWORK_URL = @"artwork_url";

static NSString *const kPLAYLIST_ID = @"playlist_id";
static NSString *const kPLAYLIST_NAME = @"playlist_name";

