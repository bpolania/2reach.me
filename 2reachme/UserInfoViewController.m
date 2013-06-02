//
//  UserInfoViewController.m
//  2reachme
//
//  Created by Boris Polania on 6/1/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

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
    
    receivedData = [[NSMutableData alloc] init];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save {
    
    [self getCode];
    
    [self closeKeyboard:nil];
    
    
}


- (void)getCode {
    
    NSString *address = @"http://www.random.org/strings/?num=1&len=12&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new";
    
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:address]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    urlConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
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

#pragma NSURLConnection Delegate Methods

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    // Access has failed two times...
    if ([challenge previousFailureCount] > 1)
    {
        
        UIAlertView *authAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
                                                            message:@"Too many unsuccessul login attempts."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [authAlert show];
        
    }
    else
    {
        // Answer the challenge
        
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Connection success.");
    
    NSLog(@"T:%@",theResponse);
    
    PFObject *info = [PFObject objectWithClassName:@"userInfo"];
    [info setObject:[PFUser currentUser] forKey:@"user"];
    [info setObject:emailTextField.text forKey:@"email"];
    [info setObject:nameTextField.text forKey:@"name"];
    [info setObject:phoneTextField.text forKey:@"phone"];
    [info setObject:theResponse forKey:@"linkCode"];
    [info save];
    
    [self.delegate dismiss:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failure.");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    
    theResponse = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSUTF8StringEncoding];
    
    
    
    /*
     theFormatter = [[StripeDataSetStringFormatter alloc] init];
     [theFormatter formatDataSet:theResponse];
     */
    
}


@end
