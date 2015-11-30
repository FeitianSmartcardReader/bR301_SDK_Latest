//
//  GameConfig.h
//  lolasmath
//
//  Created by Atte Kotiranta on 9/22/11.
//  Copyright 2011 BeiZ Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LANGUAGE_MAX_NUM 2
#define GIFT_MAX_NUM 18

@interface Configuration : NSObject
{
	NSDictionary *coordinatesDic;    
    
    BOOL hasLanguageChanged;
	NSString *currentLanguage;
	unsigned int languageIndex;
	NSDictionary *languageDictionary;   
    
    int selectedFlagForGaveLevel;
    BOOL isFist;
}

@property (nonatomic, retain) NSDictionary *coordinatesDic;

@property (nonatomic, retain) NSString *currentLanguage;
@property (nonatomic, assign) unsigned int languageIndex;
@property (nonatomic, retain) NSDictionary *languageDictionary;

@property (nonatomic,assign) int selectedFlagForGaveLevel;
@property (nonatomic,assign) BOOL isFist;


+ (Configuration*)sharedConfiguration;

- (NSString*)initializeLanguage;
- (void)getLanguageStrings:(NSString*)language;
- (void)changeCurrentLanguage;
- (NSString*)getDeviceLanguage;
- (NSString*)getLangStringForKey:(NSString*)key;


@end
