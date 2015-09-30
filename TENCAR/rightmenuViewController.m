//
//  rightmenuViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 21.07.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "rightmenuViewController.h"

@interface rightmenuViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *topsegment;
@property (weak, nonatomic) IBOutlet UITableView *msgTablevie;

@end

@implementation rightmenuViewController

@synthesize topsegment;
@synthesize msgTablevie;

NSArray *tableData1;
NSArray *thumbnails1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    msgTablevie.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    tableData1 = [NSArray arrayWithObjects:NSLocalizedStringFromTable(@"Dashboard", @"Main", nil), NSLocalizedStringFromTable(@"Rent car", @"Main", nil), NSLocalizedStringFromTable(@"Rent history", @"Main", nil), NSLocalizedStringFromTable(@"Fines", @"Main", nil), NSLocalizedStringFromTable(@"Balance", @"Main", nil), NSLocalizedStringFromTable(@"Bonuses", @"Main", nil), NSLocalizedStringFromTable(@"Settings", @"Main", nil), NSLocalizedStringFromTable(@"Help", @"Main", nil), nil];
    
    // Initialize thumbnails
    thumbnails1 = [NSArray arrayWithObjects:@"dashboard", @"renticon", @"renthistory", @"rollover", @"balance", @"bonusicon", @"settings", @"help", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableData1 count];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    BOOL bIsLastRow = NO;
    
    //Add logic to check last row for your data source
    NSDictionary *dict = [tableData1 objectAtIndex:indexPath.row];
    if([tableData1 lastObject] == dict)
    {
        bIsLastRow = YES;
    }
    
    //Set last row separate inset left value large, so it will go outside of view
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, bIsLastRow ? 1000 :0, 0, 0)];
    }
    
    [cell setBackgroundColor:[self colorFromHexString:@"#484746"]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    
    
    
    //UIView *bgColorView = [[UIView alloc] init];
    //bgColorView.backgroundColor = [self colorFromHexString:@"#3A3839"];//F3E638
    
    
    
    
    //[cell setSelectedBackgroundView:bgColorView];
    
    
    UIImageView *menuImageView = (UIImageView *)[cell viewWithTag:100];
    menuImageView.image = [UIImage imageNamed:[thumbnails1 objectAtIndex:indexPath.row]];
    
    UILabel *menuNameLabel = (UILabel *)[cell viewWithTag:101];
    menuNameLabel.text = [tableData1 objectAtIndex:indexPath.row];
    
    
    return cell;
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [self colorFromHexString:@"#3A3839"];
    cell.selectedBackgroundView = selectionColor;
    //71
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
    separatorLineView.backgroundColor = [self colorFromHexString:@"#6D6C6B"];
    [cell.selectedBackgroundView addSubview:separatorLineView];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, cell.frame.size.width, 1)];
    separatorLineView1.backgroundColor = [self colorFromHexString:@"#6D6C6B"];
    [cell.selectedBackgroundView addSubview:separatorLineView1];
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
