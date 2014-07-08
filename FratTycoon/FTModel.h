//
//  FTModel.h
//  FratTycoon
//
//  Created by Billy Connolly on 2/13/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTModel : NSObject{
    NSDictionary *roomData;
    NSDictionary *decorationData;
    NSDictionary *buildingData;
    NSDictionary *organizationData;
    NSDictionary *peopleData;
    
    NSMutableDictionary *currentHouseData;
}

+ (id)sharedModel;

@property (nonatomic, retain) NSMutableDictionary *currentHouseData;
@property (nonatomic, retain) NSDictionary *roomData;
@property (nonatomic, retain) NSDictionary *decorationData;
@property (nonatomic, retain) NSDictionary *buildingData;
@property (nonatomic, retain) NSDictionary *organizationData;
@property (nonatomic, retain) NSDictionary *peopleData;

- (NSDictionary *)roomWithName:(NSString *)roomName;
- (NSDictionary *)decorationWithName:(NSString *)decorationName;
- (NSDictionary *)buildingWithName:(NSString *)buildingName;
- (NSArray *)organizationListWithName:(NSString *)organizationName;
- (NSObject *)peopleDataPropertyWithName:(NSString *)propertyName;

- (int)buildingCountWithName:(NSString *)buildingName;

@end
