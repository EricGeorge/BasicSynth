//
//  AppDelegate.h
//  AUInstrument
//
//  Created by Eric on 4/14/16.
//  Copyright © 2016 Eric George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate*) sharedAppDelegate;

@end

