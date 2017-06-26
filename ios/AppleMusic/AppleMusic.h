//
//  AppleMusic.h
//  AppleMusic
//
//  Created by Mateo Kozomara on 22/06/2017.
//  Copyright © 2017 Mateo Kozomara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FPANEUtils.h"
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
