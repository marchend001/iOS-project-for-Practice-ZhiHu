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
#import "NetworkModel.h"
#import "AppDelegate.h"

@interface MainViewController (){
    NSString *url;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *stories;
@property (nonatomic,copy)NSMutableArray *topstories;

@property (nonatomic,strong) NSFetchedResultsController *storyFetchedResultsController;
@property (nonatomic,strong) NSFetchedResultsController *topstoryFetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NetworkModel *networkModel;
@property (nonatomic,strong) AppDelegate *appdelegate;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"知乎";
        [self  setUp];
        [self.networkModel addObserver:self forKeyPath:@"downLoadCompleted" options:NSKeyValueObservingOptionOld context:nil];
        //[self fetchStory:self.managedObjectContext];
    }
    //self.title = @"知乎";
    
    return self;
}


- (void)setUp {
    
    self.appdelegate = [UIApplication sharedApplication].delegate;
    if(self.appdelegate.context){
        self.managedObjectContext = self.appdelegate.context;
    }
    
    self.networkModel = [[NetworkModel alloc]init];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    self.dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CH"];
    self.dateFormatter.dateStyle = NSDateFormatterFullStyle;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController  *revealController = self.revealViewController;
    [revealController panGestureRecognizer];

    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = UIColor.blueColor;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    UIBarButtonItem *sideBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sideMenu"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = sideBarButton;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    //self.stories = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[StoryTableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.view addSubview:self.tableView];
    //[self.networkModel fetchAndProcess:self.managedObjectContext];
    //[self loadData];
    [self fetchTopStory:self.managedObjectContext];
}


- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"gaPrefix" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
    
    self.storyFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"date" cacheName:nil];
}

- (void)setStoryFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController{
    _storyFetchedResultsController = fetchedResultsController;
    _storyFetchedResultsController.delegate = self;
    
    [self performFetch];
}


