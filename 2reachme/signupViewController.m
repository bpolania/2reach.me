//
//  signupViewController.m
//  2reachme
//
//  Created by Boris Polania on 6/2/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import "signupViewController.h"

@interface signupViewController ()

@end

@implementation signupViewController

@synthesize phoneTextField, nameTextField, emailTextField, passwordTextField, usernameTextField;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
