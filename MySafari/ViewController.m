//
//  ViewController.m
//  MySafari
//
//  Created by Mohamed Ayadi on 5/24/16.
//  Copyright © 2016 Mohamed Ayadi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property (nonatomic) CGFloat lastContentOffSet;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property bool scroll;
@property NSString *currentURL;
@property float  scrollOffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backButton setEnabled:NO];
    [self.forwardButton setEnabled:NO];
    self.webView.scrollView.delegate = self;
    
    
    
}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    self.scroll =YES;
//    NSLog(@"scrollwillbegindragging");
//}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    NSLog(@"scroll offset is: %f", scrollView.contentOffset.y);
    if(scrollView.contentOffset.y <0)
    {
        self.urlTextField.alpha = 1.0;

    }
    
    if (self.lastContentOffSet > scrollView.contentOffset.y) {
        
        self.urlTextField.alpha = 1.0;

    } else {
        self.urlTextField.alpha = 0.3;

    }


    self.lastContentOffSet = scrollView.contentOffset.y;
}

- (IBAction)buttonView:(id)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Coming Soon" message:@"New feature is coming soon!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];

}


-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.activityIndicator stopAnimating];
    [self.backButton setEnabled:[self.webView canGoBack]];
    [self.forwardButton setEnabled:[self.webView canGoForward]];
    
    
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"%@", theTitle);

}

-(void)loadWebPage:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField.text hasPrefix:@"http://"]) {
        [self loadWebPage:textField.text];
    } else {
        // append http:// as prefix
        NSString *prefix = @"http://";
        NSString *newURL = [prefix stringByAppendingString:textField.text];
        [self loadWebPage:newURL];
        self.urlTextField.text = newURL.lowercaseString;
    }

    
    return YES;
    
}
- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
    
    
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
    self.currentURL = self.webView.request.URL.absoluteString;
    NSLog(@"webviewdidstartload currenturl - %@" ,self.currentURL);
    self.urlTextField.text = self.currentURL;
    
}
- (IBAction)onstopLoadingPressed:(id)sender {
    [self.webView stopLoading];
    
}
- (IBAction)onReloadButtonPressed:(id)sender {
    
    [self.webView reload];
}


- (IBAction)onBackButtonPressed:(id)sender {

    
 
    [self.webView goBack];
    
    
    


}

@end
