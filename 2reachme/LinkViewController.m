//
//  LinkViewController.m
//  2reachme
//
//  Created by Boris Polania on 6/1/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import "LinkViewController.h"


@interface LinkViewController ()

@end

@implementation LinkViewController

@synthesize linkLabel;

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
            linkLabel.text = [NSString stringWithFormat:@"http://2reach.me/%@",[object objectForKey:@"linkCode"]];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)config:(id)sender {
    
    configViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"config"];
    cvc.delegate = self;
    [self.navigationController presentViewController:cvc animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeLink:(id)sender {
    
    NSString *address = @"http://www.random.org/strings/?num=1&len=12&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new";
    
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:address]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    urlConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
}

- (IBAction)share:(id)sender {
    
    NSString *shareString = linkLabel.text;
    UIImage *shareImage = [UIImage imageNamed:@"logo.jpg"];
    NSURL *shareUrl = [NSURL URLWithString:@"http://www.2share.me"];
    
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, shareUrl, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"userInfo"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            [object setObject:theResponse forKey:@"linkCode"];
            [object save];
            linkLabel.text = [NSString stringWithFormat:@"http://2reach.me/%@",theResponse];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
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

#pragma mark - Config Controller Delegate Methods

-(void)dismiss:(configViewController *)configViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
