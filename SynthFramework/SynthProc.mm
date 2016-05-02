//
//  SynthProc.cpp
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "SynthProc.hpp"

#import "MIDIEvent.h"
#import "Utility.hpp"

SynthProc::SynthProc()
{
    sampleRate = 44100.0;
    frequencyScale = 2. * M_PI / sampleRate;
    
    outBufferListPtr = nullptr;
    
    osc = [[Oscillator alloc] init];
    osc.wave = OSCILLATOR_WAVE_SINE;
    noteOn = NO;
    velocity = 0;
    volume = 0.1;
}

void SynthProc::init(int channelCount, double inSampleRate)
{
    sampleRate = float(inSampleRate);
    
    frequencyScale = 2. * M_PI / sampleRate;
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
            volume = clamp(value, 0.001f, 1.0f);
            break;
        case SynthProc::InstrumentParamWaveform:
            osc.wave = (OscillatorWave)value;
            break;
    }
}

AUValue SynthProc::getParameter(AUParameterAddress address)
{
    AUValue value = 0.0f;
    
    switch (address)
    {
        case InstrumentParamVolume:
            value = volume;
            break;
        case InstrumentParamWaveform:
            value = osc.wave;
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
            velocity = 0;
            break;
        case MIDIMessageType_NoteOn:
            osc.frequency = noteToHz(event.data1);
            velocity = event.data2;
            noteOn = YES;
            break;
    }
}

void SynthProc::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset)
{
    float* outL = (float*)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float* outR = (float*)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    if (noteOn)
    {
        for (AUAudioFrameCount i = 0; i < frameCount; ++i)
        {
            outL[i] = outR[i] = [osc nextSample] * (double)velocity / 127.0 * volume;
        }
    }
}
