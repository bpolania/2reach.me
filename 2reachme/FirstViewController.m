//
//  FirstViewController.m
//  2reachme
//
//  Created by Boris Polania on 6/1/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import "FirstViewController.h"
#import "UserInfoViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize userTextField, passwordTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
    
    UIImageView*imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
    [imageView setImage:[UIImage imageNamed:@"splash.png"]];
    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:imageView];

    
    //now fade out splash image
    [UIView transitionWithView:self.view duration:5.0f options:UIViewAnimationOptionTransitionNone animations:^(void){imageView.alpha=0.0f;} completion:^(BOOL finished){[imageView removeFromSuperview];}];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signup:(id)sender {
    
    [self performSegueWithIdentifier:@"signup" sender:nil];
}

#pragma mark - login

- (IBAction)login {
    
    [self closeKeyboard:nil];
    
    [PFUser logInWithUsernameInBackground:userTextField.text password:passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            PFQuery *query = [PFQuery queryWithClassName:@"userInfo"];
                                            [query whereKey:@"user" equalTo:user];
                                            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                                if (!error) {
                                                    // The find succeeded.
                                                    NSLog(@"Successfully retrieved %d scores.", objects.count);
                                                    if (objects.count > 0) {
                                                        [self performSegueWithIdentifier:@"loggedIn" sender:nil];
                                                    } else {
                                                        UserInfoViewController *userInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfo"];
                                                        userInfoView.delegate = self;
                                                        [self presentViewController:userInfoView animated:YES completion: nil];
                                                    }
                                                } else {
                                                    // Log details of the failure
                                                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                                                }
                                            }];
                                            
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }];
}

#pragma mark - UITextField Delegate Methods

- (IBAction)closeKeyboard:(id)sender {
    
    [userTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self login];
    
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
#pragma mark - User Info Controller Delegate Methods

-(void)dismiss:(UserInfoViewController *)userInfoViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"loggedIn" sender:nil];
    
}


-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}



@end


