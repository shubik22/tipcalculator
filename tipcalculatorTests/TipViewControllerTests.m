//
//  TipViewControllerTests.m
//  tipcalculator
//
//  Created by Sam Sweeney on 1/1/15.
//  Copyright (c) 2015 Wealthfront. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TipViewController.h"

@interface TipViewControllerTests : XCTestCase
@property (nonatomic) TipViewController *tvc;
@end

@implementation TipViewControllerTests

- (void)setUp
{
    [super setUp];
    NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultTipCalculatorValues" withExtension:@"plist"];
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];

    self.tvc = [[TipViewController alloc] init];
    [self.tvc view];
}

- (void)testLoadValues
{
    NSDecimalNumber *expectedAvgTip = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:0.15] decimalValue]];
    NSDecimalNumber *expectedGoodTip = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:0.20] decimalValue]];
    NSDecimalNumber *expectedExcellentTip = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:0.25] decimalValue]];

    NSDecimalNumber *expectedBillAmount = [NSDecimalNumber zero];
    
    [self.tvc loadValues];

    XCTAssertEqualObjects(self.tvc.billAmount, expectedBillAmount, @"billAmount has wrong default value");
    XCTAssertEqualObjects(self.tvc.tipPercentageAmounts[0], expectedAvgTip, @"averageTipAmount has wrong default value");
    XCTAssertEqualObjects(self.tvc.tipPercentageAmounts[1], expectedGoodTip, @"goodTipAmount has wrong default value");
    XCTAssertEqualObjects(self.tvc.tipPercentageAmounts[2], expectedExcellentTip, @"excellentTipAmount has wrong default value");
}

- (void)testUpdateLablelsWithoutRounding
{
    [self.tvc loadValues];
    self.tvc.billAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:10] decimalValue]];
    [self.tvc updateLabels];
    
    XCTAssertEqualObjects(self.tvc.billAmountLabel.text, @"$10.00", @"billAmountLabel.text isn't set");
    XCTAssertEqualObjects(self.tvc.tipLabel.text, @"$1.50", "tipLabel.text isn't set");
    XCTAssertEqualObjects(self.tvc.totalLabel.text, @"$11.50", "totalLabel.text isn't set");
    XCTAssertEqualObjects([self.tvc.tipControl titleForSegmentAtIndex:0], @"15%", @"averageTip isn't set");
    XCTAssertEqualObjects([self.tvc.tipControl titleForSegmentAtIndex:1], @"20%", @"goodTip isn't set");
    XCTAssertEqualObjects([self.tvc.tipControl titleForSegmentAtIndex:2], @"25%", @"excellentTip isn't set");
}

- (void)testUpdateLablelsWithRounding
{
    [self.tvc loadValues];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"roundTipAmount"];
    
    self.tvc.billAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:10] decimalValue]];
    [self.tvc updateLabels];

    XCTAssertEqualObjects(self.tvc.billAmountLabel.text, @"$10.00", @"billAmountLabel.text isn't set");
    XCTAssertEqualObjects(self.tvc.tipLabel.text, @"$2.00", "tipLabel.text isn't set");
    XCTAssertEqualObjects(self.tvc.totalLabel.text, @"$12.00", "totalLabel.text isn't set");
}

@end
