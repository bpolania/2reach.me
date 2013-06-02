//
//  messagingViewController.h
//  2reachme
//
//  Created by Boris Polania on 6/1/13.
//  Copyright (c) 2013 Boris Polania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BRRequestUpload.h"
#import "textViewController.h"

@interface messagingViewController : UIViewController <UITextViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, textViewControllerDelegate, UIActionSheetDelegate> {
    
    int selectedMessageType;
    
    BRRequestUpload *uploadFile;
    
    NSString *fromEmail;
    
    IBOutlet UITextField *host;
    IBOutlet UITextField *path;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    
    IBOutlet UITextView *logview;
    
    NSData *uploadData;

}

@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *recordPauseButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *stopButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, strong) IBOutlet UIToolbar *toolBar;
@property (nonatomic, strong) IBOutlet UIToolbar *topToolBar;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

- (IBAction)selectMessageType:(id)sender;
- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;
- (IBAction)showToolBar:(id)sender;
- (IBAction)uploadFile:(id)sender;

@end
