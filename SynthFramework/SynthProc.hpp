//
//  SynthProc.hpp
//
//  Created by Eric on 4/23/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#ifndef SynthProc_hpp
#define SynthProc_hpp

#import "DSPKernel.hpp"

@class Voices;

class SynthProc : public DSPKernel
{
public:
    SynthProc();
    
    void init(int channelCount, double inSampleRate);
    void reset();
    void setBuffers(AudioBufferList* outBufferList);
    
    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration)  override;
    void handleMIDIEvent(AUMIDIEvent const& midiEvent)  override;
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;

private:
    float sampleRate;
    
    AudioBufferList* outBufferListPtr;
    Voices *voices;
};

#endif /* SynthProc_hpp */
