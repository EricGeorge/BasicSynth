//
//  SynthProc.cpp
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthProc.hpp"

#import "MIDIEvent.h"
#import "Parameters.h"
#import "SynthConstants.h"
#import "Utility.hpp"
#import "Voices.h"

SynthProc::SynthProc()
{
    outBufferListPtr = nullptr;
}

void SynthProc::init(int channelCount, double inSampleRate)
{
    [Parameters sharedParameters].sampleRate = inSampleRate;
    
    voices = [[Voices alloc] init];
}

void SynthProc::reset()
{
    // this currently does nothing
}

void SynthProc::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration)
{
    [[Parameters sharedParameters] setParameter:address withValue:value];
}

void SynthProc::setBuffers(AudioBufferList* outBufferList)
{
    outBufferListPtr = outBufferList;
}

void SynthProc::handleMIDIEvent(AUMIDIEvent const& midiEvent)
{
    MIDIEvent *event = [[MIDIEvent alloc] initWithAUMidiEvent:&midiEvent];
    
    switch (event.message)
    {
        default:
//            NSLog(@"Instrument received unhandled MIDI event");
            break;
        case MIDIMessageType_NoteOff:
            [voices stop:event.data1];
            break;
        case MIDIMessageType_NoteOn:
             [voices start:event.data1 withVelocity:event.data2];
            break;
    }
}

void SynthProc::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset)
{
    float* left = (float*)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float* right = (float*)outBufferListPtr->mBuffers[1].mData + bufferOffset;

    double outL = 0.0;
    double outR = 0.0;

    for (AUAudioFrameCount i = 0; i < frameCount; ++i)
    {
        outL = 0.0;
        outR = 0.0;

        [voices nextSample:&outL andRight:&outR];
        
        // update the buffer
        left[i] = outL;
        right[i] = outR;
    }
}
