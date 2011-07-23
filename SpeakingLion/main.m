//
//  main.c
//  SpeakingLion
//
//  Created by Boris Bügling on 20.07.11.
//  Copyright 2011. All rights reserved.
//

#import "NNLanguageAnalyzer.h"
#import "NNSpeech.h"

void speakSentencesInCString(char *cString);

void speakSentencesInCString(char *cString) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NNLanguageAnalyzer* analyzer = [[NNLanguageAnalyzer alloc] initWithString:[NSString stringWithCString:cString 
                                                                                                 encoding:NSUTF8StringEncoding]];
    
    NSArray* sentenceRanges;
    NSArray* languages = [analyzer languagesForSentences:&sentenceRanges];
    
    NNSpeech* speech = [[NNSpeech alloc] init];
    
    for (int i = 0; i < [languages count]; i++) {
        NSString* language = [languages objectAtIndex:i];
        
        if ([language length] < 1 || [language isEqualToString:kUndefinedLanguage]) continue;
        
        NSString* voiceName = [NNSpeech voiceForLanguage:language];
        
        if (!voiceName) {
            fprintf(stderr, "No voice available for language '%s'.\n", [language cStringUsingEncoding:NSASCIIStringEncoding]);
            continue;
        }
        
        [speech speakText:[analyzer.tagger.string substringWithRange:NSRangeFromString([sentenceRanges objectAtIndex:i])] 
                withVoice:voiceName];
    }
    
    [speech release];
    [analyzer release];
    [pool release];
}

int main (int argc, const char * argv[]) {
    /*speakSentencesInCString("Klaus geht über die Straße. He is just some random guy. L'état c'est moi."
                            " Vielleicht liegt es daran, dass er Klaus ist. Nyan Nyan Nyan.");*/
    
    char line[255];
    while( fgets(line, sizeof(line), stdin) != NULL ) {
        speakSentencesInCString(line);
    }
    
    fclose(stdin);
    return 0;
}