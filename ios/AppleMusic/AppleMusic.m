//
//  AppleMusic.m
//  AppleMusic
//
//  Created by Mateo Kozomara on 22/06/2017.
//  Copyright © 2017 Mateo Kozomara. All rights reserved.
//

#import "AppleMusic.h"

@implementation AppleMusic

- (id) initWithContext:(FREContext)extensionContext {
    
    if (self = [super init]) {
        
        _context = extensionContext;
        _cloudServiceController = [[SKCloudServiceController alloc] init];
        _cloudServiceCapabilities = SKCloudServiceCapabilityNone;
        _cloudServiceStorefrontCountryCode = @"";
        _musicPlayerController = [MPMusicPlayerController systemMusicPlayer];
        [_musicPlayerController beginGeneratingPlaybackNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMusicPlayerControllerNowPlayingItemDidChange)
                                                     name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMusicPlayerControllerPlaybackStateDidChange)
                                                     name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

-(void) dealloc {
    [_musicPlayerController endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) handleMusicPlayerControllerNowPlayingItemDidChange {
    [self sendEvent:kAppleMusicEvent_MUSIC_PLAYER_DID_UPDATE_STATE level:@""];
}

- (void) handleMusicPlayerControllerPlaybackStateDidChange {
    [self sendEvent:kAppleMusicEvent_MUSIC_PLAYER_DID_UPDATE_STATE level:@""];
}


- (void) sendLog:(NSString*)log {
    [self sendEvent:@"log" level:log];
}

- (void) sendEvent:(NSString*)code {
    [self sendEvent:code level:@""];
}

- (void) sendEvent:(NSString*)code level:(NSString*)level {
    FREDispatchStatusEventAsync(_context, (const uint8_t*)[code UTF8String], (const uint8_t*)[level UTF8String]);
}

- (void) requestCloudServiceCapabilities {
    [_cloudServiceController requestCapabilitiesWithCompletionHandler:^(SKCloudServiceCapability capabilities, NSError * _Nullable error) {
        if (error != nil) {
            [self sendLog:[@"Error occured while requesting cloud service capabilities:" stringByAppendingString:error.localizedDescription]];
            return;
        }
        
        _cloudServiceCapabilities = capabilities;
        [self sendEvent:kCloudServiceEvent_CLOUD_SERVICE_DID_UPDATE level:@""];
        
    }];
}

- (SKCloudServiceCapability) getCloudServiceCapabilities {
    return _cloudServiceCapabilities;
}

- (NSString*) getCloudServiceStorefrontCountryCode {
    return _cloudServiceStorefrontCountryCode;
}

- (void) setDeveloperToken : (NSString*) developerToken {
    _developerToken = developerToken;
}

- (void) setCurrentMediaLibrarySongs : (NSArray<MPMediaItem *>*) songs {
    _currentMediaLibrarySongs = songs;
}

- (BOOL) isMediaLibraryItem : (MPMediaItem*) song {
    if (_currentMediaLibrarySongs == nil) {
        return false;
    }
    return [_currentMediaLibrarySongs containsObject:song];
}

- (void) beginPlayback : (NSArray*) songIDs {
    
    if (songIDs.count == 0) {
        return;
    }
    
    NSArray *mediaItems = [_currentMediaLibrarySongs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        return [songIDs containsObject:[(NSNumber*)[(MPMediaItem*)object valueForProperty:MPMediaItemPropertyPersistentID] stringValue]];
    }]];
    
    if (mediaItems.count == 0) {
        // apple music catalog songs
        [_musicPlayerController setQueueWithStoreIDs:songIDs];
    }
    else {
        // media library songs
        [_musicPlayerController setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:mediaItems]];
    }
    
    [_musicPlayerController play];
    
}

- (void) togglePlayPause {
    if (_musicPlayerController.playbackState == MPMusicPlaybackStatePlaying) {
        [_musicPlayerController pause];
    } else {
        [_musicPlayerController play];
    }
}

- (void) skipToNextSong {
    [_musicPlayerController skipToNextItem];
}

