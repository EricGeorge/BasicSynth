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
#import "EnvelopeGeneratorViewController.h"
#import "FilterViewController.h"

@interface SynthAUViewController ()
{
    AUParameterObserverToken *_parameterObserverToken;
}

@property (nonatomic, strong) DCAViewController *dcaVC;
@property (nonatomic, strong) OscillatorViewController *oscVC;
@property (nonatomic, strong) EnvelopeGeneratorViewController *envVC;
@property (nonatomic, strong) FilterViewController *filterVC;

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
        [self.envVC registerParameters:parameterTree];
        [self.filterVC registerParameters:parameterTree];
        
        _parameterObserverToken = [parameterTree tokenByAddingParameterObserver:^(AUParameterAddress address, AUValue value) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self.dcaVC updateParameter:address andValue:value];
                [self.oscVC updateParameter:address andValue:value];
                [self.envVC updateParameter:address andValue:value];
                [self.filterVC updateParameter:address andValue:value];
                
            });
        }];
        
        [self.oscVC updateAllParameters];
        [self.dcaVC updateAllParameters];
        [self.envVC updateAllParameters];
        [self.filterVC updateAllParameters];
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
    if ([segue.identifier isEqualToString:@"envVC"])
    {
        self.envVC = (EnvelopeGeneratorViewController *)segue.destinationViewController;
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
