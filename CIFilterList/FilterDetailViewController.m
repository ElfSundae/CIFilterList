//
//  FilterDetailViewController.m
//  CIFilterList
//
//  Created by Elf Sundae on 1/7/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "FilterDetailViewController.h"

@interface FilterDetailViewController ()
@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation FilterDetailViewController

- (instancetype)initWithFilterName:(NSString *)filterName
{
        return [self initWithFilter:[CIFilter filterWithName:filterName]];
}

- (instancetype)initWithFilter:(CIFilter *)filter
{
        NSParameterAssert([filter isKindOfClass:[CIFilter class]]);

        self = [super init];
        self.filter = filter;
        self.title = filter.name;
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.textView.font = [UIFont systemFontOfSize:14.f];
        self.textView.editable = NO;
        self.textView.scrollEnabled = YES;
        [self.view addSubview:self.textView];
        
        NSString *string = self.filter.attributes.description;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
        
        // Set foreground color for Keys.
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w+)\\s*="
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:NULL];
        UIColor *colorForKey = [UIColor redColor];
        [regex enumerateMatchesInString:string options:0 range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                [text addAttributes:@{ NSForegroundColorAttributeName : colorForKey} range:[result rangeAtIndex:1]];
        }];
        // Set text font
        UIFont *font = [UIFont fontWithName:@"Courier" size:14.f];
        [text addAttributes:@{NSFontAttributeName : font} range:NSMakeRange(0, text.length)];
        
        self.textView.attributedText = text;
}

- (void)viewWillLayoutSubviews
{
        [super viewWillLayoutSubviews];
        self.textView.frame = self.view.bounds;
}

@end
