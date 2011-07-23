//
//  NNSpeech.h
//  SpeakingLion
//
//  Created by Boris Bügling on 20.07.11.
//  Copyright 2011. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NNSpeech : NSObject

@property (readonly) NSMutableDictionary* synthesizers;

-(void)speakText:(NSString*)text withVoice:(NSString*)voiceName;

+(NSString*)voiceForLanguage:(NSString*)language;

@end