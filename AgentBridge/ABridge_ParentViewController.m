//
//  ABridge_ParentViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"

@interface ABridge_ParentViewController ()
@property (strong, nonatomic) UIView *viewOverlay;
@end

@implementation ABridge_ParentViewController
@synthesize arrayOfURLConnection;
@synthesize imageViewTopBar;

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
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[ABridge_MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[ABridge_SearchViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    }
    
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.imageViewTopBar addGestureRecognizer:self.slidingViewController.panGesture];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    for (NSURLConnection *urlConnection in self.arrayOfURLConnection) {
        [urlConnection cancel];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealSearch:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (NSURLConnection *)urlConnectionWithURLString:(NSString *)urlString andParameters:(NSString *)parameters {
    NSMutableString *urlString_ = [NSMutableString stringWithString:urlString];
    [urlString_ appendString:parameters];
    NSLog(@"url:%@",urlString);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString_]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
}

- (void)addURLConnection:(NSURLConnection*)urlConnection {
    if (self.arrayOfURLConnection == nil) {
        self.arrayOfURLConnection = [[NSMutableArray alloc] init];
    }
    
    [self.arrayOfURLConnection addObject:urlConnection];
}

- (NSArray *)fetchObjectsWithEntityName:(NSString *)entity andPredicate:(NSPredicate *)predicate {
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:context]];
    NSError * error = nil;
    NSArray * results = [context executeFetchRequest:fetchRequest error:&error];
    return results;
}
    
-(IBAction)goBackToRoot:(id)sender {
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:nil onComplete:^{
        [((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]) resetWindowToInitialView];
    }];
}

- (void) showOverlayWithMessage:(NSString*) message withIndicator:(BOOL) with_indicator{
    [self dismissOverlay];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, (with_indicator)?30.0f:20.0f, 200.0f, 30.0f)];
    label.text = message;
    label.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_OPENSANS_REGULAR(20.0f);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    [label sizeToFit];
    
    CGRect frame = label.frame;
    frame.size.width = 200.0f;
    label.frame = frame;
    
    self.viewOverlay = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, (label.frame.origin.y + label.frame.size.height + 20.0f))];
    self.viewOverlay.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    self.viewOverlay.layer.cornerRadius = 10.0f;
    self.viewOverlay.layer.masksToBounds = YES;
    
    [self.viewOverlay addSubview:label];
    
    self.viewOverlay.center = self.view.center;
    
    if (with_indicator) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.center = self.viewOverlay.center;
        activityIndicator.frame = CGRectMake(activityIndicator.frame.origin.x, 5.0f, 20.0f, 20.0f);
        [activityIndicator startAnimating];
        
        [self.viewOverlay addSubview:activityIndicator];
    }
    
    UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOverlay)];
    tapToClose.numberOfTapsRequired = 1;
    tapToClose.numberOfTouchesRequired = 1;
    
    [self.viewOverlay addGestureRecognizer:tapToClose];
    
    [self.view addSubview:self.viewOverlay];
}

- (void) dismissOverlay {
    self.viewOverlay.hidden = YES;
    [self.viewOverlay removeFromSuperview];
    self.viewOverlay = nil;
}
@end
