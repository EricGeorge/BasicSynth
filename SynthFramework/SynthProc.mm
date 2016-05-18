//
//  SynthProc.cpp
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthProc.hpp"

#import "MIDIEvent.h"
#import "SynthConstants.h"
#import "Utility.hpp"
#import "Voice.h"

SynthProc::SynthProc()
{
    sampleRate = 44100.0;
    outBufferListPtr = nullptr;
}

void SynthProc::init(int channelCount, double inSampleRate)
{
    sampleRate = float(inSampleRate);
    
    voice = [[Voice alloc] init];
    voice.sampleRate = sampleRate;
}

void SynthProc::reset()
{
    // this currently does nothing
}

void SynthProc::setParameter(AUParameterAddress address, AUValue value)
{
    [voice setParameter:address withValue:value];
}

AUValue SynthProc::getParameter(AUParameterAddress address)
{
    return [voice getParameter:address];
}

void SynthProc::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration)
{
    setParameter(address, value);
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
            [voice stop];
            break;
        case MIDIMessageType_NoteOn:
             [voice start:event.data1 withVelocity:event.data2];
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

        [voice nextSample:&outL andRight:&outR];
        
        // update the buffer
        left[i] = outL;
        right[i] = outR;
    }
}
