//
//  MainViewController.m
//  AUInstrument
//
//  Created by Eric on 4/18/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "MainViewController.h"

@import AudioUnit;
#import <WaveSynthFramework/WaveSynthFramework.h>

#import "AudioEngine.h"
#import "MIDILogs.h"
#import "MIDIManager.h"

@interface MainViewController ()
{
    AudioEngine *_engine;
}

@property (strong, nonatomic) IBOutlet UIView *auContainerView;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MIDIManager *midiManager = MIDIManager.sharedMIDIManager;
    
    midiManager.delegate = self;
    
    _engine = [[AudioEngine alloc] init];
    
    [self embedPlugInView];
}

- (void) embedPlugInView
{
    NSURL *builtInPlugInsURL = [[NSBundle mainBundle] builtInPlugInsURL];
    NSURL *pluginURL = [builtInPlugInsURL URLByAppendingPathComponent:(@"WaveSynthExtension.appex")];
    NSBundle *appExtensionBundle = [[NSBundle alloc] initWithURL:pluginURL];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainInterface" bundle:appExtensionBundle];
    
    WaveSynthAUViewController *waveSynthViewController = [storyboard instantiateInitialViewController];
    
    UIView *view = waveSynthViewController.view;
    if (view)
    {
        [self addChildViewController:waveSynthViewController];
        view.frame = self.auContainerView.bounds;
        
        [self.auContainerView addSubview:view];
        [waveSynthViewController didMoveToParentViewController:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleMidiEvent:(uint8_t)status
             withChannel:(uint8_t)channel
               withData1:(uint8_t)data1
               withData2:(uint8_t)data2
          withStartFrame:(uint64_t)startFrame
{
    // Call MusicDeviceMIDIEvent on the AU from here
    MusicDeviceMIDIEvent(_engine.synth.audioUnit,
                         status,
                         data1,
                         data2,
                         0);
}

@end