- (void) skipToSongBeginning {
    [_musicPlayerController skipToBeginning];
}

- (void) skipToPreviousSong {
    [_musicPlayerController skipToPreviousItem];
}

- (void) stopPlayback {
    [_musicPlayerController stop];
}

- (MPMusicPlaybackState) getPlaybackState {
    return [_musicPlayerController playbackState];
}

- (MPMediaItem*) currentlyPlayingItem {
    return [_musicPlayerController nowPlayingItem];
}

- (MPMediaItem*) getMediaItem : (NSString*) songID {
    NSArray *mediaItems = [_currentMediaLibrarySongs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        return [songID isEqualToString:[(NSNumber*)[(MPMediaItem*)object valueForProperty:MPMediaItemPropertyPersistentID] stringValue]];
    }]];
    if (mediaItems.count == 0) {
        return nil;
    }
    return mediaItems.firstObject;
}

- (void) presentAppleMusicTrialDialogIfEligible:(NSString*)affiliateKey affiliateCampaignKey:(NSString*)affiliateCampaignKey {
    
    if ((_cloudServiceCapabilities & SKCloudServiceCapabilityMusicCatalogSubscriptionEligible) && !(_cloudServiceCapabilities & SKCloudServiceCapabilityMusicCatalogPlayback)) {
        // eligible
        NSMutableDictionary *optionKeys = [[NSMutableDictionary alloc] init]; 
        [optionKeys setValue:SKCloudServiceSetupActionSubscribe forKey:SKCloudServiceSetupOptionsActionKey];
        if (affiliateKey != nil && ![affiliateKey isEqualToString:@""]) {
            [self sendLog:@"setting SKCloudServiceSetupOptionsAffiliateTokenKey"];
            [optionKeys setValue:affiliateKey forKey:SKCloudServiceSetupOptionsAffiliateTokenKey];
        }
        if (affiliateCampaignKey != nil && ![affiliateCampaignKey isEqualToString:@""]) {
            [self sendLog:@"setting SKCloudServiceSetupOptionsCampaignTokenKey"];
            [optionKeys setValue:affiliateCampaignKey forKey:SKCloudServiceSetupOptionsCampaignTokenKey];
        }
        
        SKCloudServiceSetupViewController *setupController = [[SKCloudServiceSetupViewController alloc] init];
        [setupController loadWithOptions:optionKeys completionHandler:^(BOOL result, NSError * _Nullable error) {
            if (error != nil) {
                [self sendLog:[@"Error occured while trying to present trial dialog:" stringByAppendingString:error.localizedDescription]];
                return;
            }
            
            if (result) {
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:setupController animated:true completion:^{
                    [self sendEvent:kAppleMusicEvent_DID_DISMISS_SUBSCRIPTION_TRIAL_DIALOG];
                }];
            }
        }];
    }
    else {
        [self sendEvent:kAppleMusicEvent_SUBSCRIPTION_TRIAL_NOT_ELIGIBLE];
    }
    
    
    
}

- (void) requestStorefrontCountryCode {
    if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11,0,0}]) {
        
        [_cloudServiceController requestStorefrontCountryCodeWithCompletionHandler:^(NSString * _Nullable storefrontCountryCode, NSError * _Nullable error) {
            if (error != nil) {
                [self sendLog:[@"Error occured while requesting Storefront country code:" stringByAppendingString:error.localizedDescription]];
                return;
            }
            _cloudServiceStorefrontCountryCode = storefrontCountryCode;
            [self sendEvent:kCloudServiceEvent_CLOUD_SERVICE_DID_UPDATE level:@""];
            
        }];
    }
    else {
        
        NSLocale *currentLocale = [NSLocale currentLocale];
        NSString *countryCode = [[currentLocale objectForKey:NSLocaleCountryCode] lowercaseString];
        
        [self performAppleMusicStorefrontsLookup:countryCode ];
        
    }
    
}

