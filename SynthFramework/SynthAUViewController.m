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

#import "EnvelopeGeneratorViewController.h"

static NSArray *_waveformNames;

@interface SynthAUViewController ()
{
    IBOutlet UISlider *_volumeSlider;
    IBOutlet UILabel *_volumeValue;
    IBOutlet UISlider *_panSlider;
    IBOutlet UILabel *_panValue;
    IBOutlet UIButton *_waveformButton;
    IBOutlet UILabel *_waveformLabel;
    
    AUParameter *_waveformParameter;
    AUParameter *_volumeParameter;
    AUParameter *_panParameter;
    AUParameter *_attackParameter;
    AUParameter *_decayParameter;
    AUParameter *_sustainParameter;
    AUParameter *_releaseParameter;
    
    AUParameterObserverToken *_parameterObserverToken;
}

@property (nonatomic, weak) EnvelopeGeneratorViewController *envVC;

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
        _waveformParameter = [parameterTree valueForKey:@"waveform"];

        _volumeParameter = [parameterTree valueForKey:@"volume"];
        _panParameter = [parameterTree valueForKey:@"pan"];
        
        _attackParameter = [parameterTree valueForKey:@"attack"];
        _decayParameter = [parameterTree valueForKey:@"decay"];
        _sustainParameter = [parameterTree valueForKey:@"sustain"];
        _releaseParameter = [parameterTree valueForKey:@"release"];
        
        _parameterObserverToken = [parameterTree tokenByAddingParameterObserver:^(AUParameterAddress address, AUValue value) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (address == _waveformParameter.address)
                {
                    [self updateWaveform];
                }
                if (address == _volumeParameter.address)
                {
                    [self updateVolume];
                }
                else if (address == _panParameter.address)
                {
                    [self updatePan];
                }
                else if (address == _attackParameter.address)
                {
                    [self updateAttack];
                }
                else if (address == _decayParameter.address)
                {
                    [self updateDecay];
                }
                else if (address == _sustainParameter.address)
                {
                    [self updateSustain];
                }
                else if (address == _releaseParameter.address)
                {
                    [self updateRelease];
                }
                
            });
        }];
        
        [self updateWaveform];
        [self updateVolume];
        [self updatePan];
        [self updateAttack];
        [self updateDecay];
        [self updateSustain];
        [self updateRelease];
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
        self.envVC.parentVC = self;
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

- (void) updateVolume
{
    _volumeSlider.value = _volumeParameter.value;
    _volumeValue.text = [NSString stringWithFormat:@"%d%%", (uint8_t)_volumeSlider.value];
}

- (IBAction)volumeChanged:(UISlider *)sender
{
    _volumeParameter.value =  sender.value;
    _volumeValue.text = [NSString stringWithFormat:@"%d%%", (uint8_t)_volumeSlider.value];
}

- (void) updatePan
{
    _panSlider.value = _panParameter.value;
    _panValue.text = [NSString stringWithFormat:@"%.2f", _panSlider.value];
}

- (IBAction)panChanged:(UISlider *)sender
{
    _panParameter.value = sender.value;
    _panValue.text = [NSString stringWithFormat:@"%.2f", _panSlider.value];
}

- (void) updateAttack
{
    [self.envVC updateAttack:_attackParameter.value];
}

- (void) attackChanged:(double)value
{
    _attackParameter.value = value;
}

- (void) updateDecay
{
    [self.envVC updateDecay:_decayParameter.value];
}

- (void) decayChanged:(double)value
{
    _decayParameter.value = value;
}

- (void) updateSustain
{
    [self.envVC updateSustain:_sustainParameter.value];
}

- (void) sustainChanged:(double)value
{
    _sustainParameter.value = value;
}

- (void) updateRelease
{
    [self.envVC updateRelease:_releaseParameter.value];
}

- (void) releaseChanged:(double)value
{
    _releaseParameter.value = value;
}

@end
