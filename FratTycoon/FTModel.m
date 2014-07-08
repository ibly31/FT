//
//  FTModel.m
//  FratTycoon
//
//  Created by Billy Connolly on 2/13/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTModel.h"

static FTModel *model = nil;

@implementation FTModel
@synthesize currentHouseData;
@synthesize roomData;
@synthesize decorationData;
@synthesize buildingData;
@synthesize organizationData;
@synthesize peopleData;

- (id)init{
    self = [super init];
    if(self){
        NSString *roomFilePath = [[NSBundle mainBundle] pathForResource:@"Rooms" ofType:@"txt"];
        NSData *roomFileData = [NSData dataWithContentsOfFile:roomFilePath];
        
        if(roomFileData){
            self.roomData = [NSJSONSerialization JSONObjectWithData:roomFileData options:nil error:nil];
        }
        
        NSString *decorationFilePath = [[NSBundle mainBundle] pathForResource:@"Decorations" ofType:@"txt"];
        NSData *decorationFileData = [NSData dataWithContentsOfFile:decorationFilePath];
        
        if(decorationFileData){
            self.decorationData = [NSJSONSerialization JSONObjectWithData:decorationFileData options:nil error:nil];
        }
        
        NSString *buildingFilePath = [[NSBundle mainBundle] pathForResource:@"Buildings" ofType:@"txt"];
        NSData *buildingFileData = [NSData dataWithContentsOfFile:buildingFilePath];
        
        if(buildingFileData){
            self.buildingData = [NSJSONSerialization JSONObjectWithData:buildingFileData options:nil error:nil];
        }
        
        NSString *organizationFilePath = [[NSBundle mainBundle] pathForResource:@"FratsAndSoros" ofType:@"txt"];
        NSData *organizationFileData = [NSData dataWithContentsOfFile:organizationFilePath];
        
        if(organizationFileData){
            self.organizationData = [NSJSONSerialization JSONObjectWithData:organizationFileData options:nil error:nil];
        }
        
        NSString *peopleDataFilePath = [[NSBundle mainBundle] pathForResource:@"PeopleData" ofType:@"txt"];
        NSData *peopleDataFileData = [NSData dataWithContentsOfFile:peopleDataFilePath];
        
        if(peopleDataFileData){
            self.peopleData = [NSJSONSerialization JSONObjectWithData:peopleDataFileData options:nil error:nil];
        }
        
        NSString *houseFilePath = [[NSBundle mainBundle] pathForResource:@"DefaultHouse" ofType:@"txt"];
        NSData *houseFileData = [NSData dataWithContentsOfFile:houseFilePath];
        
        if(houseFileData){
            self.currentHouseData = [[NSJSONSerialization JSONObjectWithData:houseFileData options:nil error:nil] mutableCopy];
        }
    }
    return self;
}

- (NSDictionary *)roomWithName:(NSString *)roomName{
    for(int x = 0; x < [[roomData objectForKey: @"rooms"] count]; x++){
        NSDictionary *room = [[roomData objectForKey: @"rooms"] objectAtIndex: x];
        if([[room objectForKey: @"name"] isEqualToString: roomName]){
            if([room objectForKey: @"width"] != nil && [room objectForKey:@"height"] != nil)
                return room;
        }
    }
    return nil;
}

- (NSDictionary *)decorationWithName:(NSString *)decorationName{
    for(int x = 0; x < [[decorationData objectForKey: @"decorations"] count]; x++){
        NSDictionary *decoration = [[decorationData objectForKey: @"decorations"] objectAtIndex: x];
        if([[decoration objectForKey: @"name"] isEqualToString: decorationName]){
            return decoration;
        }
    }
    return nil;
}

- (NSDictionary *)buildingWithName:(NSString *)buildingName{
    for(int x = 0; x < [[buildingData objectForKey: @"buildings"] count]; x++){
        NSDictionary *building = [[buildingData objectForKey: @"buildings"] objectAtIndex: x];
        if([[building objectForKey: @"name"] isEqualToString: buildingName]){
            return building;
        }
    }
    return nil;
}

- (NSArray *)organizationListWithName:(NSString *)organizationName{
    if([organizationData objectForKey: organizationName] != nil){
        NSArray *orgArray = [organizationData objectForKey: organizationName];
        return orgArray;
    }
    return nil;
}

- (int)buildingCountWithName:(NSString *)buildingName{
    int count = 0;
    for(int x = 0; x < [[buildingData objectForKey: @"buildings"] count]; x++){
        NSDictionary *building = [[buildingData objectForKey: @"buildings"] objectAtIndex: x];
        int buildingNameLength = [buildingName length];
        if([[building objectForKey:@"name"] length] > buildingNameLength){
            if([[[building objectForKey: @"name"] substringToIndex: buildingNameLength] isEqualToString: buildingName])
                count++;
        }
    }
    return count;
}

- (NSObject *)peopleDataPropertyWithName:(NSString *)propertyName{
    NSObject *property = [peopleData objectForKey: propertyName];
    if(property != nil){
        return property;
    }else{
        NSLog(@"No property in people data called %@", propertyName);
        return nil;
    }
}

+ (id)sharedModel{
    @synchronized(self){
        if(model == nil)
            model = [[self alloc] init];
    }
    return model;
}

@end
