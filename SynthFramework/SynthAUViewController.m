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

static NSArray *_waveformNames;

@interface SynthAUViewController ()
{
    IBOutlet UISlider *_volumeSlider;
    IBOutlet UISlider *_panSlider;
    IBOutlet UIButton *_waveformButton;
    IBOutlet UILabel *_waveformLabel;
    
    AUParameter *_volumeParameter;
    AUParameter *_panParameter;
    AUParameter *_waveformParameter;
    AUParameterObserverToken *_parameterObserverToken;
}

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
        _volumeParameter = [parameterTree valueForKey:@"volume"];
        _waveformParameter = [parameterTree valueForKey:@"waveform"];
        _panParameter = [parameterTree valueForKey:@"pan"];
        
        _parameterObserverToken = [parameterTree tokenByAddingParameterObserver:^(AUParameterAddress address, AUValue value) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (address == _volumeParameter.address)
                {
                    [self updateVolume];
                }
                else if (address == _panParameter.address)
                {
                    [self updatePan];
                }
                else if (address == _waveformParameter.address)
                {
                    [self updateWaveform];
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

- (void) updateVolume
{
    _volumeSlider.value = _volumeParameter.value;
}

- (IBAction)volumeChanged:(UISlider *)sender
{
    _volumeParameter.value =  sender.value;
}

- (void) updatePan
{
    _panSlider.value = _panParameter.value;
}

- (IBAction)panChanged:(UISlider *)sender
{
    _panParameter.value = sender.value;
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
