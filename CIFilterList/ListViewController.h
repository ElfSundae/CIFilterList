//
//  ListViewController.h
//  CIFilterList
//
//  Created by Elf Sundae on 1/7/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CILCategoryType) {
        CILCategoryTypeByEffect,
        CILCategoryTypeByUsage,
        CILCategoryTypeBuiltIn
};

@interface ListViewController : UITableViewController

@property (nonatomic, readonly) CILCategoryType categoryType;
- (instancetype)initWithCategoryType:(CILCategoryType)categoryType;

@end
