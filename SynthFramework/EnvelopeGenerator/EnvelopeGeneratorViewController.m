//
//  EnvelopeGeneratorViewController.m
//
//  Created by Eric on 5/6/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "EnvelopeGeneratorViewController.h"

@interface EnvelopeGeneratorViewController ()
@property (strong, nonatomic) IBOutlet UISlider *attackSlider;
@property (strong, nonatomic) IBOutlet UILabel *attackValue;
@property (strong, nonatomic) IBOutlet UISlider *decaySlider;
@property (strong, nonatomic) IBOutlet UILabel *decayValue;
@property (strong, nonatomic) IBOutlet UISlider *sustainSlider;
@property (strong, nonatomic) IBOutlet UILabel *sustainValue;
@property (strong, nonatomic) IBOutlet UISlider *releaseSlider;
@property (strong, nonatomic) IBOutlet UILabel *releaseValue;

@end

@implementation EnvelopeGeneratorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _attackValue.text = [NSString stringWithFormat:@"%d", (uint16_t)_attackSlider.value];
    _decayValue.text = [NSString stringWithFormat:@"%d", (uint16_t)_decaySlider.value];
    _sustainValue.text = [NSString stringWithFormat:@"%d%%", (uint16_t)_sustainSlider.value];
    _releaseValue.text = [NSString stringWithFormat:@"%d", (uint16_t)_releaseSlider.value];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)attackSliderChanged:(UISlider *)sender
{
    _attackValue.text = [NSString stringWithFormat:@"%d", (uint16_t)_attackSlider.value];
}

- (IBAction)decaySliderChanged:(UISlider *)sender
{
    _decayValue.text = [NSString stringWithFormat:@"%d", (uint16_t)_decaySlider.value];
}

- (IBAction)sustainSliderChanged:(UISlider *)sender
{
    _sustainValue.text = [NSString stringWithFormat:@"%d%%", (uint16_t)_sustainSlider.value];
}

- (IBAction)releaseSliderChanged:(UISlider *)sender
{
    _releaseValue.text = [NSString stringWithFormat:@"%d", (uint16_t)_releaseSlider.value];
}

@end
