//
//  AudioUnitViewController.m
//  WaveSynthExtension
//
//  Created by Eric on 4/22/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "WaveSynthAUViewController.h"
#import "WaveSynthAU.h"

@interface WaveSynthAUViewController ()

@end

@implementation WaveSynthAUViewController
{
    AUAudioUnit *audioUnit;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if (!audioUnit)
    {
        return;
    }
    
    // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
}

- (AUAudioUnit *)createAudioUnitWithComponentDescription:(AudioComponentDescription)desc error:(NSError **)error {
    audioUnit = [[WaveSynthAU alloc] initWithComponentDescription:desc error:error];
    
    return audioUnit;
}

@end
