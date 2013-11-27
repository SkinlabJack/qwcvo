//
//  DataCenter.m
//  tryseason
//
//  Created by Dai Qinfu on 12-8-15.
//  Copyright (c) 2012年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "DataCenter.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation DataCenter


- (id)init{
    self = [super init];
    if (self) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"WeeklyRead"]) {
            NSMutableArray *weeklyReadArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"WeeklyRead"]];
            self.weeklyReadArray = weeklyReadArray;
        }else{
            self.weeklyReadArray = [NSMutableArray array];
        }
        
    }
    return  self;
}

#pragma mark - Favorite

- (BOOL)removeFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:filePath error:nil])
        return true;
    else
        return false;
}

- (void)addToMyWant:(NSDictionary *)dic {
    
    if (![self isMyWant:dic[@"productID"]]) {
        [self.wantArray addObject:dic];
        [self writeToFile:self.wantArray withFileName:@"want.plist"];
    }
}

- (void)addToMyUsing:(NSDictionary *)dic {
    
    if (![self isMyUsing:dic[@"productID"]]) {
        [self.usingArray addObject:dic];
        [self writeToFile:self.usingArray withFileName:@"using.plist"];
    }
}

- (void)deleteFromMyWant:(NSString *)productID {
    for (NSDictionary *dic in self.wantArray) {
        if ([dic[@"productID"] isEqualToString:productID]) {
            
            if (self.wantArray.count == 1) {
                [self removeFile:@"want.plist"];
                self.wantArray = [[NSMutableArray alloc] init];
            }else{
                [self.wantArray removeObject:dic];
                [self writeToFile:self.wantArray withFileName:@"want.plist"];
            }
            DLog(@"wantArray = %d", self.wantArray.count);
            break;
        }
    }
}

- (void)deleteFromMyUsing:(NSString *)productID {
    for (NSDictionary *dic in self.usingArray) {
        if ([dic[@"productID"] isEqualToString:productID]) {
            
            if (self.usingArray.count == 1) {
                [self removeFile:@"using.plist"];
                self.usingArray = [[NSMutableArray alloc] init];
            }else{
                [self.usingArray removeObject:dic];
                [self writeToFile:self.usingArray withFileName:@"using.plist"];
            }
            
            DLog(@"usingArray = %d", self.usingArray.count);
            break;
        }
    }
}

- (void)deleteFromMyWantAtIndex:(NSInteger *)row{
    
    if (self.wantArray.count == 1) {
        [self removeFile:@"want.plist"];
        self.wantArray = [[NSMutableArray alloc] init];
    }else{
        [self.wantArray removeObjectAtIndex:row];
        [self writeToFile:self.wantArray withFileName:@"want.plist"];
    }
    DLog(@"wantArray = %d", self.wantArray.count);
}

- (void)deleteFromMyUsingAtIndex:(NSInteger *)row{
    
    if (self.usingArray.count == 1) {
        [self removeFile:@"using.plist"];
        self.usingArray = [[NSMutableArray alloc] init];
    }else{
        [self.usingArray removeObjectAtIndex:row];
        [self writeToFile:self.usingArray withFileName:@"using.plist"];
    }
    DLog(@"usingArray = %d", self.usingArray.count);
}

- (BOOL)isMyWant:(NSString *)productID{
    for (NSDictionary *dic in self.wantArray) {
        if ([dic[@"productID"] isEqualToString:productID]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isMyUsing:(NSString *)productID{
    for (NSDictionary *dic in self.usingArray) {
        if ([dic[@"productID"] isEqualToString:productID]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Weekly

- (void)markWeeklyRead:(NSString *)JID{
    if (![self isWeeklyRead:JID]) {
        [self.weeklyReadArray addObject:JID];
        [[NSUserDefaults standardUserDefaults] setObject:self.weeklyReadArray forKey:@"WeeklyRead"];
    }
    
    DLog(@"%@", self.weeklyReadArray)
}

- (BOOL)isWeeklyRead:(NSString *)JID{
    for (NSString *Journal in self.weeklyReadArray) {
        if ([JID isEqualToString:Journal]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - WriteToFile

- (void)writeToFile:(id)file withFileName:(NSString *)fileName {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = paths[0];
        NSString *filepath = [path stringByAppendingPathComponent:fileName];
        [file writeToFile:filepath atomically:YES];
        DLog(@"writing %@ = %@", fileName, [file writeToFile:filepath atomically:YES]?@"写入成功":@"写入失败");
    });
    
}

@end
