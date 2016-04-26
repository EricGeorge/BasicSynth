/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	View controller for the InstrumentDemo audio unit. Manages the interactions between a InstrumentView and the audio unit's parameters.
 */

#ifndef WaveSynthAUViewController_h
#define WaveSynthAUViewController_h

#import <CoreAudioKit/AUViewController.h>

@class WaveSynthAU;

@interface WaveSynthAUViewController : AUViewController

@property (nonatomic)WaveSynthAU *audioUnit;

@end

#endif /* WaveSynthAUViewController_h */
