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
    IBOutlet UISlider *volumeSlider;
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

-(void)connectViewWithAU
{
//    AUParameterTree *paramTree = _audioUnit.parameterTree;
//
//    if (paramTree)
//    {
//        attackParameter = [paramTree valueForKey: @"attack"];
//        releaseParameter = [paramTree valueForKey: @"release"];
//
//        __weak InstrumentDemoViewController *weakSelf = self;
//        __weak AUParameter *weakAttackParameter = attackParameter;
//        __weak AUParameter *weakReleaseParameter = releaseParameter;
//        parameterObserverToken = [paramTree tokenByAddingParameterObserver:^(AUParameterAddress address, AUValue value) {
//            __strong InstrumentDemoViewController *strongSelf = weakSelf;
//            __strong AUParameter *strongAttackParameter = weakAttackParameter;
//            __strong AUParameter *strongReleaseParameter = weakReleaseParameter;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (address == strongAttackParameter.address) {
//                    [strongSelf updateAttack];
//                } else if (address == strongReleaseParameter.address) {
//                    [strongSelf updateRelease];
//                }
//            });
//        }];
//        
//        [self updateAttack];
//        [self updateRelease];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_audioUnit)
    {
        [self connectViewWithAU];
    }
}

- (IBAction)volumeChanged:(UISlider *)sender
{
    NSLog(@"Volume changed: %f", sender.value);
}
@end
