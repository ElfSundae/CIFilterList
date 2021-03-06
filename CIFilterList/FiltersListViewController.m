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

@interface FiltersListViewController () <UISearchBarDelegate>
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchFilteredList;
@end

@implementation FiltersListViewController

- (instancetype)initWithFilterCategory:(NSString *)category
{
        self = [super initWithStyle:UITableViewStylePlain];
        self.title = category;
        self.categoryName = category;
        self.list = [CIFilter filterNamesInCategory:category];
        self.searchFilteredList = [NSMutableArray arrayWithCapacity:self.list.count];
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
                        [_self _reloadTableViewWithSearchText:nil];
                });
        });
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
        self.searchBar.delegate = self;
        [self.searchBar sizeToFit];
        self.tableView.tableHeaderView = self.searchBar;
}

- (void)_reloadTableViewWithSearchText:(NSString *)searchText
{
        [self.searchFilteredList removeAllObjects];
        if (self.searchBar.isFirstResponder && searchText.length) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
                [self.searchFilteredList addObjectsFromArray:[self.list filteredArrayUsingPredicate:predicate]];
        } else {
                [self.searchFilteredList addObjectsFromArray:self.list];
        }
        [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        if (self.searchBar.isFirstResponder) {
                [self.searchBar resignFirstResponder];
        }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.searchFilteredList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *cellID = @"CellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        CIFilter *filter = self.searchFilteredList[indexPath.row];
        if ([filter isKindOfClass:[CIFilter class]]) {
                cell.textLabel.text = filter.name;
                cell.detailTextLabel.text = filter.attributes[kCIAttributeFilterDisplayName];
        } else {
                //NSLog(@"wrong filter? %@, %@", NSStringFromClass(filter.class), filter);
                cell.textLabel.text = filter.description;
        }
        
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        CIFilter *filter = self.searchFilteredList[indexPath.row];
        FilterDetailViewController *detailController = [[FilterDetailViewController alloc] initWithFilter:filter];
        if (detailController) {
                [self.navigationController pushViewController:detailController animated:YES];
        }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UISearchBarDelegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
        NSString *searchText = [self.searchBar.text stringByReplacingCharactersInRange:range withString:text];
        searchText = [searchText stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, searchText.length)];
        [self _reloadTableViewWithSearchText:searchText];
        return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
        [self _reloadTableViewWithSearchText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
        [self _reloadTableViewWithSearchText:self.searchBar.text];
        [searchBar resignFirstResponder];
}

@end
