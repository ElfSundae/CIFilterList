//
//  FiltersListViewController.m
//  CIFilterList
//
//  Created by Elf Sundae on 1/7/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "FiltersListViewController.h"
@import CoreImage;
#import "FilterDetailViewController.h"

@interface FiltersListViewController ()
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *categoryName;
@end

@implementation FiltersListViewController

- (instancetype)initWithFilterCategory:(NSString *)category
{
        self = [super initWithStyle:UITableViewStylePlain];
        self.title = category;
        self.categoryName = category;
        self.list = [CIFilter filterNamesInCategory:category];
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.tableView.tableFooterView = [UIView new];
        
        __weak __typeof(&*self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                __typeof(&*weakSelf) _self = weakSelf;
                if (!_self) return;
                
                NSArray *filterNames = [CIFilter filterNamesInCategory:_self.categoryName];
                NSMutableArray *filters = [NSMutableArray array];
                for (NSString *name in filterNames) {
                        CIFilter *f = [CIFilter filterWithName:name];
                        if ([f isKindOfClass:[CIFilter class]]) {
                                [filters addObject:f];
                        }
                }
                _self.list = filters;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        __typeof(&*weakSelf) _self = weakSelf;
                        if (!_self) return;
                        
                        _self.navigationItem.title = [NSString stringWithFormat:@"%@(%d)", _self.categoryName, (int)_self.list.count];
                        [_self.tableView reloadData];
                });
        });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *cellID = @"CellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        CIFilter *filter = self.list[indexPath.row];
        if ([filter isKindOfClass:[CIFilter class]]) {
                cell.textLabel.text = filter.name;
                cell.detailTextLabel.text = filter.attributes[kCIAttributeFilterDisplayName];
        } else {
                NSLog(@"wrong filter? %@, %@", NSStringFromClass(filter.class), filter);
        }
        
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        CIFilter *filter = self.list[indexPath.row];
        FilterDetailViewController *detailController = [[FilterDetailViewController alloc] initWithFilter:filter];
        [self.navigationController pushViewController:detailController animated:YES];
}


@end
