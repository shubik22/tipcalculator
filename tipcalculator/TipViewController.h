//
//  TipViewController.h
//  tipcalculator
//
//  Created by Sam Sweeney on 12/27/14.
//  Copyright (c) 2014 Wealthfront. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *billAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (nonatomic) NSDecimalNumber *billAmount;
@property (nonatomic) NSArray *tipPercentageAmounts;
- (void)loadValues;
- (void)updateLabels;

@end
