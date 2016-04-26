//
//  AudioEngine.h
//  AUInstrument
//
//  Created by Eric on 4/19/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

@import Foundation;
@import AVFoundation;


@interface AudioEngine : NSObject

@property(nonatomic, strong)AVAudioUnit *synth;

@end
