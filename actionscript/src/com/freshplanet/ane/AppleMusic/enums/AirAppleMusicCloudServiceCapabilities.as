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
package com.freshplanet.ane.AppleMusic.enums {
public class AirAppleMusicCloudServiceCapabilities {

	/**
	 * No capabilities or undetermined
	 */
	public static const None                             :uint = 0;
	/**
	 * The device allows playback of Apple Music catalog tracks.
	 */
	public static const MusicCatalogPlayback             :uint = 1 << 0;
	/**
	 * The device allows subscription to the Apple Music catalog.
	 */
	public static const MusicCatalogSubscriptionEligible :uint = 1 << 1;
	/**
	 * The device allows tracks to be added to the user’s music library.
	 */
	public static const AddToCloudMusicLibrary           :uint = 1 << 8;
}
}
