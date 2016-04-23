//
//  MainViewController.m
//  AUInstrument
//
//  Created by Eric on 4/18/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "MainViewController.h"
#import "MIDIManager.h"
#import "MIDILogs.h"
#import "AudioEngine.h"
#import <AudioUnit/MusicDevice.h>

@interface MainViewController ()
{
    AudioEngine *_engine;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MIDIManager *midiManager = MIDIManager.sharedMIDIManager;
    
    midiManager.delegate = self;
    
    _engine = [[AudioEngine alloc] init];
}

- (void)didReceiveMemoryWarning {
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
    // for now - just send to console
//    LogMidiEventToConsole(status,
//                          channel,
//                          data1,
//                          data2,
//                          startFrame);
    
    MusicDeviceMIDIEvent(_engine.synth.audioUnit,
                         status,
                         data1,
                         data2,
                         0);

}

@end
