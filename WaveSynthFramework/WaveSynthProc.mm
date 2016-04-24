//
//  WaveSynthProc.cpp
//  AUInstrument
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import "WaveSynthProc.hpp"
#import "MIDIEvent.h"

WaveSynthProc::WaveSynthProc()
{
    sampleRate = 44100.0;
    frequencyScale = 2. * M_PI / sampleRate;
    
    outBufferListPtr = nullptr;
    
    osc = [[Oscillator alloc] init];
    osc.mode = OSCILLATOR_MODE_SAW;
    noteOn = NO;
}

void WaveSynthProc::init(int channelCount, double inSampleRate)
{
    sampleRate = float(inSampleRate);
    
    frequencyScale = 2. * M_PI / sampleRate;
}

void WaveSynthProc::reset()
{
}

void WaveSynthProc::startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration)
{
}

void WaveSynthProc::setBuffers(AudioBufferList* outBufferList)
{
    outBufferListPtr = outBufferList;
}

void WaveSynthProc::handleMIDIEvent(AUMIDIEvent const& midiEvent)
{
    MIDIEvent *event = [[MIDIEvent alloc] initWithAUMidiEvent:&midiEvent];
    
    switch (event.message)
    {
        default:
            NSLog(@"Instrument received unhandled MIDI event");
            break;
        case MIDIMessageType_NoteOff:
            noteOn = NO;
            break;
        case MIDIMessageType_NoteOn:
            osc.frequency = noteToHz(midiEvent.data[1]);
            noteOn = YES;
            break;
    }
}

void WaveSynthProc::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset)
{
    float* outL = (float*)outBufferListPtr->mBuffers[0].mData + bufferOffset;
    float* outR = (float*)outBufferListPtr->mBuffers[1].mData + bufferOffset;
    
    if (noteOn)
    {
        [osc generate:outL withFrames:frameCount];
        
        for (AUAudioFrameCount i = 0; i < frameCount; ++i)
        {
            // normalize volume
            outL[i] *= .01f;
            
            // and copy to right buffer (since the synth is generating mono waveform)
            outR[i] = outL[i];
        }
    }
}
