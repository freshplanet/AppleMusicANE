/**
 * Created by Mateo Kozomara (mateo.kozomara@gmail.com) on 22/06/2017.
 */
package com.freshplanet.ane.AppleMusic.enums {
public class AppleMusicCloudServiceCapabilities {

	public static const None                             :uint = 0;
	public static const MusicCatalogPlayback             :uint = 1 << 0;
	public static const MusicCatalogSubscriptionEligible :uint = 1 << 1;
	public static const AddToCloudMusicLibrary           :uint = 1 << 8;
}
}
