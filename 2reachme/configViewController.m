//
//  configViewController.m
//  2reachme
//
//  Created by Boris Polania on 6/2/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import "configViewController.h"

@interface configViewController ()

@end

@implementation configViewController

@synthesize phoneTextField, nameTextField, emailTextField, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    PFQuery *query = [PFQuery queryWithClassName:@"userInfo"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            phoneTextField.text = [object objectForKey:@"phone"];
            nameTextField.text  = [object objectForKey:@"name"];
            emailTextField.text = [object objectForKey:@"email"];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)save:(id)sender {
    
    PFQuery *query = [PFQuery queryWithClassName:@"userInfo"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            [object setObject:phoneTextField.text forKey:@"phone"];
            [object setObject:nameTextField.text forKey:@"name"];
            [object setObject:emailTextField.text forKey:@"email"];
            
            [object save];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [self.delegate dismiss:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate Methods

- (IBAction)closeKeyboard:(id)sender {
    
    [phoneTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect start, end;
    
    // position of keyboard before animation
    [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&start];
    // and after..
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&end];
    
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    // slide view up..
    [UIView beginAnimations:@"foo" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    self.view.frame = CGRectMake(0, -end.size.width +300, 480, 360);
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)notification {
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    // slide view down
    [UIView beginAnimations:@"foo" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    self.view.frame = CGRectMake(0, 0, 480, 360);
    [UIView commitAnimations];
}


@end