- (void) performAppleMusicStorefrontsLookup:(NSString*) regionCode  {
    if (_developerToken == nil) {
        [self sendLog:@"Please set the developer token first"];
        return;
    }
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.scheme = @"https";
    urlComponents.host = kAppleMusicAPIBaseURLString;
    urlComponents.path = [NSString stringWithFormat: @"/v1/storefronts/%@", regionCode];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:urlComponents.URL];
    [request addValue:[NSString stringWithFormat: @"Bearer %@", _developerToken] forHTTPHeaderField:@"Authorization"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
          if (error != nil || httpResponse == nil || httpResponse.statusCode != 200 ) {
              [self sendLog:[@"Error occured while performing Apple Music Storefronts Lookup:" stringByAppendingString:(error != nil ? error.localizedDescription : [@"Http response error. Status code: " stringByAppendingString:[NSString stringWithFormat:@"%i", httpResponse.statusCode]])]];
              return;
          }
          
          NSError* jsonError;
          NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
          if (jsonError != nil) {
              return;
          }
          NSArray* jsonArray = jsonData[@"data"];
          NSDictionary* dataDictionary = jsonArray.firstObject;
          NSString* identifier = dataDictionary[@"id"];
          _cloudServiceStorefrontCountryCode = identifier;
          [self sendEvent:kCloudServiceEvent_CLOUD_SERVICE_DID_UPDATE level:@""];
          
      }] resume];
}

- (void) performAppleMusicCatalogSearch:(NSString*) searchTerm withLimit:(NSInteger)limit withOffset:(NSInteger)offset  {
    if (_developerToken == nil) {
        [self sendLog:@"Please set the developer token first"];
        return;
    }
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.scheme = @"https";
    urlComponents.host = kAppleMusicAPIBaseURLString;
    urlComponents.path = [NSString stringWithFormat: @"/v1/catalog/%@/search", _cloudServiceStorefrontCountryCode];
    
    NSString *expectedTerms = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSDictionary *queryDictionary = @{ @"term": expectedTerms, @"limit": [@(limit) stringValue], @"offset": [@(offset) stringValue], @"types": @"songs" };
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in queryDictionary) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryDictionary[key]]];
    }
    urlComponents.queryItems = queryItems;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:urlComponents.URL];
    [request addValue:[NSString stringWithFormat: @"Bearer %@", _developerToken] forHTTPHeaderField:@"Authorization"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
          if (error != nil || httpResponse == nil || httpResponse.statusCode != 200 ) {
              [self sendLog:[@"Error occured while performing Apple Music Catalog Search: " stringByAppendingString:(error != nil ? error.localizedDescription : [@"Http response error. Status code: " stringByAppendingString:[NSString stringWithFormat:@"%i", httpResponse.statusCode]])]];
              return;
          }
          
          NSError* jsonError;
          NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
          if (jsonError != nil) {
              return;
          }
          
          
          NSDictionary* resultsDictionary = jsonData[@"results"];
          NSDictionary* songsDictionary = resultsDictionary[@"songs"];
          NSArray* songsDataArray = songsDictionary[@"data"];
          
          NSMutableArray* resultsArray = [[NSMutableArray alloc] init];
          for (NSDictionary* songDictionary in songsDataArray) {
              
              NSDictionary* songAttributes = songDictionary[@"attributes"];
              NSMutableDictionary* parsedSong = [[NSMutableDictionary alloc] init];
              [parsedSong setValue:songDictionary[@"id"] forKey:kSONG_ID];
              [parsedSong setValue:songAttributes[@"name"] forKey:kSONG_NAME];
              [parsedSong setValue:@"" forKey:kALBUM_NAME];
              [parsedSong setValue:songAttributes[@"artistName"] forKey:kARTIST_NAME];
              [parsedSong setValue:kSongType_APPLE_MUSIC_CATALOG forKey:kSONG_TYPE];
              NSNumber* duration = songAttributes[@"durationInMillis"];
              [parsedSong setValue:@([duration floatValue]/1000.0) forKey:kSONG_DURATION];
              NSDictionary* artwork = songAttributes[@"artwork"];
              NSNumber* artworkWidth = artwork[@"width"];
              NSNumber* artworkHeight = artwork[@"height"];
              NSString* artworkURL = artwork[@"url"];
              artworkURL = [artworkURL stringByReplacingOccurrencesOfString:@"{w}" withString:[artworkWidth stringValue]];
              artworkURL = [artworkURL stringByReplacingOccurrencesOfString:@"{h}" withString:[artworkHeight stringValue]];
              
              [parsedSong setValue:artworkWidth forKey:kSONG_ARTWORK_WIDTH];
              [parsedSong setValue:artworkHeight forKey:kSONG_ARTWORK_HEIGHT];
              [parsedSong setValue:artworkURL forKey:kSONG_ARTWORK_URL];
              
              [resultsArray addObject:parsedSong];
              
          }
          
          NSData *resultData = [NSJSONSerialization dataWithJSONObject:resultsArray options:NSJSONWritingPrettyPrinted error:&error];
          NSString *resultJsonString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
          [self sendEvent:kAppleMusicSearchEvent_RECEIVED_SEARCH_RESULTS level:resultJsonString];
          
          
      }] resume];
}

