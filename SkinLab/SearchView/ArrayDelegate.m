//
//  ArrayDelegate.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-24.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ArrayDelegate.h"

@interface ArrayDelegate ()

@property (nonatomic, assign) float cellHeight;
@property (nonatomic, copy)   TableViewCellClickedBlock cellClickedBlock;

@end


@implementation ArrayDelegate

- (void)dealloc
{
    DLog(@"ArrayDelegate dealloc")
}

- (id)init
{
    return nil;
}

- (id)initWithHeight:(float)cellHeight
   cellClickedBlock:(TableViewCellClickedBlock)cellClickedBlock {
    self = [super init];
    if (self) {
        self.cellHeight       = cellHeight;
        self.cellClickedBlock = [cellClickedBlock copy];
    }
    return self;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellClickedBlock(tableView, indexPath);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}


@end
