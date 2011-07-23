//
//  NNLanguageAnalyzer.h
//  SpeakingLion
//
//  Created by Boris Bügling on 20.07.11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

// There seems to be no Cocoa-defined constant for this
#define kUndefinedLanguage          @"und"

@interface NNLanguageAnalyzer : NSObject

@property (readonly) NSLinguisticTagger* tagger;

-(id)initWithString:(NSString*)string;

-(NSString*)determineLanguage;
-(NSString*)determineLanguageForRange:(NSRange)range;

-(NSArray*)languagesForSentences:(NSArray**)sentences;

-(NSArray*)sentenceRanges;

@end