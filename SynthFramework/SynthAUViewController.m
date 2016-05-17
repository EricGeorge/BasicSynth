//
//  SynthAUViewController.m
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthAUViewController.h"

#import <UIKit/UIKit.h>

#import "SynthAU.h"
#import "SynthConstants.h"

#import "OscillatorViewController.h"
#import "DCAViewController.h"
#import "AmpEnvelopeViewController.h"
#import "FilterViewController.h"
#import "FilterEnvelopeViewController.h"

@interface SynthAUViewController ()
{
    AUParameterObserverToken *_parameterObserverToken;
}

@property (nonatomic, strong) DCAViewController *dcaVC;
@property (nonatomic, strong) OscillatorViewController *oscVC;
@property (nonatomic, strong) AmpEnvelopeViewController *ampEnvVC;
@property (nonatomic, strong) FilterViewController *filterVC;
@property (nonatomic, strong) FilterEnvelopeViewController *filterEnvVC;

@end

@implementation SynthAUViewController

-(void)setAudioUnit:(SynthAU *)audioUnit
{
    _audioUnit = audioUnit;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isViewLoaded]) {
            [self connectViewWithAU];
        }
    });
}

-(SynthAU *)getAudioUnit
{
    return _audioUnit;
}

- (void) connectViewWithAU
{
    AUParameterTree *parameterTree = self.audioUnit.parameterTree;
    
    if (parameterTree)
    {
        [self.oscVC registerParameters:parameterTree];
        [self.dcaVC registerParameters:parameterTree];
        [self.ampEnvVC registerParameters:parameterTree];
        [self.filterVC registerParameters:parameterTree];
        [self.filterEnvVC registerParameters:parameterTree];
        
        _parameterObserverToken = [parameterTree tokenByAddingParameterObserver:^(AUParameterAddress address, AUValue value) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self.dcaVC updateParameter:address andValue:value];
                [self.oscVC updateParameter:address andValue:value];
                [self.ampEnvVC updateParameter:address andValue:value];
                [self.filterVC updateParameter:address andValue:value];
                [self.filterEnvVC updateParameter:address andValue:value];
                
            });
        }];
        
        [self.oscVC updateAllParameters];
        [self.dcaVC updateAllParameters];
        [self.ampEnvVC updateAllParameters];
        [self.filterVC updateAllParameters];
        [self.filterEnvVC updateAllParameters];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_audioUnit)
    {
        [self connectViewWithAU];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"filterEnvVC"])
    {
        self.filterEnvVC = (FilterEnvelopeViewController *)segue.destinationViewController;
    }
    if ([segue.identifier isEqualToString:@"ampEnvVC"])
    {
        self.ampEnvVC = (AmpEnvelopeViewController *)segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"dcaVC"])
    {
        self.dcaVC = (DCAViewController *)segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"oscVC"])
    {
        self.oscVC = (OscillatorViewController *)segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"filterVC"])
    {
        self.filterVC = (FilterViewController *)segue.destinationViewController;
    }
}

@end
