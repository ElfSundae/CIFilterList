//
//  FilterDetailViewController.h
//  CIFilterList
//
//  Created by Elf Sundae on 1/7/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreImage;

@interface FilterDetailViewController : UIViewController

- (instancetype)initWithFilterName:(NSString *)filterName;
- (instancetype)initWithFilter:(CIFilter *)filter;

@end
