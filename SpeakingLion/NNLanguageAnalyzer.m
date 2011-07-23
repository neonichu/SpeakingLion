//
//  NNLanguageAnalyzer.m
//  SpeakingLion
//
//  Created by Boris Bügling on 20.07.11.
//  Copyright 2011. All rights reserved.
//

#import "NNLanguageAnalyzer.h"

static NSLinguisticTaggerOptions kNNTaggerOptions = NSLinguisticTaggerOmitPunctuation|NSLinguisticTaggerOmitWhitespace|NSLinguisticTaggerOmitOther;

@implementation NNLanguageAnalyzer

@synthesize tagger;

-(id)initWithString:(NSString*)string {
    self = [super init];
    if (self) {
        tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:[NSArray arrayWithObject:NSLinguisticTagSchemeLanguage]
                                                                            options:kNNTaggerOptions];
        tagger.string = string;
    }
    return self;
}

-(void)dealloc {
    [tagger release];
    [super dealloc];
}

-(NSString*)determineLanguage {
    NSArray* tokenRanges;
    NSArray* result = [tagger tagsInRange:NSMakeRange(0, tagger.string.length) scheme:NSLinguisticTagSchemeLanguage 
                                  options:kNNTaggerOptions tokenRanges:&tokenRanges];
    
    NSMutableDictionary* languages = [NSMutableDictionary dictionary];
    for (NSString* lang in result) {
        NSDecimalNumber* count = [languages objectForKey:lang];
        if (count) {
            count = [count decimalNumberByAdding:[NSDecimalNumber one]];
        } else {
            count = [NSDecimalNumber zero];
        }
        [languages setValue:count forKey:lang];
    }
    
    if ([languages count] < 1) {
        return nil;
    }
    
    return [[languages keysSortedByValueUsingComparator:^(id number1, id number2) { return [number1 compare:number2]; }] 
            objectAtIndex:0];
}

-(NSString*)determineLanguageForRange:(NSRange)range {
    if (range.location == NSNotFound) return nil;
    id analyzer = [[[self class] alloc] initWithString:[tagger.string substringWithRange:range]];
    NSString* result = [analyzer determineLanguage];
    [analyzer release];
    return result;
}

-(NSArray*)languagesForSentences:(NSArray**)sentences {
    if (!sentences) return nil;
    
    *sentences = [self sentenceRanges];
    NSMutableArray* languages = [NSMutableArray arrayWithCapacity:[*sentences count]];
    
    for (NSString* rangeString in *sentences) {
        NSString* language = kUndefinedLanguage;
        
        NSRange range = NSRangeFromString(rangeString);
        if (range.location == NSNotFound) continue;
        
        language = [self determineLanguageForRange:range];
        if (!language) language = kUndefinedLanguage;
        
        [languages addObject:language];
    }
         
    return languages;
}

-(NSArray*)sentenceRanges {
    if (!tagger.string) return nil;
    NSMutableArray* ranges = [NSMutableArray array];
    NSUInteger nextChar = 0;
    while (nextChar <= tagger.string.length) {
        NSRange nextSentence = [tagger sentenceRangeForRange:NSMakeRange(nextChar, 1)];
        nextChar = nextSentence.location + nextSentence.length + 1;
        [ranges addObject:NSStringFromRange(nextSentence)];
    }
    return ranges;
}

@end