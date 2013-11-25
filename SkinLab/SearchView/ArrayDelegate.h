//
//  ArrayDelegate.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-24.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellClickedBlock)(UITableView *tableView, NSIndexPath *indexPath);

@interface ArrayDelegate : NSObject <UITableViewDelegate>

- (id)initWithHeight:(float)cellHeight
   cellClickedBlock:(TableViewCellClickedBlock)cellClickedBlock;

@end
