//
//  TipViewController.m
//  tipcalculator
//
//  Created by Sam Sweeney on 12/27/14.
//  Copyright (c) 2014 Wealthfront. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (nonatomic) NSDecimalNumber *billAmount;

- (IBAction)onTap:(id)sender;
- (void)updateVales;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateBillAmountField];
    [self updateVales];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:(YES)];
    [self updateVales];
}

- (void)updateBillAmountField {
    if (!self.billAmount) {
        self.billAmount = [NSDecimalNumber zero];
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    self.billTextField.text = [numberFormatter stringFromNumber:self.billAmount];
}

- (void)updateVales {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSArray *tipValues = @[[[NSDecimalNumber alloc] initWithDouble:0.15],
                           [[NSDecimalNumber alloc] initWithDouble:0.20],
                           [[NSDecimalNumber alloc] initWithDouble:0.25]];
    
    NSDecimalNumber *tipPercentage = tipValues[self.tipControl.selectedSegmentIndex];
    NSDecimalNumber *tipAmount =  [self.billAmount decimalNumberByMultiplyingBy:tipPercentage];
    NSDecimalNumber *totalAmount = [tipAmount decimalNumberByAdding:self.billAmount];
    
    self.tipLabel.text = [numberFormatter stringFromNumber:tipAmount];
    self.totalLabel.text = [numberFormatter stringFromNumber:totalAmount];
}
@end
