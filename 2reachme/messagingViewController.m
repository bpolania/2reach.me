//
//  messagingViewController.m
//  2reachme
//
//  Created by Boris Polania on 6/1/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import "messagingViewController.h"
#import "textViewController.h"

@interface messagingViewController () {
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@end

@implementation messagingViewController

@synthesize link, playButton, recordPauseButton, stopButton, toolBar, topToolBar, nameLabel;

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
            
            fromEmail = [object objectForKey:@"email"];;
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    NSString *trimmedLink = [link stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
    query = [PFQuery queryWithClassName:@"userInfo"];
    [query whereKey:@"linkCode" equalTo:trimmedLink];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            // The find succeeded.
            nameLabel.text = [object objectForKey:@"name"];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    //Audio Note
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (IBAction)recordPauseTapped:(id)sender {
    
    NSLog(@"NSL");
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [recordPauseButton setTitle:@"Pause"];
        
    } else {
        
        // Pause recording
        [recorder pause];
        [recordPauseButton setTitle:@"Record"];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender {
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playTapped:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectMessageType:(id)sender {
    
    switch ([sender tag]) {
        case 1: {
            selectedMessageType = 1;
            [self presentTextView];
            break; 
        }   
        case 2:{
            selectedMessageType = 2;
            [self presentTextView];
            break;
        }
        case 3:
            selectedMessageType = 3;
            break;
        default:
            break;
    }
}


- (void) presentTextView {
    
    textViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"text"];
    tvc.delegate = self;
    [tvc setMessageType:selectedMessageType];
    [tvc setLink:[link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    [self presentViewController:tvc animated:YES completion:nil];
    
}

- (IBAction)showToolBar:(id)sender {
    
    toolBar.hidden = NO;
    topToolBar.hidden = NO;
}

- (IBAction)hideToolBar:(id)sender {
    
    toolBar.hidden = YES;
    topToolBar.hidden = YES;
}

#pragma mark - AVAudio Delegate Methods

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"Record"];
    
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
}

#pragma mark - FTP 


- (IBAction)uploadFile:(id)sender
{
    //----- get the file to upload as an NSData object
   
    
    uploadData = [NSData dataWithContentsOfURL:recorder.url];
    
    uploadFile = [BRRequestUpload initWithDelegate: self];
    
    NSInteger randomNumber = arc4random() % 999999;
    
    uploadFile.path = [NSString stringWithFormat:@"/htdocs/%@-%i.m4a",[[PFUser currentUser] objectForKey:@"username"],randomNumber];
    uploadFile.hostname = @"www.borispolania.com";
    uploadFile.username = @"ftp1792275";
    uploadFile.password = @"a12a12Fru3kH";
    
    [uploadFile start];
    
    NSString *trimmedLink = [link stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"userInfo"];
    [query whereKey:@"linkCode" equalTo:trimmedLink];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            // The find succeeded.
            [PFCloud callFunctionInBackground:@"register"
                               withParameters:@{@"toEmail":[object objectForKey:@"email"], @"text":[NSString stringWithFormat:@"http://www.borispolania.com/%@-%i.m4a",[[PFUser currentUser] objectForKey:@"username"],randomNumber], @"fromEmail":fromEmail}
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

- (NSData *) requestDataToSend: (BRRequestUpload *) request
{
    //----- returns data object or nil when complete
    //----- basically, first time we return the pointer to the NSData.
    //----- and BR will upload the data.
    //----- Second time we return nil which means no more data to send
    NSData *temp = uploadData;                                                  // this is a shallow copy of the pointer, not a deep copy
    
    uploadData = nil;                                                           // next time around, return nil...
    
    return temp;
}


-(void) requestCompleted: (BRRequest *) request
{

    
    if (request == uploadFile)
    {
        NSLog(@"%@ completed!", request);
        uploadFile = nil;
    }
        
}

-(void) requestFailed:(BRRequest *) request
{
    
    if (request == uploadFile)
    {
        NSLog(@"%@", request.error.message);
        
        uploadFile = nil;
    }
    
}

#pragma mark - Text Controller Delegate Methods

-(void)dismiss:(textViewController *)textViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
