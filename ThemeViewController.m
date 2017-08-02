//
//  ThemeViewController.m
//  ZhiHu
//
//  Created by Marchend on 2017/7/31.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "ThemeViewController.h"
#import "AppDelegate.h"
#import "Theme.h"

@interface ThemeViewController ()

@property (nonatomic,strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic,strong) AppDelegate *appDelegate;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
//@property

@end

@implementation ThemeViewController


- (instancetype)init{
    //self initWithNibName:<#(nullable NSString *)#> bundle:(nullable NSBundle *)
    
    if(self = [super init]){
        //NSLog(@"1");
        [self setUp];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        [self setUp];
    }
    return self;
}

-(void)setUp {
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    if(self.appDelegate.context){
        self.managedObjectContext = self.appDelegate.context;
    }else{
        NSLog(@"not managedObjectContext in appDelegate");
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *fetchRequest= [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Theme" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"id" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
    
    self.fetchedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];

}

- (void)setFetchedResultController:(NSFetchedResultsController *)fetchedResultsController{
    _fetchedResultController = fetchedResultsController;
    _fetchedResultController.delegate = self;
    
    [self performFetch];
}


-(void)performFetch {
    
    if(self.fetchedResultController){
        NSError *error;
        BOOL success = [self.fetchedResultController performFetch:&error];
        if(!success){
            NSLog(@"[%@ %@] performFetch: failed",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
        }
        if(error){
            NSLog(@"[%@ %@] %@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd),[error localizedDescription],[error localizedFailureReason]);
        }
    }
    
    [self.tableView reloadData];
    
}




-(void)viewWillAppear:(BOOL)animated{
    
    //[self.tableView reloadData];
    
}





#pragma mark - tableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //NSInteger section = [[self.fetchedResultController sections]count];
    //return section;
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
        if([[self.fetchedResultController sections]count]>0){
            id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
            row = [sectionInfo numberOfObjects];
        }
        
        return row+1;
        
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = nil;
    //UITableViewCell *cell;


    switch (indexPath.row) {
        case 0:
            cellIdentifier = @"Home";
            break;
            
        default:
            cellIdentifier = @"Theme";
            break;
            
        
    }
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(indexPath.row == 0){
            cell.textLabel.text = @"首页";
        
        
    }else{
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        Theme *theme = [self.fetchedResultController objectAtIndexPath:newIndexPath];
        cell.textLabel.text = theme.name;
    }
    


    return cell;
}





#pragma mark - tableView Delegate




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSIndexPath *newindexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
    //Story *s = [self.fetchedResultController objectAtIndexPath:newindexPath];
    //StoryContenViewController *storyCV = [[StoryContenViewController alloc]init];
    //storyCV.id = s.id;
    //[self.navigationController pushViewController:storyCV animated:true];
}





#pragma mark - NSFetchedResultControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    

    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            //NSUInteger newsectionIndex =
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
    
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView endUpdates];
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
