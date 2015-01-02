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
@property (weak, nonatomic) IBOutlet UIButton *oneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *twoNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *threeNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *fourNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *sixNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *sevenNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *eightNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *nineNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroNumberButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) NSDecimalNumber *billAmount;

@end

@implementation BillAmountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *savedBillAmount = [defaults objectForKey:@"billAmount"];
        self.billAmount = [NSDecimalNumber decimalNumberWithDecimal:[savedBillAmount decimalValue]];
    }
    return self;
}

- (IBAction)numericButtonClicked:(UIButton *)sender {
    [self updateBillAmount:[sender currentTitle]];
    [self updateBillAmountLabel];
}

- (IBAction)deleteButtonClicked:(id)sender {
    [self deleteBillAmountDigit];
    [self updateBillAmountLabel];
}

- (void)updateBillAmount:(NSString*)newDigit {
    NSDecimalNumber *newDigitAsCents = [[NSDecimalNumber decimalNumberWithString:newDigit] decimalNumberByMultiplyingByPowerOf10:-2];
    self.billAmount = [[self.billAmount decimalNumberByMultiplyingByPowerOf10:1] decimalNumberByAdding:newDigitAsCents];
    [self saveBillAmount];
}

- (void)deleteBillAmountDigit {
    NSDecimalNumberHandler *numberHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    self.billAmount = [self.billAmount decimalNumberByMultiplyingByPowerOf10:-1 withBehavior:numberHandler];
    [self saveBillAmount];
}

- (void)updateBillAmountLabel {
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.billAmountLabel.text = [nf stringFromNumber:self.billAmount];
}

- (void)saveBillAmount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.billAmount forKey:@"billAmount"];
    [defaults synchronize];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self updateBillAmountLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
