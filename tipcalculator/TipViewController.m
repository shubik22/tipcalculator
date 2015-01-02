//
//  TipViewController.m
//  tipcalculator
//
//  Created by Sam Sweeney on 12/27/14.
//  Copyright (c) 2014 Wealthfront. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"
#import "BillAmountViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UIButton *editBillAmountButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tippr";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadValues];
    [self updateLabels];
}

- (IBAction)editTipAmount:(id)sender {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadValues {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.billAmount = [NSDecimalNumber decimalNumberWithDecimal:[[defaults objectForKey:@"billAmount"] decimalValue]];
    
    NSDecimalNumber *averageTipAmount = [NSDecimalNumber decimalNumberWithDecimal:[[defaults objectForKey:@"averageTipAmount"] decimalValue]];
    NSDecimalNumber *goodTipAmount = [NSDecimalNumber decimalNumberWithDecimal:[[defaults objectForKey:@"goodTipAmount"] decimalValue]];
    NSDecimalNumber *excellentTipAmount = [NSDecimalNumber decimalNumberWithDecimal:[[defaults objectForKey:@"excellentTipAmount"] decimalValue]];
    
    self.tipPercentageAmounts = @[averageTipAmount, goodTipAmount, excellentTipAmount];
}

- (void)updateLabels {
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSDecimalNumber *tipPercentage = self.tipPercentageAmounts[self.tipControl.selectedSegmentIndex];
    NSDecimalNumber *tipAmount;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"roundTipAmount"]) {
        NSDecimalNumberHandler *behavior = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundUp scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        tipAmount =  [self.billAmount decimalNumberByMultiplyingBy:tipPercentage withBehavior:behavior];
    } else {
        tipAmount =  [self.billAmount decimalNumberByMultiplyingBy:tipPercentage];
    }
    
    NSDecimalNumber *totalAmount = [tipAmount decimalNumberByAdding:self.billAmount];

    self.billAmountLabel.text = [nf stringFromNumber:self.billAmount];
    self.tipLabel.text = [nf stringFromNumber:tipAmount];
    self.totalLabel.text = [nf stringFromNumber:totalAmount];
    
    [nf setNumberStyle:NSNumberFormatterPercentStyle];
    for (int i = 0; i <= 2; i++) {
        [self.tipControl setTitle:[nf stringFromNumber:self.tipPercentageAmounts[i]] forSegmentAtIndex:i];
    }
}

- (IBAction)tipPercentageChanged:(id)sender {
    [self updateLabels];
}

- (IBAction)resetButtonClicked:(id)sender {
    self.billAmount = [NSDecimalNumber zero];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.billAmount forKey:@"billAmount"];
    [defaults synchronize];
    
    [self.tipControl setSelectedSegmentIndex:0];
    
    [self updateLabels];
}

- (IBAction)editBillAmount:(id)sender {
    [self.navigationController pushViewController:[[BillAmountViewController alloc] init] animated:NO];
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:NO];
}
@end
