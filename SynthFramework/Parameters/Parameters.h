//
//  Parameters.h
//
//  Created by Eric on 6/4/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface Parameters : NSObject

// dca
@property (nonatomic, assign) double volume;
@property (nonatomic, assign) double panL;
@property (nonatomic, assign) double panR;

+ (instancetype)sharedParameters;

- (void) setParameter:(AUParameterAddress) address withValue:(AUValue) value;
- (AUValue) getParameter:(AUParameterAddress) address;

@end
