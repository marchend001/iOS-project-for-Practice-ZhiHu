//
//  StoryContenViewController.m
//  ZhiHu
//
//  Created by Marchend on 2017/6/30.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "StoryContenViewController.h"
#import "ContentHeaderView.h"
#import "StoryContentViewModel.h"


@interface StoryContenViewController ()<UIWebViewDelegate>


//@property (nonatomic,strong)UIImageView *topImage;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSURLSession *session;
//@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSURL *imageURLString;
@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *imageSourceString;

@property (nonatomic,strong)StoryContentViewModel *viewModel;



@end


@implementation StoryContenViewController

- (void)setId:(NSNumber *)id {
    _id = id;
    self.url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/3/news/%@", id.stringValue];

    
}

- (UIWebView *) webView{
    
    if(!_webView){
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        _webView = web;
    }
    return _webView;
}

- (StoryContentViewModel *)viewModel {
    
    if(!_viewModel){
        _viewModel = [[StoryContentViewModel alloc]init];
    }
    return _viewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    //[self loadData];
    [self loadDataRAC];
}


- (void)loadDataRAC {
    RACSignal *signal = [self.viewModel.fetchStoryContentCommand execute:self.id.stringValue];
    @weakify(self);
    [signal subscribeNext:^(id x){
        //if(responseObject){
        NSLog(@"2=====");
        @strongify(self);
        NSDictionary *responseObject = x;
            self.htmlString = [self generateWebPageFromDictionary:responseObject];
            self.titleString = responseObject[@"title"];
            self.imageSourceString = responseObject[@"image_source"];
            // Assume image exist
            self.imageURLString = [NSURL URLWithString:responseObject[@"image"]];
            //NSString *imageURLString = responseObject[@"image"];
            
            [self.webView loadHTMLString:self.htmlString baseURL:nil];
            
            if(self.imageURLString){
                
                
                ContentHeaderView *headerView = [[ContentHeaderView alloc] init];
                
                CGRect headerFrame = CGRectMake(0, 0, self.webView.frame.size.width, 220);
                headerView.frame = headerFrame;
                [headerView.imageView sd_setImageWithURL:self.imageURLString placeholderImage:[UIImage imageNamed:@"shedow"]];
                headerView.title.text = self.titleString;
                headerView.imageSource.text = self.imageSourceString;
                [self.webView.scrollView addSubview:headerView];
            }
            
            
            
        
    }];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString *)generateWebPageFromDictionary:(NSDictionary *)dictionary {
    NSString *htmlBodyString = dictionary[@"body"];
    NSString *cssURLString = dictionary[@"css"][0];
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=%@ /></head><body>%@</body></html>", cssURLString, htmlBodyString];
    return htmlString;
}

@end