@end

FREObject createBitmapData(uint32_t width, uint32_t height)
{
    FREObject widthObj;
    FRENewObjectFromInt32(width, &widthObj);
    FREObject heightObj;
    FRENewObjectFromInt32(height, &heightObj);
    FREObject transparent;
    FRENewObjectFromBool( 0, &transparent);
    FREObject fillColor;
    FRENewObjectFromUint32( 0x000000, &fillColor);
    
    FREObject params[4] = { widthObj, heightObj, transparent, fillColor };
    
    FREObject freBitmap;
    FRENewObject((uint8_t *)"flash.display.BitmapData", 4, params, &freBitmap , NULL);
    
    return freBitmap;
}
FREResult fillBitmapData(FREContext ctx, FREObject obj, UIImage *image)
{
    if(obj == NULL) {
        FREObject widthObj;
        FRENewObjectFromInt32(image.size.width, &widthObj);
        FREObject heightObj;
        FRENewObjectFromInt32(image.size.height, &heightObj);
        FREObject transparent;
        FRENewObjectFromBool( 0, &transparent);
        FREObject fillColor;
        FRENewObjectFromUint32( 0x000000, &fillColor);
        
        FREObject params[4] = { widthObj, heightObj, transparent, fillColor };
        
        FREObject freBitmap;
        FRENewObject((uint8_t *)"flash.display.BitmapData", 4, params, &freBitmap , NULL);
        obj = freBitmap;
    }
    
    
    FREResult result;
    FREBitmapData bitmapData;
    result = FREAcquireBitmapData(obj, &bitmapData);
    if (result != FRE_OK) {
        return result;
    }
    
    // Pull the raw pixels values out of the image data
    CGImageRef imageRef = [image CGImage];
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if(colorSpace == NULL) {
        return FRE_INVALID_OBJECT;
    }
    unsigned char *rawData = malloc(height * width * 4);
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * width;
    size_t bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    if(context == NULL) {
        return FRE_INVALID_OBJECT;
    }
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Pixels are now it rawData in the format RGBA8888
    // Now loop over each pixel to write them into the AS3 BitmapData memory
    int x, y;
    // There may be extra pixels in each row due to the value of lineStride32.
    // We'll skip over those as needed.
    int offset = bitmapData.lineStride32 - bitmapData.width;
    size_t offset2 = bytesPerRow - bitmapData.width*4;
    int byteIndex = 0;
    uint32_t *bitmapDataPixels = bitmapData.bits32;
    for (y=0; y<bitmapData.height; y++)
    {
        for (x=0; x<bitmapData.width; x++, bitmapDataPixels++, byteIndex += 4)
        {
            // Values are currently in RGBA7777, so each color value is currently a separate number.
            int red     = (rawData[byteIndex]);
            int green   = (rawData[byteIndex + 1]);
            int blue    = (rawData[byteIndex + 2]);
            int alpha   = (rawData[byteIndex + 3]);
            
            // Combine values into ARGB32
            *bitmapDataPixels = (alpha << 24) | (red << 16) | (green << 8) | blue;
        }
        
        bitmapDataPixels += offset;
        byteIndex += offset2;
    }
    
    // Free the memory we allocated
    free(rawData);
    // Tell Flash which region of the BitmapData changes (all of it here)
    result = FREInvalidateBitmapDataRect(obj, 0, 0, bitmapData.width, bitmapData.height);
    // Release our control over the BitmapData
    if(result == FRE_OK) {
        result = FREReleaseBitmapData(obj);
        if(result != FRE_OK) {
            return result;
        }
    } else {
        return result;
    }
    
    return result;
}




