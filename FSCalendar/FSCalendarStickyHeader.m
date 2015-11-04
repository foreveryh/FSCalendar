//
//  FSCalendarStaticHeader.m
//  FSCalendar
//
//  Created by dingwenchao on 9/17/15.
//  Copyright (c) 2015 wenchaoios. All rights reserved.
//

#import "FSCalendarStickyHeader.h"
#import "FSCalendar.h"
#import "UIView+FSExtension.h"
#import "NSDate+FSExtension.h"
#import "FSCalendarConstance.h"
#import "FSCalendarDynamicHeader.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FSCalendarStickyHeader ()

@property (weak, nonatomic) UIView *contentView;
@property (weak, nonatomic) UIView *leftSeparator;
@property (weak, nonatomic) UIView *rightSeparator;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (assign, nonatomic) BOOL needsReloadingAppearance;
@property (assign, nonatomic) BOOL needsAdjustingFrames;


- (void)reloadAppearance;

@end

@implementation FSCalendarStickyHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.needsReloadingAppearance = YES;
        self.needsAdjustingFrames = YES;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        self.contentView = view;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [_contentView addSubview:label];
        self.titleLabel = label;
        /* modified by GP */
        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = UIColorFromRGB(0xeeeeee);
        [_contentView addSubview:view];
        self.leftSeparator = view;
        
        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = _leftSeparator.backgroundColor;
        [_contentView addSubview:view];
        self.rightSeparator = view;
    
//        NSMutableArray *weekdayLabels = [NSMutableArray arrayWithCapacity:7];
//        for (int i = 0; i < 7; i++) {
//            label = [[UILabel alloc] initWithFrame:CGRectZero];
//            label.textAlignment = NSTextAlignmentCenter;
//            [_contentView addSubview:label];
//            [weekdayLabels addObject:label];
//        }
//        self.weekdayLabels = weekdayLabels.copy;
        /*******************/
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_needsAdjustingFrames) {
        if (!CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
            _needsAdjustingFrames = NO;
            _contentView.frame = self.bounds;
            CGFloat weekdayWidth = self.fs_width / 7.0;
            CGFloat weekdayHeight = _calendar.preferedWeekdayHeight;
            CGFloat weekdayMargin = weekdayHeight * 0.1;
      
            /* remove by GP */
//            CGFloat titleWidth = _contentView.fs_width;
//            [_weekdayLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) { \
//                label.frame = CGRectMake(index*weekdayWidth, _contentView.fs_height-weekdayHeight-weekdayMargin, weekdayWidth, weekdayHeight);
//            }];
            /*****************/
            
            /* add by GP */
            
            CGFloat separatorWidth = 75.0;
          
           /*****************/
#define m_calculate \
        CGFloat titleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_appearance.titleTextSize]}].height*1.5 + weekdayMargin*3;\
        CGFloat titleWidth = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_appearance.titleTextSize]}].width;
            
#define m_adjust \
        CGFloat leftX = _contentView.fs_width/2 - titleWidth/2 - 10.0 - separatorWidth;\
        CGFloat rightX = _contentView.fs_width/2 + titleWidth/2 + 10.0;\
        _leftSeparator.frame = CGRectMake(leftX, _contentView.fs_height-weekdayHeight-weekdayMargin*2, separatorWidth, 1);\
        _rightSeparator.frame = CGRectMake(rightX, _contentView.fs_height-weekdayHeight-weekdayMargin*2, separatorWidth, 1);\
        _titleLabel.frame = CGRectMake(0, _separator.fs_bottom-titleHeight-weekdayMargin, titleWidth,titleHeight);
            
            if (_calendar.ibEditing) {
                m_calculate
                m_adjust
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    m_calculate
                    dispatch_async(dispatch_get_main_queue(), ^{
                        m_adjust
                    });
                });
            }
        }
    }
    
    [self reloadData];
    
    if (_needsReloadingAppearance) {
        _needsReloadingAppearance = NO;
        [self reloadAppearance];
    }
}

#pragma mark - Public methods

- (void)reloadData
{
    /** remove by GP **/
//    BOOL useVeryShortWeekdaySymbols = (_appearance.caseOptions & (15<<4) ) == FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
//    NSArray *weekdaySymbols = useVeryShortWeekdaySymbols ? _calendar.calendar.veryShortStandaloneWeekdaySymbols : _calendar.calendar.shortStandaloneWeekdaySymbols;
//    BOOL useDefaultWeekdayCase = (_appearance.caseOptions & (15<<4) ) == FSCalendarCaseOptionsWeekdayUsesDefaultCase;
//    [_weekdayLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
//        index += _calendar.firstWeekday-1;
//        index %= 7;
//        label.text = useDefaultWeekdayCase ? weekdaySymbols[index] : [weekdaySymbols[index] uppercaseString];
//    }];
    /******************/
    _dateFormatter.dateFormat = _appearance.headerDateFormat;
    _dateFormatter.locale = self.calendar.locale;
    BOOL usesUpperCase = (_appearance.caseOptions & 15) == FSCalendarCaseOptionsHeaderUsesUpperCase;
    NSString *text = [_dateFormatter stringFromDate:_month];
    text = usesUpperCase ? text.uppercaseString : text;
    _titleLabel.text = text;
}

- (void)reloadAppearance
{
    _titleLabel.font = [UIFont systemFontOfSize:self.appearance.headerTitleTextSize];
    _titleLabel.textColor = UIColorFromRGB(0xc4c4c4); // self.appearance.headerTitleColor;
    /** remove by GP **/
//    [_weekdayLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
//        label.font = [UIFont systemFontOfSize:self.appearance.weekdayTextSize];
//        label.textColor = self.appearance.weekdayTextColor;
//    }];
    /******************/
}

@end


