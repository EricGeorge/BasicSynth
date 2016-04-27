/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	View controller for the InstrumentDemo audio unit. Manages the interactions between a InstrumentView and the audio unit's parameters.
 */

#import <UIKit/UIKit.h>
#import "WaveSynthAUViewController.h"
#import <WaveSynthFramework/WaveSynthAU.h>

@interface WaveSynthAUViewController ()
{
    IBOutlet UISlider *_volumeSlider;
    AUParameter *_volumeParameter;
    AUParameterObserverToken *_parameterObserverToken;
}

@end

@implementation WaveSynthAUViewController

-(void)setAudioUnit:(WaveSynthAU *)audioUnit
{
    _audioUnit = audioUnit;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isViewLoaded]) {
            [self connectViewWithAU];
        }
    });
}

-(WaveSynthAU *)getAudioUnit
{
    return _audioUnit;
}

- (void) connectViewWithAU
{
    AUParameterTree *parameterTree = self.audioUnit.parameterTree;
    
    if (parameterTree)
    {
        _volumeParameter = [parameterTree valueForKey:@"volume"];
        
        _parameterObserverToken = [parameterTree tokenByAddingParameterObserver:^(AUParameterAddress address, AUValue value) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (address == _volumeParameter.address)
                {
                    [self updateVolume];
                }
                
            });
        }];
        
        [self updateVolume];
    }

    [self updateVolume];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_audioUnit)
    {
        [self connectViewWithAU];
    }
}

- (void) updateVolume
{
    NSLog(@"updateVolume: %@", [_volumeParameter stringFromValue:nil]);
    _volumeSlider.value = _volumeParameter.value;
}

- (IBAction)volumeChanged:(UISlider *)sender
{
    NSLog(@"volumeChanged: %f", sender.value);
    _volumeParameter.value =  sender.value;
}
@end