NSString* dictionaryToNSString(NSDictionary *dictionary){
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

NSString* arrayToNSString(NSArray *array){
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

NSDictionary* mediaItemToNSDictionary(MPMediaItem *mediaItem, NSString* songType) {
    
    NSString *artistName = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
    NSString *albumName = [mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString *songName = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *songId = [(NSNumber *)[mediaItem valueForProperty:MPMediaItemPropertyPersistentID] stringValue];
    NSNumber *duration = [mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] init];
    [itemDict setValue:artistName != nil ? artistName : @"" forKey:kARTIST_NAME];
    [itemDict setValue:albumName != nil ? albumName : @"" forKey:kALBUM_NAME];
    [itemDict setValue:songName != nil ? songName : @"" forKey:kSONG_NAME];
    [itemDict setValue:songId forKey:kSONG_ID];
    [itemDict setValue:songType forKey:kSONG_TYPE];
    [itemDict setValue:duration forKey:kSONG_DURATION];
    
    
    return itemDict;
}

NSString* mediaItemToJSONString(MPMediaItem *mediaItem, NSString* songType) {
    
    NSDictionary *itemDict = mediaItemToNSDictionary(mediaItem, songType);
    return dictionaryToNSString(itemDict);
}

NSString* mediaItemsToJSONString(NSArray *mediaItems) {
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    for (MPMediaItem *item in mediaItems)
    {
        NSDictionary *itemDict = mediaItemToNSDictionary(item, kSongType_MEDIA_LIBRARY);
        [result addObject:itemDict];
    }
    
    return arrayToNSString(result);
    
}

AppleMusic* GetAppleMusicContextNativeData(FREContext context) {
    
    CFTypeRef controller;
    FREGetContextNativeData(context, (void**)&controller);
    return (__bridge AppleMusic*)controller;
}

DEFINE_ANE_FUNCTION(initialize) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    @try {
        NSString* developerToken = FPANE_FREObjectToNSString(argv[0]);
        [controller setDeveloperToken:developerToken];
        if ([SKCloudServiceController authorizationStatus] == SKCloudServiceAuthorizationStatusAuthorized) {
            [controller requestStorefrontCountryCode];
            [controller requestCloudServiceCapabilities];
        }
        
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to set developer token : " stringByAppendingString:exception.reason]];
    }
    
    
    return nil;
}

DEFINE_ANE_FUNCTION(presentTrialDialogIfEligible) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    @try {
        NSString* affiliateKey = FPANE_FREObjectToNSString((argv[0]));
        NSString* affiliateCampaignKey = FPANE_FREObjectToNSString((argv[1]));
        [controller presentAppleMusicTrialDialogIfEligible:affiliateKey affiliateCampaignKey:affiliateCampaignKey];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to present Trial Dialog : " stringByAppendingString:exception.reason]];
    }
    
    return nil;
}

DEFINE_ANE_FUNCTION(mediaLibraryAuthorizationStatus) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    NSString* status;
    switch ([MPMediaLibrary authorizationStatus]) {
        case MPMediaLibraryAuthorizationStatusAuthorized:
            status = kAuthorizationStatus_AUTHORIZED;
            break;
        case MPMediaLibraryAuthorizationStatusDenied:
            status = kAuthorizationStatus_DENIED;
            break;
        case MPMediaLibraryAuthorizationStatusRestricted:
            status = kAuthorizationStatus_RESTRICTED;
            break;
        default:
            status = kAuthorizationStatus_NOT_DETERMINED;
            break;
    }
    return FPANE_NSStringToFREObject(status);
}

