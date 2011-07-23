//
//  NNSpeech.m
//  SpeakingLion
//
//  Created by Boris Bügling on 20.07.11.
//  Copyright 2011. All rights reserved.
//

#import "NNSpeech.h"

@implementation NNSpeech

@synthesize synthesizers;

-(id)init {
    self = [super init];
    if (self) {
        synthesizers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc {
    [synthesizers release];
    [super dealloc];
}

-(void)speakText:(NSString*)text withVoice:(NSString*)voiceName {
    if (!text || !voiceName) return;
    
    NSSpeechSynthesizer* synthesizer = [synthesizers objectForKey:voiceName];
    
    if (!synthesizer) {
        synthesizer = [[NSSpeechSynthesizer alloc] initWithVoice:voiceName];
        [synthesizers setObject:synthesizer forKey:voiceName];
        [synthesizer release];
    }
    
    [synthesizer startSpeakingString:text];
    while (synthesizer.isSpeaking);
}

+(NSString*)langForVoice:(NSString*)voiceName {
    NSDictionary* attributes = [NSSpeechSynthesizer attributesForVoice:voiceName];
    return [[attributes objectForKey:NSVoiceLocaleIdentifier] substringWithRange:NSMakeRange(0, 2)];
}

+(NSString*)voiceForLanguage:(NSString*)language {
    if (!language) return nil;
    
    NSString* defaultVoice = [NSSpeechSynthesizer defaultVoice];
    if ([[self langForVoice:defaultVoice] isEqualToString:language]) return defaultVoice;
    
    for (NSString* voiceName in [NSSpeechSynthesizer availableVoices]) {
        if ([[self langForVoice:voiceName] isEqualToString:language]) return voiceName;
    }
    
    return nil;
}

@end