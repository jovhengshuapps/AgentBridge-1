//
//  ABridge_AgentInvitesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/10/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_AgentInvitesViewController.h"
#import "AgentProfile.h"

@interface ABridge_AgentInvitesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelInviteTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldZipcode;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
- (IBAction)sendInvite:(id)sender;

@property (assign, nonatomic) NSInteger numberOfInvites;

@end

@implementation ABridge_AgentInvitesViewController
@synthesize numberOfInvites;

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
    
    self.slidingViewController.underRightViewController = nil;
    
    self.labelInviteTitle.font = FONT_OPENSANS_REGULAR(FONT_SIZE_TITLE);
    self.textFieldFirstname.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldLastname.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldEmail.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldZipcode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSend.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    
    [self addPaddingAndBorder:self.textFieldEmail color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldFirstname color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldLastname color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldZipcode color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:&error];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"AgentProfile"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    error = nil;
    fetchedObjects = nil;
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    AgentProfile *profileData = nil;
    for (AgentProfile *profile in fetchedObjects) {
        if ([profile.user_id integerValue] == [[[fetchedObjects firstObject] valueForKey:@"user_id"] integerValue]) {
            profileData = profile;
            break;
        }
    }
    
    
    NSString *parameters = [NSString stringWithFormat:@"?profile_id=%@", profileData.profile_id];
    
    NSString *urlString = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/getinvites.php%@",parameters];
    
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setCompletionBlock:^{
        NSData *responseData = [request responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
        self.numberOfInvites = 10 - [[json objectForKey:@"data"] count];
        
        if (self.numberOfInvites < 1) {
            self.labelInviteTitle.text = [NSString stringWithFormat:@"You have used up all your invite credits.",self.numberOfInvites];
            [self.labelInviteTitle sizeToFit];
            
            self.textFieldEmail.hidden = YES;
            self.textFieldFirstname.hidden = YES;
            self.textFieldLastname.hidden = YES;
            self.textFieldZipcode.hidden = YES;
            self.buttonSend.hidden = YES;
        }
        else {
            
            self.labelInviteTitle.text = [NSString stringWithFormat:@"You may sponsor %i agents for membership.",self.numberOfInvites];
            [self.labelInviteTitle sizeToFit];
        }
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"25 error:%@",error);
        
    }];
    [request startAsynchronous];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendInvite:(id)sender {
}


- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}
@end