DEFINE_ANE_FUNCTION(cloudServiceAuthorizationStatus) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    NSString* status;
    switch ([SKCloudServiceController authorizationStatus] ) {
        case SKCloudServiceAuthorizationStatusAuthorized:
            status = kAuthorizationStatus_AUTHORIZED;
            break;
        case SKCloudServiceAuthorizationStatusDenied:
            status = kAuthorizationStatus_DENIED;
            break;
        case SKCloudServiceAuthorizationStatusRestricted:
            status = kAuthorizationStatus_RESTRICTED;
            break;
        default:
            status = kAuthorizationStatus_NOT_DETERMINED;
            break;
    }
    return FPANE_NSStringToFREObject(status);
}

DEFINE_ANE_FUNCTION(requestAuthorization) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    NSString *appleMusicUsageDiscription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSAppleMusicUsageDescription"];
    
    if (appleMusicUsageDiscription == nil) {
        [controller sendLog:@"NSAppleMusicUsageDescription is required in your application descriptor iOS InfoAdditions"];
        return nil;
    }
    
    if ([SKCloudServiceController authorizationStatus] != SKCloudServiceAuthorizationStatusNotDetermined) {
        [controller sendLog:@"An application should only ever call `SKCloudServiceController.requestAuthorization(_:)` when their current authorization is 'SKCloudServiceAuthorizationStatusNotDetermined'"];
    }
    else {
        [SKCloudServiceController requestAuthorization:^(SKCloudServiceAuthorizationStatus status) {
            switch (status) {
                case SKCloudServiceAuthorizationStatusAuthorized:
                    [controller sendEvent:kAuthorizationEvent_AUTHORIZATION_DID_UPDATE level:dictionaryToNSString([NSDictionary dictionaryWithObjectsAndKeys:kAuthorizationStatus_AUTHORIZED, kSTATUS, kAuthorizationType_CLOUD_SERVICE, kTYPE, nil])];
                    [controller requestCloudServiceCapabilities];
                    [controller requestStorefrontCountryCode];
                    break;
                case SKCloudServiceAuthorizationStatusDenied:
                    [controller sendEvent:kAuthorizationEvent_AUTHORIZATION_DID_UPDATE level:dictionaryToNSString([NSDictionary dictionaryWithObjectsAndKeys:kAuthorizationStatus_DENIED, kSTATUS, kAuthorizationType_CLOUD_SERVICE, kTYPE, nil])];
                    break;
                case SKCloudServiceAuthorizationStatusRestricted:
                    [controller sendEvent:kAuthorizationEvent_AUTHORIZATION_DID_UPDATE level:dictionaryToNSString([NSDictionary dictionaryWithObjectsAndKeys:kAuthorizationStatus_RESTRICTED, kSTATUS, kAuthorizationType_CLOUD_SERVICE, kTYPE, nil])];
                    break;
                default:
                    break;
            }
        }];
    }
    
    
    if ([MPMediaLibrary authorizationStatus] != MPMediaLibraryAuthorizationStatusNotDetermined) {
        [controller sendLog:@"An application should only ever call `MPMediaLibrary.requestAuthorization(_:)` when their current authorization is 'MPMediaLibraryAuthorizationStatusNotDetermined'"];
    }
    else {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            switch (status) {
                case MPMediaLibraryAuthorizationStatusAuthorized:
                    [controller sendEvent:kAuthorizationEvent_AUTHORIZATION_DID_UPDATE level:dictionaryToNSString([NSDictionary dictionaryWithObjectsAndKeys:kAuthorizationStatus_AUTHORIZED, kSTATUS, kAuthorizationType_MEDIA_LIBRARY, kTYPE, nil])];
                    break;
                case MPMediaLibraryAuthorizationStatusDenied:
                    [controller sendEvent:kAuthorizationEvent_AUTHORIZATION_DID_UPDATE level:dictionaryToNSString([NSDictionary dictionaryWithObjectsAndKeys:kAuthorizationStatus_DENIED, kSTATUS, kAuthorizationType_MEDIA_LIBRARY, kTYPE, nil])];
                    break;
                case MPMediaLibraryAuthorizationStatusRestricted:
                    [controller sendEvent:kAuthorizationEvent_AUTHORIZATION_DID_UPDATE level:dictionaryToNSString([NSDictionary dictionaryWithObjectsAndKeys:kAuthorizationStatus_RESTRICTED, kSTATUS, kAuthorizationType_MEDIA_LIBRARY, kTYPE, nil])];
                    break;
                default:
                    break;
            }
        }];
    }
    
    
    return nil;
}

