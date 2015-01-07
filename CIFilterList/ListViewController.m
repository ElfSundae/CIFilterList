//
//  ListViewController.m
//  CIFilterList
//
//  Created by Elf Sundae on 1/7/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ListViewController.h"
@import CoreImage;
#import "FiltersListViewController.h"

@interface ListViewController ()
@property (nonatomic, strong) NSArray *list;
@end

@implementation ListViewController

- (instancetype)initWithCategoryType:(CILCategoryType)categoryType
{
        self = [super initWithStyle:UITableViewStylePlain];
        
        _categoryType = categoryType;
        NSString *title = nil;
        UITabBarItem *tabBarItem = nil;
        switch (_categoryType) {
                case CILCategoryTypeByEffect:
                        title = @"Effect";
                        tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
                        break;
                case CILCategoryTypeByUsage:
                        title = @"Usage";
                        tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
                        break;
                default:
                        title = @"Built-in";
                        tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
        }
        self.title = title;
        self.tabBarItem = tabBarItem;
        [self.tabBarItem setValue:title forKey:@"_title"];
        
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        
        if (CILCategoryTypeByEffect == self.categoryType) {
                self.list = @[ @{ kCICategoryDistortionEffect:
                                          @"Distortion effects, such as bump, twirl, hole" },
                               @{ kCICategoryGeometryAdjustment:
                                          @"Geometry adjustment, such as affine transform, crop, perspective transform" },
                               @{ kCICategoryCompositeOperation:
                                          @"Compositing, such as source over, minimum, source atop, color dodge blend mode" },
                               @{ kCICategoryHalftoneEffect:
                                          @"Halftone effects, such as screen, line screen, hatched" },
                               @{ kCICategoryColorAdjustment:
                                          @"Color adjustment, such as gamma adjust, white point adjust, exposure" },
                               @{ kCICategoryColorEffect:
                                          @"Color effect, such as hue adjust, posterize" },
                               @{ kCICategoryTransition:
                                          @"Transitions between images, such as dissolve, disintegrate with mask, swipe" },
                               @{ kCICategoryTileEffect:
                                          @"Tile effect, such as parallelogram, triangle" },
                               @{ kCICategoryGenerator:
                                          @"Image generator, such as stripes, constant color, checkerboard" },
                               @{ kCICategoryReduction:
                                          @"A filter that reduces image data. These filters are used to solve image analysis problems." },
                               @{ kCICategoryGradient:
                                          @"Gradient, such as axial, radial, Gaussian" },
                               @{ kCICategoryStylize:
                                          @"Stylize, such as pixellate, crystallize" },
                               @{ kCICategorySharpen:
                                          @"Sharpen, luminance" },
                               @{ kCICategoryBlur:
                                          @"Blur, such as Gaussian, zoom, motion" },
                               ];
        } else if (CILCategoryTypeByUsage == self.categoryType) {
                self.list = @[ @{ kCICategoryVideo:
                                          @"works on video images." },
                               @{ kCICategoryStillImage:
                                          @"works on still images." },
                               @{ kCICategoryInterlaced:
                                          @"works on interlaced images." },
                               @{ kCICategoryNonSquarePixels:
                                          @"works on non-square pixels." },
                               @{ kCICategoryHighDynamicRange:
                                          @"works on high dynamic range pixels." },
                               ];
        } else {
                self.list = @[ @{kCICategoryBuiltIn:
                                         @"A filter provided by Core Image. This distinguishes built-in filters from plug-in filters."}
                               ];
        }
        
        self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *cellID = @"CellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.numberOfLines = 0;
                cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        
        cell.textLabel.text = [self.list[indexPath.section] allKeys][0];
        cell.detailTextLabel.text = [self.list[indexPath.section] allObjects][0];
        
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *category = [self.list[indexPath.section] allKeys][0];
        FiltersListViewController *filtersListController = [[FiltersListViewController alloc] initWithFilterCategory:category];
        [self.navigationController pushViewController:filtersListController animated:YES];
}


@end