-(void)performFetch {
    
    if(self.storyFetchedResultsController){
        NSError *error;
        BOOL success = [self.storyFetchedResultsController performFetch:&error];
        if(!success){
            NSLog(@"[%@ %@] performFetch: failed",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
        }
        if(error){
            NSLog(@"[%@ %@] %@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd),[error localizedDescription],[error localizedFailureReason]);
        }
    }
    
    [self.tableView reloadData];
    
}

- (void)fetchTopStory:(NSManagedObjectContext *)managedObjectContext {
    
    
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TopStory"];
        //request.predicate = [NSPredicate predicateWithFormat:@"dateString = %@",dateString];
        [request setPredicate:nil];
        
        NSError *error;
        NSArray *matchArray = [managedObjectContext executeFetchRequest:request error:&error];
        
        if(!matchArray || error){
            NSLog(@"ERROR in %s",__FUNCTION__);
        }else if([matchArray count]){
            self.topstories =[matchArray mutableCopy];
        }else if(![matchArray count]){
            NSLog(@"FetchTopStories failed!");
        }


    
}

- (void)fetchStory:(NSManagedObjectContext *)managedObjectContext {
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Story"];
    //request.predicate = [NSPredicate predicateWithFormat:@"dateString = %@",dateString];
    [request setPredicate:nil];
    
    NSError *error;
    NSArray *matchArray = [managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"count:%lu",(unsigned long)matchArray.count);
    for(Story * s in matchArray){
        NSLog(@"title:%@  imageURL:%@ date:%@",s.title,s.imageURL,s.date);
    }
    if(!matchArray || error){
        NSLog(@"ERROR in %s",__FUNCTION__);
    }else if([matchArray count]){
        self.stories =[matchArray mutableCopy];
    }else if(![matchArray count]){
        NSLog(@"FetchStories failed!");
    }

    
    
}



-(void)viewWillAppear:(BOOL)animated{

    [self.tableView reloadData];
    
}





#pragma mark - tableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = [[self.storyFetchedResultsController sections]count];
    return section+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if(section == 0){
        return 1;
    }
    else{
        if([[self.storyFetchedResultsController sections]count]>0){
            id<NSFetchedResultsSectionInfo> sectionInfo = [[self.storyFetchedResultsController sections] objectAtIndex:section-1];
            row = [sectionInfo numberOfObjects];
        }
        
        return row;

    }
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if(indexPath.section == 0){
        
        //Story *st = [self.fetchedResultsController objectAtIndexPath:indexPath];
        //NSString *titleString = st.title;
       // NSString *imageURL = st.imageURL;
        //NSLog(@"title:%@  imageURL:%@",titleString,imageURL);
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
        NSIndexPath *newindexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
        NSLog(@"section:%ld",(long)indexPath.section);
    Story *st = [self.storyFetchedResultsController objectAtIndexPath:newindexPath];
    NSString *titleString = st.title;
    NSString *imageURL = st.imageURL;


    if(imageURL){
        StoryTableViewCell *c = (StoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
        [c.titleImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        c.titleLabel.text = titleString;
        //[self configureCell:cell atIndexPath:indexPath];
        cell = c;
        }
    
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"height for row:%ld",(long)indexPath.row);
    if(indexPath.section == 0){
        return 220.0f;
    }
    else{
        return 90.0f;
    }
    
}


- (nullable NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    if(section == 0){
        return nil;
    }
    if(section == 1){
       title = [NSString stringWithFormat:@"今日热闻"];
    }
    else {
        if([[self.storyFetchedResultsController sections] count]>= section){
            title = [[[self.storyFetchedResultsController sections] objectAtIndex:section-1] name];
        }
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


/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger sectionNum = [[self.storyFetchedResultsController sections] count];
    
    NSInteger rowNum = 0;
    if(sectionNum > 0) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.storyFetchedResultsController sections] objectAtIndex:sectionNum-1];
        rowNum = [sectionInfo numberOfObjects];
    }
    
    if((indexPath.section == sectionNum)  && (indexPath.row == (rowNum-1))){
        NSIndexPath *newindexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
        Story *story = [self.storyFetchedResultsController objectAtIndexPath:newindexPath];
        NSString *curDate = story.date;
        [self.networkModel fetchAndSaveStoriesBeforeCertainDate:curDate intoManagedObjectContext:self.managedObjectContext];
    }
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *newindexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
    Story *s = [self.storyFetchedResultsController objectAtIndexPath:newindexPath];
    StoryContenViewController *storyCV = [[StoryContenViewController alloc]init];
    storyCV.id = s.id;
    [self.navigationController pushViewController:storyCV animated:true];
}




- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"end dragging");
    if(scrollView.contentOffset.y>(scrollView.contentSize.height-scrollView.frame.size.height)){
        NSLog(@"need load more");
        NSInteger section = [[self.storyFetchedResultsController sections]count]-1;
        NSIndexPath *newindexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        Story *story = [self.storyFetchedResultsController objectAtIndexPath:newindexPath];
        NSString *curDate = story.date;
        [self.networkModel fetchAndSaveStoriesBeforeCertainDate:curDate intoManagedObjectContext:self.managedObjectContext];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSFetchedResultControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
    if(sectionIndex == 0){
        [self fetchTopStory:self.managedObjectContext];
        //[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
        [self.tableView reloadData];
        
    }
    NSUInteger newsectionIndex = sectionIndex+1;

    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            //NSUInteger newsectionIndex =
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newsectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:newsectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:newsectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:newsectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    NSIndexPath *newindexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section+1];
    NSIndexPath *n_indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newindexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:n_indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:n_indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:n_indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newindexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }

    
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    //[self fetchTopStory:self.managedObjectContext];
    [self.tableView endUpdates];
}


#pragma mark - kvo回调方法

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"downLoadCompleted"]){
       // [self fetchTopStory:self.managedObjectContext];
        [self.tableView reloadData];
    }
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