DEFINE_ANE_FUNCTION(cloudServiceCapabilities) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    SKCloudServiceCapability capabilities = [controller getCloudServiceCapabilities];
    return FPANE_UIntToFREObject(capabilities);
}

DEFINE_ANE_FUNCTION(cloudServiceStorefrontCountryCode) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    NSString* countryCode = [controller getCloudServiceStorefrontCountryCode];
    return FPANE_NSStringToFREObject(countryCode);
}

DEFINE_ANE_FUNCTION(getMediaLibrarySongs) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    if ([MPMediaLibrary authorizationStatus] != MPMediaLibraryAuthorizationStatusAuthorized) {
        [controller sendLog:@"MediaLibrary permission is not authorized"];
        return nil;
    }
    
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    NSArray *items = [query items];
    [controller setCurrentMediaLibrarySongs:items];
    NSString *itemsJSONString = mediaItemsToJSONString(items);
    return FPANE_NSStringToFREObject(itemsJSONString);
}

DEFINE_ANE_FUNCTION(playSongs) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    if ([MPMediaLibrary authorizationStatus] != MPMediaLibraryAuthorizationStatusAuthorized) {
        [controller sendLog:@"MediaLibrary permission is not authorized"];
        return nil;
    }
    
    @try {
        NSArray* mediaLibrarySongIDs = FPANE_FREObjectToNSArrayOfNSString((argv[0]));
        [controller beginPlayback:mediaLibrarySongIDs];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to play media library songs : " stringByAppendingString:exception.reason]];
    }
    
    return nil;
}

DEFINE_ANE_FUNCTION(togglePlayPause) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    [controller togglePlayPause];
    
    return nil;
}

DEFINE_ANE_FUNCTION(skipToNextSong) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    [controller skipToNextSong];
    
    return nil;
}

DEFINE_ANE_FUNCTION(skipToPreviousSong) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    [controller skipToPreviousSong];
    
    return nil;
}

DEFINE_ANE_FUNCTION(skipToSongBeginning) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    [controller skipToSongBeginning];
    
    return nil;
}

DEFINE_ANE_FUNCTION(stopPlayback) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    [controller stopPlayback];
    
    return nil;
}

DEFINE_ANE_FUNCTION(playbackState) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    NSString *parsedState = @"";
    MPMusicPlaybackState state = [controller getPlaybackState];
    switch (state) {
        case MPMusicPlaybackStatePlaying:
            parsedState = kPlaybackState_PLAYING;
            break;
        case MPMusicPlaybackStateStopped:
            parsedState = kPlaybackState_STOPPED;
            break;
        case MPMusicPlaybackStatePaused:
            parsedState = kPlaybackState_PAUSED;
            break;
        case MPMusicPlaybackStateInterrupted:
            parsedState = kPlaybackState_INTERRUPTED;
            break;
        default:
            break;
    }
    return FPANE_NSStringToFREObject(parsedState);
}

