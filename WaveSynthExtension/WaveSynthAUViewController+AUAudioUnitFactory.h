/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	`InstrumentDemoViewController` is the app extension's principal class, responsible for creating both the audio unit and its view.
 */

#ifndef WaveSynthAUViewController_AUAudioUnitFactory_h
#define WaveSynthAUViewController_AUAudioUnitFactory_h

@import CoreAudioKit;
#import <WaveSynthFramework/WaveSynthFramework.h>

@interface WaveSynthAUViewController (AUAudioUnitFactory) <AUAudioUnitFactory>

@end

#endif /* WaveSynthAUViewController_AUAudioUnitFactory_h */
