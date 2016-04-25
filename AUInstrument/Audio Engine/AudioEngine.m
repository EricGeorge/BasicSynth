//
//  AudioEngine.m
//  AUInstrument
//
//  Created by Eric on 4/19/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "AudioEngine.h"

@import AVFoundation;

#import "WaveSynthAU.h"

@interface AudioEngine()
{
    AVAudioEngine *_engine;
}

@end

@implementation AudioEngine

- (instancetype)init
{
    if (self = [super init])
    {
        [self initAVAudioSession];
        [self createSynthAU];
        [self createEngineAndAttachNodes];
        [self makeEngineConnections];
        [self startEngine];
    }
    return self;
}

- (void) createSynthAU
{
    AudioComponentDescription componentDescription;
    
    componentDescription.componentType = kAudioUnitType_MusicDevice;
    componentDescription.componentSubType = 0x77617665; /*'wave'*/
    componentDescription.componentManufacturer = 0x45454745; /*'EEGE'*/
    componentDescription.componentFlags = 0;
    componentDescription.componentFlagsMask = 0;
    
    [AUAudioUnit registerSubclass:WaveSynthAU.self asComponentDescription:componentDescription name:@"Local WaveSynth" version:1];
    
    [AVAudioUnit instantiateWithComponentDescription:componentDescription
                                             options:kAudioComponentInstantiation_LoadOutOfProcess
                                   completionHandler:^ (AVAudioUnit * __nullable audioUnit, NSError * __nullable error)
    {
        _synth = audioUnit;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:(NSString *)kAudioComponentInstanceInvalidationNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        AUAudioUnit *auAudioUnit = (AUAudioUnit *)note.object;
        NSValue *val = note.userInfo[@"audioUnit"];
        AudioUnit audioUnit = (AudioUnit)val.pointerValue;
        NSLog(@"Received kAudioComponentInstanceInvalidationNotification: auAudioUnit %@, audioUnit %p (Crash?)", auAudioUnit, audioUnit);
    }];
}


- (void)createEngineAndAttachNodes
{
    _engine = [[AVAudioEngine alloc] init];
     [_engine attachNode:_synth];
}

- (void)makeEngineConnections
{
    AVAudioFormat *hardwareFormat = [_engine.outputNode outputFormatForBus:0];
    AVAudioFormat *stereoFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:hardwareFormat.sampleRate channels:2];
    
    AVAudioMixerNode *mainMixer = [_engine mainMixerNode];
    AVAudioOutputNode *output = [_engine outputNode];

    [_engine connect:_synth to:mainMixer format:stereoFormat];
    [_engine connect:mainMixer to:output format:hardwareFormat];
}

- (void)startEngine
{
    if (!_engine.isRunning)
    {
        NSError *error;
        BOOL success;
        success = [_engine startAndReturnError:&error];
        NSAssert(success, @"couldn't start engine, %@", [error localizedDescription]);
    }
}


- (void)initAVAudioSession
{
    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
    NSError *error;
    
    bool success = [sessionInstance setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (!success) NSLog(@"Error setting AVAudioSession category! %@\n", [error localizedDescription]);
    
    success = [sessionInstance setActive:YES error:&error];
    if (!success) NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
}

@end
