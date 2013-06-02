//
//  textViewController.m
//  2reachme
//
//  Created by Boris Polania on 6/2/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import "textViewController.h"

@interface textViewController ()

@end

@implementation textViewController

@synthesize textView, messageType, link, delegate;

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
    [textView becomeFirstResponder];
    
    PFQuery *query = [PFQuery queryWithClassName:@"userInfo"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            fromEmail = [object objectForKey:@"email"];
            fromPhone = [object objectForKey:@"phone"];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)send:(id)sender {
    
    switch (messageType) {
        case 1:
            [self sendMail];
            break;
        case 2:
            [self sendSMS];
            break;
        default:
            break;
    }
    
}

- (void)sendMail {
    
    [self.delegate dismiss:self];
    
    PFQuery *query = [PFQuery queryWithClassName:@"userInfo"];
    [query whereKey:@"linkCode" equalTo:link];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            [PFCloud callFunctionInBackground:@"register"
                               withParameters:@{@"toEmail":[object objectForKey:@"email"], @"text":textView.text, @"fromEmail":fromEmail}
                                        block:^(NSString *result, NSError *error) {
                                            if (!error) {
                                                // result is @"Hello world!"
                                                NSLog(@"%@",error);
                                            }
                                        }];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

- (void)sendSMS {
    
    [self.delegate dismiss:self];
    
    NSString *trimmedLink = [link stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"userInfo"];
    [query whereKey:@"linkCode" equalTo:trimmedLink];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            NSLog(@"toNumber%@",[object objectForKey:@"phone"]);
            NSLog(@"fromNumber%@",fromPhone);
            
            [PFCloud callFunctionInBackground:@"inviteWithTwilio"
                               withParameters:@{ @"toNumber" : [object objectForKey:@"phone"], @"fromNumber" : fromPhone, @"text":textView.text }
                                        block:^(id object, NSError *error) {
                                            
                                        }];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

- (IBAction) dismissTextView:(id)sender {
    
    [self.delegate dismiss:self];
}

@end
