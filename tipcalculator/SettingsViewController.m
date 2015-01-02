//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Sam Sweeney on 12/28/14.
//  Copyright (c) 2014 Wealthfront. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (nonatomic) NSDecimalNumber *excellentTipAmount;
@property (nonatomic) NSDecimalNumber *goodTipAmount;
@property (nonatomic) NSDecimalNumber *averageTipAmount;

@property (weak, nonatomic) IBOutlet UILabel *excellentServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageServiceLabel;
@property (weak, nonatomic) IBOutlet UIButton *excellentUpButton;
@property (weak, nonatomic) IBOutlet UIButton *excellentDownButton;
@property (weak, nonatomic) IBOutlet UIButton *goodUpButton;
@property (weak, nonatomic) IBOutlet UIButton *goodDownButton;
@property (weak, nonatomic) IBOutlet UIButton *averageUpButton;
@property (weak, nonatomic) IBOutlet UIButton *averageDownButton;
@property (weak, nonatomic) IBOutlet UISwitch *roundAmountsSwitch;
@property (weak, nonatomic) IBOutlet UIButton *restoreDefaultsButton;

@end

@implementation SettingsViewController

static const float TIP_INCREMENT = 0.01;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        self.excellentTipAmount = [NSDecimalNumber decimalNumberWithDecimal: [[defaults objectForKey:@"excellentTipAmount"] decimalValue]];
        self.goodTipAmount = [NSDecimalNumber decimalNumberWithDecimal: [[defaults objectForKey:@"goodTipAmount"] decimalValue]];
        self.averageTipAmount = [NSDecimalNumber decimalNumberWithDecimal: [[defaults objectForKey:@"averageTipAmount"] decimalValue]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self updateTipLabels];
    [self updateRoundSwitch];
}

- (void)updateTipLabels {
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterPercentStyle];
    
    self.excellentServiceLabel.text = [nf stringFromNumber:self.excellentTipAmount];
    self.goodServiceLabel.text = [nf stringFromNumber:self.goodTipAmount];
    self.averageServiceLabel.text = [nf stringFromNumber:self.averageTipAmount];
}

- (void)updateRoundSwitch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL roundAmounts = [defaults boolForKey:@"roundTipAmount"];
    [self.roundAmountsSwitch setOn:roundAmounts animated:YES];
}

- (IBAction)excellentUpClicked:(id)sender {
    self.excellentTipAmount = [self.excellentTipAmount decimalNumberByAdding:[[self class] increment]];
    [self updateTipLabels];
    [self saveTipAmounts];
}

- (IBAction)excellentDownClicked:(id)sender {
    NSDecimalNumber *newExcellentTipAmount = [self.excellentTipAmount decimalNumberBySubtracting:[[self class] increment]];
    if ([newExcellentTipAmount compare:self.goodTipAmount] == NSOrderedDescending) {
        self.excellentTipAmount = newExcellentTipAmount;
        [self updateTipLabels];
        [self saveTipAmounts];
    }
}

- (IBAction)goodUpClicked:(id)sender {
    NSDecimalNumber *newGoodTipAmount = [self.goodTipAmount decimalNumberByAdding:[[self class] increment]];
    if ([newGoodTipAmount compare:self.excellentTipAmount] == NSOrderedAscending) {
        self.goodTipAmount = newGoodTipAmount;
        [self updateTipLabels];
        [self saveTipAmounts];
    }
}

- (IBAction)goodDownClicked:(id)sender {
    NSDecimalNumber *newGoodTipAmount = [self.goodTipAmount decimalNumberBySubtracting:[[self class] increment]];
    if ([newGoodTipAmount compare:self.averageTipAmount] == NSOrderedDescending) {
        self.goodTipAmount = newGoodTipAmount;
        [self updateTipLabels];
        [self saveTipAmounts];
    }
}

- (IBAction)averageUpClicked:(id)sender {
    NSDecimalNumber *newAverageTipAmount = [self.averageTipAmount decimalNumberByAdding:[[self class] increment]];
    if ([newAverageTipAmount compare:self.goodTipAmount] == NSOrderedAscending) {
        self.averageTipAmount = newAverageTipAmount;
        [self updateTipLabels];
        [self saveTipAmounts];
    }
}

- (IBAction)averageDownClicked:(id)sender {
    if ([self.averageTipAmount compare:[NSDecimalNumber zero]] == NSOrderedDescending) {
        self.averageTipAmount = [self.averageTipAmount decimalNumberBySubtracting:[[self class] increment]];
        [self updateTipLabels];
        [self saveTipAmounts];
    }
}

- (IBAction)roundAmountsClicked:(UISwitch *)sender {
    [self saveRoundAmounts:[sender isOn]];
    [self updateRoundSwitch];
}

- (void)saveTipAmounts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.excellentTipAmount forKey:@"excellentTipAmount"];
    [defaults setObject:self.goodTipAmount forKey:@"goodTipAmount"];
    [defaults setObject:self.averageTipAmount forKey:@"averageTipAmount"];
    [defaults synchronize];
}

- (void)saveRoundAmounts:(BOOL)roundAmounts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:roundAmounts forKey:@"roundTipAmount"];
    [defaults synchronize];
}

- (IBAction)restoreDefaultsClicked:(id)sender {
    self.averageTipAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:0.15] decimalValue]];
    self.goodTipAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:0.20] decimalValue]];
    self.excellentTipAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:0.25] decimalValue]];

    [self updateTipLabels];
    [self saveTipAmounts];
    
    [self saveRoundAmounts:NO];
    [self updateRoundSwitch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NSDecimalNumber*)increment {
    NSDecimalNumber *increment = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:TIP_INCREMENT] decimalValue]];
    return increment;
}

@end