DEFINE_ANE_FUNCTION(nowPlayingItem) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    NSString *itemJSONString;
    MPMediaItem *item = [controller currentlyPlayingItem];
    BOOL isMediaLibrarySong = [controller isMediaLibraryItem:item];
    NSString *songType = isMediaLibrarySong ? kSongType_MEDIA_LIBRARY : kSongType_APPLE_MUSIC_CATALOG;
    if (item != nil) {
        itemJSONString = mediaItemToJSONString(item, songType);
    }
    return itemJSONString != nil ? FPANE_NSStringToFREObject(itemJSONString) : nil;
    
}

DEFINE_ANE_FUNCTION(performAppleMusicCatalogSearch) {
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    @try {
        NSString* searchText = FPANE_FREObjectToNSString(argv[0]);
        NSInteger limit = FPANE_FREObjectToInt(argv[1]);
        NSInteger offset = FPANE_FREObjectToInt(argv[2]);
        
        [controller performAppleMusicCatalogSearch:searchText withLimit:limit withOffset:offset];
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to perform apple music catalog search : " stringByAppendingString:exception.reason]];
    }
    
    return nil;
    
}

DEFINE_ANE_FUNCTION(getMediaLibrarySongArtwork) {
    
    AppleMusic* controller = GetAppleMusicContextNativeData(context);
    if (!controller)
        return FPANE_CreateError(@"context's AppleMusic is null", 0);
    
    
    @try {
        NSString *mediaLibrarySongID = FPANE_FREObjectToNSString((argv[0]));
        MPMediaItem *mediaItem = [controller getMediaItem:mediaLibrarySongID];
        MPMediaItemArtwork *itemArtwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *artworkUIImage = [itemArtwork imageWithSize:CGSizeMake(500, 500)];
        if(artworkUIImage == nil) {
            return nil;
        }
        FREObject newBitmap = createBitmapData(artworkUIImage.size.width, artworkUIImage.size.height);
        if(newBitmap == nil) {
            return nil;
        }
        
        if(fillBitmapData(context, newBitmap, artworkUIImage) != FRE_OK) {
            return newBitmap;
        }
        
        return newBitmap;
    }
    @catch (NSException *exception) {
        FPANE_CreateError([@"Exception occured while trying to fetch artwork" stringByAppendingString:exception.reason], 0);
        
    }
    
    return nil;
    
}

void AppleMusicContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    AppleMusic* controller = [[AppleMusic alloc] initWithContext:ctx];
    FRESetContextNativeData(ctx, (void*)CFBridgingRetain(controller));
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(initialize, NULL),
        MAP_FUNCTION(presentTrialDialogIfEligible, NULL),
        MAP_FUNCTION(mediaLibraryAuthorizationStatus, NULL),
        MAP_FUNCTION(cloudServiceAuthorizationStatus, NULL),
        MAP_FUNCTION(requestAuthorization, NULL),
        MAP_FUNCTION(cloudServiceCapabilities, NULL),
        MAP_FUNCTION(cloudServiceStorefrontCountryCode, NULL),
        MAP_FUNCTION(getMediaLibrarySongs, NULL),
        MAP_FUNCTION(playSongs, NULL),
        MAP_FUNCTION(togglePlayPause, NULL),
        MAP_FUNCTION(skipToNextSong, NULL),
        MAP_FUNCTION(skipToPreviousSong, NULL),
        MAP_FUNCTION(skipToSongBeginning, NULL),
        MAP_FUNCTION(stopPlayback, NULL),
        MAP_FUNCTION(playbackState, NULL),
        MAP_FUNCTION(nowPlayingItem, NULL),
        MAP_FUNCTION(performAppleMusicCatalogSearch, NULL),
        MAP_FUNCTION(getMediaLibrarySongArtwork, NULL)
        
        
    };
    
    *numFunctionsToTest = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;
}

void AppleMusicContextFinalizer(FREContext ctx) {
    
    CFTypeRef controller;
    FREGetContextNativeData(ctx, (void**)&controller);
    CFBridgingRelease(controller);
}

void AppleMusicInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AppleMusicContextInitializer;
    *ctxFinalizerToSet = &AppleMusicContextFinalizer;
}

void AppleMusicFinalizer(void *extData) {
    
}
