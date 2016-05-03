//
//  SynthProc.cpp
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthProc.hpp"

#import "DCA.h"
#import "MIDIEvent.h"
#import "Oscillator.h"
#import "Utility.hpp"

SynthProc::SynthProc()
{
    sampleRate = 44100.0;
    frequencyScale = 2. * M_PI / sampleRate;
    
    outBufferListPtr = nullptr;
    noteOn = NO;
    
    // osc
    osc = [[Oscillator alloc] init];
    
    // dca
    dca = [[DCA alloc] init];
}

void SynthProc::init(int channelCount, double inSampleRate)
{
    sampleRate = float(inSampleRate);
    frequencyScale = 2.0 * M_PI / sampleRate;
}

void SynthProc::reset()
{
    // this currently does nothing
}

void SynthProc::setParameter(AUParameterAddress address, AUValue value)
{
    switch (address)
    {
        case SynthProc::InstrumentParamVolume:
            dca.volume_dB = value;
            break;
        case SynthProc::InstrumentParamWaveform:
            osc.wave = (OscillatorWave)value;
            break;
        case SynthProc::InstrumentParamPan:
            dca.pan = value;
            break;
    }
}

AUValue SynthProc::getParameter(AUParameterAddress address)
{
    AUValue value = 0.0f;
    
    switch (address)
    {
        case InstrumentParamVolume:
            value = dca.volume_dB;
            break;
        case InstrumentParamWaveform:
            value = osc.wave;
            break;
        case InstrumentParamPan:
            value = dca.pan;
            break;
    }
    
    return value;
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
            noteOn = NO;
            dca.midiVelocity = 0;
            break;
        case MIDIMessageType_NoteOn:
            osc.frequency = noteToHz(event.data1);
            dca.midiVelocity = event.data2;
            noteOn = YES;
            break;
    }
}

void SynthProc::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset)
{
    float* left = (float*)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float* right = (float*)outBufferListPtr->mBuffers[1].mData + bufferOffset;

    double inL = 0.0;
    double inR = 0.0;
    double outL = 0.0;
    double outR = 0.0;

    if (noteOn)
    {
        for (AUAudioFrameCount i = 0; i < frameCount; ++i)
        {
            inL = 0.0;
            inR = 0.0;
            outL = 0.0;
            outR = 0.0;
            
            // oscillator
            inL = inR = [osc nextSample];
            
            // dca
            [dca compute:inL rightInput:inR leftOutput:&outL rightOutput:&outR];
    
            // update the buffer
            left[i] = outL;
            right[i] = outR;
        }
    }
}
