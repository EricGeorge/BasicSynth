/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	`InstrumentDemoViewController` is the app extension's principal class, responsible for creating both the audio unit and its view.
 */

#import "WaveSynthAUViewController+AUAudioUnitFactory.h"

@implementation WaveSynthAUViewController (AUAudioUnitFactory)

- (WaveSynthAU *) createAudioUnitWithComponentDescription:(AudioComponentDescription) desc error:(NSError **)error
{
    self.audioUnit = [[WaveSynthAU alloc] initWithComponentDescription:desc error:error];
    return self.audioUnit;
}

@end
