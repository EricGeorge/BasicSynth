//
//  SynthAUViewController.m
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthAUViewController.h"

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SynthAU.h"
#import "SynthConstants.h"

#import "DCAViewController.h"
#import "EnvelopeGeneratorViewController.h"

static NSArray *_waveformNames;

@interface SynthAUViewController ()
{
    IBOutlet UIButton *_waveformButton;
    IBOutlet UILabel *_waveformLabel;
    
    AUParameter *_waveformParameter;
    
    AUParameterObserverToken *_parameterObserverToken;
}

@property (nonatomic, strong) EnvelopeGeneratorViewController *envVC;
@property (nonatomic, strong) DCAViewController *dcaVC;

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
        _waveformParameter = [parameterTree valueForKey:waveformParamKey];

        [self.envVC registerParameters:parameterTree];
        [self.dcaVC registerParameters:parameterTree];
        
        _parameterObserverToken = [parameterTree tokenByAddingParameterObserver:^(AUParameterAddress address, AUValue value) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (address == _waveformParameter.address)
                {
                    [self updateWaveform];
                }
                
                [self.envVC updateParameter:address andValue:value];
                [self.dcaVC updateParameter:address andValue:value];
                
            });
        }];
        
        [self updateWaveform];
        
        [self.envVC updateAllParameters];
        [self.dcaVC updateAllParameters];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[_waveformButton layer] setBorderWidth:1.0f];
    [[_waveformButton layer] setBorderColor:[UIColor blackColor].CGColor];
    
    if (_audioUnit)
    {
        [self connectViewWithAU];
    }

    _waveformNames = @[@"Sine", @"Sawtooth", @"Square", @"Triangle"];
    
    OscillatorWave waveform = self.audioUnit.selectedWaveform;
    _waveformLabel.text = _waveformNames[waveform];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EnvVC"])
    {
        self.envVC = (EnvelopeGeneratorViewController *)segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"dcaVC"])
    {
        self.dcaVC = (DCAViewController *)segue.destinationViewController;
    }
}

- (void) updateWaveform
{
    OscillatorWave waveform = self.audioUnit.selectedWaveform;
    _waveformLabel.text = _waveformNames[waveform];
}

- (IBAction)waveformChanged:(id)sender
{
    OscillatorWave waveform = self.audioUnit.selectedWaveform;
    if (waveform == OSCILLATOR_WAVE_LAST)
    {
        waveform = OSCILLATOR_WAVE_FIRST;
    }
    else
    {
        ++waveform;
    }
    
    self.audioUnit.selectedWaveform = waveform;
    _waveformLabel.text = _waveformNames[waveform];
}

@end
