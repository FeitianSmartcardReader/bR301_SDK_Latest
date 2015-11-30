//
//  GameConfig.m
//  lolasmath
//
//  Created by Atte Kotiranta on 9/22/11.
//  Copyright 2011 BeiZ Ltd. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

@synthesize coordinatesDic;

@synthesize languageIndex;
@synthesize currentLanguage;
@synthesize languageDictionary;
@synthesize selectedFlagForGaveLevel;
@synthesize isFist;
//@synthesize jumpDisConnection;


static NSString* languagesArray[LANGUAGE_MAX_NUM] = {@"en", @"zh-Hans"};

static Configuration *sharedConfiguration = nil;

+ (Configuration*)sharedConfiguration
{
	if (sharedConfiguration == nil) {
        sharedConfiguration = [[super allocWithZone:NULL] init];
    }
    return sharedConfiguration;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedConfiguration];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        //[self getCoordinatesFromPlist];
        
        self.currentLanguage = [[NSString alloc] initWithString: [self initializeLanguage]];
        [self getLanguageStrings: self.currentLanguage];
        hasLanguageChanged = YES;
        
    }
    
    return self;
}

#pragma mark
#pragma mark COORDINATE METHODS
/*
- (void)getCoordinatesFromPlist
{
	NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"Coordinates" ofType:@"plist"];	
	self.coordinatesDic = [[NSDictionary alloc] initWithContentsOfFile:pListPath];
}

- (CGPoint)getCoordinateforKey:(NSString*)key
{
	NSString *coorString = [self.coordinatesDic valueForKey:key];
	NSRange commaRange = [coorString rangeOfString:@","];
	NSRange range1 = NSMakeRange(1, commaRange.location-1);
	NSString *coordinateX = [coorString substringWithRange:range1];
	NSInteger x = [coordinateX intValue];
	
	NSRange range2 = NSMakeRange(commaRange.location+1, [coorString length] - commaRange.location - 2);
	NSString *coordinateY = [coorString substringWithRange:range2];
	NSInteger y = [coordinateY intValue];
	
	return ccp(x,y);
}
*/
#pragma mark 
#pragma mark LANGUAGE METHODS
- (void)getLanguageStrings:(NSString*)language
{
	NSString *path = [[NSBundle mainBundle] pathForResource:language
													 ofType:@"strings"];                                                       
												
    //NSLog(@"path is :%@",path);
	
	// compiled .strings file becomes a "binary property list"
	[self.languageDictionary release];
	self.languageDictionary = nil;
	self.languageDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    //NSLog(@"languageDictionary is: %@",self.languageDictionary);
}

- (NSString*)initializeLanguage
{
    //    NSLog(@"From saved file, the language is: %@", [self getSavedLanguage]);
    
    //if ([self getSavedLanguage] == nil) {
        NSString *language = [self getDeviceLanguage];
        for (int i = 0; i < LANGUAGE_MAX_NUM; i++) {
            if([language isEqualToString:languagesArray[i]]){
                self.languageIndex = i;
                return language;
            }
        }
        self.languageIndex = 0;
        return languagesArray[0];
//    }else
//    {
//        NSString *language = [self getSavedLanguage];
//        for (int i = 0; i < LANGUAGE_MAX_NUM; i++) {
//            if([language isEqualToString:languagesArray[i]]){
//                self.languageIndex = i;
//            }
//        }
//    }
    
//    return [self getSavedLanguage];
}

- (void)changeCurrentLanguage
{
	if (languageIndex == LANGUAGE_MAX_NUM-1) {
		languageIndex = 0;
	}
	else{
		languageIndex++;
	}
	self.currentLanguage = languagesArray[languageIndex];
	hasLanguageChanged = YES;
    
    [self getLanguageStrings:self.currentLanguage];    
}

- (NSString*)getDeviceLanguage
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	NSString *language = [languages objectAtIndex:0];
   // NSLog(@"%@",language);
	
	return language;
}

- (NSString*)getLangStringForKey:(NSString*)key
{
	if(key == nil)
		return nil;
    
	NSString *string;
	if([self.currentLanguage isEqualToString:@"en"] && hasLanguageChanged == NO){
		string = [NSString stringWithString:NSLocalizedString(key, @"")];
	}
	else {
		string = [NSString stringWithString:[self.languageDictionary objectForKey:key]];
	}
	return string;
}


@end
