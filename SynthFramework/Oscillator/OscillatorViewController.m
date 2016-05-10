//
//  OscillatorViewController.m
//
//  Created by Eric on 5/9/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "OscillatorViewController.h"

#import "Oscillator.h"
#import "SynthConstants.h"

@interface OscillatorViewController ()
{
    AUParameter *_waveformParameter;
}

@property (strong, nonatomic) IBOutlet UIButton *waveformButton;
@property (strong, nonatomic) IBOutlet UILabel *waveformLabel;

@end

static NSArray *_waveformNames;

@implementation OscillatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[_waveformButton layer] setBorderWidth:1.0f];
    [[_waveformButton layer] setBorderColor:[UIColor blackColor].CGColor];
    
    _waveformNames = @[@"Sine", @"Sawtooth", @"Square", @"Triangle"];
    
    OscillatorWave waveform = _waveformParameter.value;
    _waveformLabel.text = _waveformNames[waveform];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateWaveform:(NSInteger)value
{
    OscillatorWave waveform = value;
    _waveformLabel.text = _waveformNames[waveform];
}

- (IBAction)waveformChanged:(id)sender
{
    OscillatorWave waveform = _waveformParameter.value;
    if (waveform == OscillatorWaveLast)
    {
        waveform = OscillatorWaveFirst;
    }
    else
    {
        ++waveform;
    }
    
    _waveformParameter.value = waveform;
    _waveformLabel.text = _waveformNames[waveform];
}


- (void) registerParameters:(AUParameterTree *)parameterTree
{
    _waveformParameter = [parameterTree valueForKey:waveformParamKey];
}

- (void) updateParameter:(AUParameterAddress)address andValue:(AUValue)value
{
    if (address == _waveformParameter.address)
    {
        [self updateWaveform:value];
    }
}

- (void) updateAllParameters
{
    [self updateWaveform:_waveformParameter.value];
}

@end
