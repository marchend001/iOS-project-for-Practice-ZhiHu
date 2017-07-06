//
//  MainViewController.m
//  ZhiHu
//
//  Created by Marchend on 2017/5/4.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "MainViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "StoryTableViewCell.h"
#import "StoryContenViewController.h"
#import "Story.h"
#import "TopStoryView.h"

@interface MainViewController (){
    NSString *url;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *stories;
@property (nonatomic,strong)NSMutableArray *topstories;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"知乎";
    }
    //self.title = @"知乎";
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = UIColor.blueColor;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    //self.stories = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[StoryTableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.view addSubview:self.tableView];
    [self loadData];
}


-(void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    url = @"http://news-at.zhihu.com/api/4/stories/latest?client=0";
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        if(responseObject){

            NSArray *story = [responseObject valueForKeyPath:@"stories"];
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary *item in story){
                NSArray *image = [item objectForKey:@"images"];
                Story *s = [[Story alloc]initWithTitle:[item objectForKey:@"title" ] image:[image objectAtIndex:0]];
                s.id = [item objectForKey:@"id"];
                [array addObject:s];

            }
            self.stories = array;
            
            NSArray *topstory = [responseObject valueForKeyPath:@"top_stories"];
            NSMutableArray * array2 = [NSMutableArray array];
            for (NSDictionary *item in topstory){
                //NSArray *image = [item objectForKey:@"images"];
                Story *s = [[Story alloc]initWithTitle:[item objectForKey:@"title" ] image:[item objectForKey:@"image"]];
                s.id = [item objectForKey:@"id"];
                [array2 addObject:s];
                
            }
            self.topstories = array2;
            
            
            [self.tableView reloadData];

        } else {
            NSLog(@"暂无数据");
        }
        
    }failure:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
    }];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
   // NSLog(@"my table = %@", self.tableView);
    [self.tableView reloadData];
    //NSLog(@"my table = %@", self.tableView);
}






#pragma mark - tableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"data:%@",self.stories);
    NSLog(@"%lu",(unsigned long)self.stories.count);
    if(section == 0){
        return 1;
    }
    else{
        return self.stories.count;
        //return 5;

    }
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if(indexPath.section == 0){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        //cell = UITableView
        //cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        //[UITableViewCellSelectionStyle none];
        cell.clipsToBounds = true;
        
        if (self.topstories.count > 0){
            CGFloat width = self.view.frame.size.width;
            CGRect slideRect = CGRectMake(0, 0, width, 220);
            
            TopStoryView *slideView = [[TopStoryView alloc ]initWithFrame:slideRect image:self.topstories];
            
            slideView.delegate = self;
           

            [cell addSubview:slideView];
        }
    }
    else{
    Story *st = [self.stories objectAtIndex:indexPath.row];
    NSString *titleString = st.title;
    NSString *imageURL = st.imageURL;



    StoryTableViewCell *c = (StoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    [c.titleImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];

    c.titleLabel.text = titleString;
    //[self configureCell:cell atIndexPath:indexPath];
        cell = c;
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 220.0f;
    }
    else{
        return 90.0f;
    }
    
}



- (nullable NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    if(section != 0){
       title = [NSString stringWithFormat:@"今日热闻"];
    }
    return title;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        return 25.0f;
    }
    
}



#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Story *s = [self.stories objectAtIndex:indexPath.row];
    StoryContenViewController *storyCV = [[StoryContenViewController alloc]init];
    storyCV.id = s.id;
    [self.navigationController pushViewController:storyCV animated:true];
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


#pragma mark   topstoryview  delegate

-(void)TopStoryViewDidClick:(NSInteger)imageClicked{
    Story *s = [self.topstories objectAtIndex:imageClicked];
    StoryContenViewController *storyCV = [[StoryContenViewController alloc]init];
    storyCV.id = s.id;
    [self.navigationController pushViewController:storyCV animated:true];
}

@end
