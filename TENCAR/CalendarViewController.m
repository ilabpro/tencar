//
//  CalendarViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 23.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "CalendarViewController.h"
#import "GLCalendarView.h"
#import "GLCalendarDateRange.h"
#import "GLDateUtils.h"
#import "GLCalendarDayCell.h"
#import "REFrostedViewController.h"


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CalendarViewController ()<GLCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet GLCalendarView *calendarView;
@property (nonatomic, weak) GLCalendarDateRange *rangeUnderEdit;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.calendarView.delegate = self;
    self.calendarView.showMagnifier = YES;
    
    self.calendarView.firstDate = [self dateAtStartOfMonth];
    self.calendarView.lastDate = [self dateAtEndOfMonth];
    
    
    
    NSDate *today = [NSDate date];
    
    NSDate *endDate2 = [GLDateUtils dateByAddingDays:1 toDate:today];
    GLCalendarDateRange *range2 = [GLCalendarDateRange rangeWithBeginDate:today endDate:endDate2];
    range2.backgroundColor = UIColorFromRGB(0x00B7F5);
    range2.editable = YES;
   
    
    
    
    self.calendarView.ranges = [@[range2] mutableCopy];
    
    [self.calendarView reload];
    
    //[self.calendarView beginToEditRange:range2];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.calendarView scrollToDate:self.calendarView.lastDate animated:NO];
        [self.calendarView beginToEditRange:range2];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
    });
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.frostedViewController.panGestureEnabled = NO;
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)calenderView:(GLCalendarView *)calendarView canAddRangeWithBeginDate:(NSDate *)beginDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    
    NSDateComponents *date1Components = [calendar components:comps
                                                    fromDate: beginDate];
    NSDateComponents *date2Components = [calendar components:comps
                                                    fromDate: [NSDate date]];
    
    NSDate *date1 = [calendar dateFromComponents:date1Components];
    NSDate *date2 = [calendar dateFromComponents:date2Components];
    
    NSComparisonResult result = [date1 compare:date2];
    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedDescending) {
        
    }  else {
        //the same
    }
    
    return YES;
}

- (GLCalendarDateRange *)calenderView:(GLCalendarView *)calendarView rangeToAddWithBeginDate:(NSDate *)beginDate
{
     NSLog(@"begin add range");
    
    NSDate* endDate = [GLDateUtils dateByAddingDays:1 toDate:beginDate];
    GLCalendarDateRange *range = [GLCalendarDateRange rangeWithBeginDate:beginDate endDate:endDate];
    range.backgroundColor = UIColorFromRGB(0x00B7F5);
    range.editable = YES;
    [self.calendarView beginToEditRange:range];
    return range;
}

- (void)calenderView:(GLCalendarView *)calendarView beginToEditRange:(GLCalendarDateRange *)range
{
    NSLog(@"begin to edit range: %@", range);
    self.rangeUnderEdit = range;
}

- (void)calenderView:(GLCalendarView *)calendarView finishEditRange:(GLCalendarDateRange *)range continueEditing:(BOOL)continueEditing
{
    NSLog(@"finish edit range: %@", range);
    if (self.rangeUnderEdit) {
        [self.calendarView removeRange:self.rangeUnderEdit];
    }
    self.rangeUnderEdit = nil;
    
    
    
}

- (BOOL)calenderView:(GLCalendarView *)calendarView canUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    
    NSDateComponents *date1Components = [calendar components:comps
                                                    fromDate: beginDate];
    NSDateComponents *date2Components = [calendar components:comps
                                                    fromDate: [NSDate date]];
    NSDateComponents *date3Components = [calendar components:comps
                                                    fromDate: endDate];
    
    NSDate *date1 = [calendar dateFromComponents:date1Components];
    NSDate *date2 = [calendar dateFromComponents:date2Components];
    NSDate *date3 = [calendar dateFromComponents:date3Components];
    
    NSComparisonResult result = [date1 compare:date2];
    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedDescending) {
        
    }  else {
        //the same
    }
    NSLog(@"%@ -- %@", beginDate, endDate);
    
    NSComparisonResult result2 = [date1 compare:date3];
    if (result2 == NSOrderedAscending) {
        
    } else if (result2 == NSOrderedDescending) {
        
    }  else {
        //the same
        return NO;
    }
    
    
    
    
    

    return YES;
}

- (void)calenderView:(GLCalendarView *)calendarView didUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    NSLog(@"did update range: %@", range);
}
- (NSDate *) dateAtStartOfMonth
{
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    [comp setDay:1];
    return [[NSCalendar currentCalendar] dateFromComponents:comp];
}
- (NSDate *) dateAtEndOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDate * plusOneMonthDate = [self dateByAddingMonths: 3];
    NSDateComponents * plusOneMonthDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: plusOneMonthDate];
    NSDate * endOfMonth = [[calendar dateFromComponents: plusOneMonthDateComponents] dateByAddingTimeInterval: -1]; // One second before the start of next month
    
    return endOfMonth;
}

- (NSDate *) dateByAddingMonths: (NSInteger) monthsToAdd
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setMonth: monthsToAdd];
    
    return [calendar dateByAddingComponents: months toDate: [NSDate date] options: 0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 - (IBAction)deleteButtonPressed:(id)sender
 {
 if (self.rangeUnderEdit) {
 [self.calendarView removeRange:self.rangeUnderEdit];
 }
 }
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
