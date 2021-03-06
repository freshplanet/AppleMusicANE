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

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FPANEUtilsAM.h"
#import "Constants.h"


@interface AppleMusic : NSObject {
    FREContext _context;
    NSString* _developerToken;
    SKCloudServiceController* _cloudServiceController;
    SKCloudServiceCapability _cloudServiceCapabilities;
    NSString* _cloudServiceStorefrontCountryCode;
    NSArray<MPMediaItem *>* _currentMediaLibrarySongs;
    MPMusicPlayerController* _musicPlayerController;
    
}

@end

void AppleMusicContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void AppleMusicContextFinalizer(FREContext ctx);
void AppleMusicInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void AppleMusicFinalizer(void *extData);
