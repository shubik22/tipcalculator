//
//  BillAmountViewController.m
//  tipcalculator
//
//  Created by Sam Sweeney on 12/27/14.
//  Copyright (c) 2014 Wealthfront. All rights reserved.
//

#import "BillAmountViewController.h"

@interface BillAmountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *billAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *numericButtons;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic) NSDecimalNumber *billAmount;

@end

@implementation BillAmountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.billAmount = [NSDecimalNumber zero];
    }
    return self;
}

- (IBAction)numericButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self updateBillAmount:[button currentTitle]];
    [self updateBillAmountLabel];
}

- (IBAction)deleteButtonClicked:(id)sender {
    [self deleteBillAmountDigit];
    [self updateBillAmountLabel];
}

- (void)updateBillAmount:(NSString*)newDigit {
    NSDecimalNumber *newDigitAsCents = [[NSDecimalNumber decimalNumberWithString:newDigit] decimalNumberByMultiplyingByPowerOf10:-2];
    self.billAmount = [[self.billAmount decimalNumberByMultiplyingByPowerOf10:1] decimalNumberByAdding:newDigitAsCents];
}

- (void)deleteBillAmountDigit {
    NSDecimalNumberHandler *numberHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    self.billAmount = [self.billAmount decimalNumberByMultiplyingByPowerOf10:-1 withBehavior:numberHandler];
}

- (void)updateBillAmountLabel {
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.billAmountLabel.text = [nf stringFromNumber:self.billAmount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateBillAmountLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
