//
//  ABridge_ActivityPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ActivityPagesViewController.h"
#import "ABridge_BuyerViewController.h"
#import "Constants.h"

@interface ABridge_ActivityPagesViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UILabel *labelActivityName;
@property (weak, nonatomic) IBOutlet UILabel *labelDateTime;
@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ABridge_ActivityPagesViewController
@synthesize index;
@synthesize activityDetail;

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
    // Do any additional setup after loading the view from its nib.
    
    self.labelActivityName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelDateTime.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
//    self.textViewMessage.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.viewTop.frame.size.height - 1.0f, self.viewTop.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f].CGColor;
    
    [self.viewTop.layer addSublayer:bottomBorder];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        NSMutableString *buyer_name = [NSMutableString stringWithString:self.activityDetail.buyer_name];
//        [buyer_name replaceOccurrencesOfString:@" " withString:@"|" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [buyer_name length])];
        
        NSString *buyer_name = [NSString stringWithFormat:@"<a href='http://%@'>%@</a>",self.activityDetail.buyer_id, self.activityDetail.buyer_name];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labelDateTime.text = self.activityDetail.date;
        });
        
            NSString *message = @"";
        if ([self.activityDetail.activity_type integerValue] == 25) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelActivityName.text = @"Buyer Match";
            });
                if ([self.activityDetail.other_user_id integerValue] == [self.activityDetail.user_id integerValue]) {
//                    self.textViewMessage.text = [NSString stringWithFormat:@"Your POPs™, %@, is a match to your buyer, [|%@|]", self.activityDetail.property_name, buyer_name];
                    message = [NSString stringWithFormat:@"Your POPs™, %@, is a match to your buyer, %@", self.activityDetail.property_name, buyer_name];
                }
                else {
//                    self.textViewMessage.text = [NSString stringWithFormat:@"%@ POPs™, %@, is a match to your buyer, [|%@|]",self.activityDetail.other_user_name, self.activityDetail.property_name, buyer_name];
                    message = [NSString stringWithFormat:@"%@ POPs™, %@, is a match to your buyer, %@",self.activityDetail.other_user_name, self.activityDetail.property_name, buyer_name];
                }
            }
            
            NSString *htmlString = [NSString stringWithFormat:@"<html><head><style>body{font-family:'OpenSans'}</style></head><body>%@</body></html>", message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:htmlString baseURL:nil];
        });
            
//            [self addButtonToMessage];
        
        if (self.activityDetail.image_data == nil) {
            self.activityDetail.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.activityDetail.image]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imagePicture.image = [UIImage imageWithData:self.activityDetail.image_data];
        });
    });
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) addButtonToMessage {
//    NSMutableString *text = [NSMutableString stringWithString:self.textViewMessage.text];
//    NSInteger location = [text rangeOfString:@"[|"].location+2;
//    NSInteger length = [text rangeOfString:@"|]"].location - location;
//    NSMutableString *string = [NSMutableString stringWithString:[text substringWithRange:NSMakeRange(location, length)]];
//    NSLog(@"string:%@",string);
//    
//    NSRange range = [text rangeOfString:string];
//    
//    UITextPosition *beginning = self.textViewMessage.beginningOfDocument;
//    UITextPosition *start = [self.textViewMessage positionFromPosition:beginning offset:range.location];
////    UITextPosition *end = [self.textViewMessage positionFromPosition:start offset:range.length];
//    CGRect caretFrameStart = [self.textViewMessage caretRectForPosition:start];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
//    [button setTitleColor:[UIColor colorWithRed:44.0f/255.0f green:153.0f/255.0f blue:206.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor blackColor];
//    button.frame = caretFrameStart;
//    CGRect frame = button.frame;
//    frame.size.width = range.length * 8.0f;
//    frame.size.height += 10.0f;
//    frame.origin.x -= 15.0f;
//    button.frame = frame;
//    [self.textViewMessage addSubview:button];
//    
//    [text replaceOccurrencesOfString:string withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
//    
//    [text replaceOccurrencesOfString:@"[|" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
//    
//    [text replaceOccurrencesOfString:@"|]" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
//    
//    self.textViewMessage.text = text;
//    
//    [string replaceOccurrencesOfString:@"|" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
//    
//    [button setTitle:string forState:UIControlStateNormal];
//}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* url = [[request URL] absoluteString];
    if (UIWebViewNavigationTypeLinkClicked == navigationType)
    {
        [self.tabBarController setSelectedIndex:2];
        NSString *newURL = [url substringToIndex:[url length]-1];
        NSLog(@"url:%@",[newURL substringFromIndex:7]);
        ABridge_BuyerViewController *viewController = ((ABridge_BuyerViewController*)((UINavigationController*)self.tabBarController.selectedViewController).viewControllers[0]);
        [viewController scrollToBuyer:[newURL substringFromIndex:7]];
    }
    return YES;
}

@end
