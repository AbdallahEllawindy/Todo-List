//
//  ViewController.m
//  To do list
//
//  Created by Abdallah on 30/08/2023.
//

#import "ViewController.h"
#import "AddVC.h"
#import "Tasks.h"
#import "EditVC.h"

#pragma mark - interface & implementation
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *todoTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSUserDefaults* defaults;
@property NSMutableArray<Tasks*>* arr;
@property bool search_is_active;
@property NSMutableArray<NSNumber*>* view_indices;
@property NSMutableArray<NSNumber*>* search_view_indices;

@end

@implementation ViewController

- (void) load {
    _defaults = [NSUserDefaults standardUserDefaults];
//    NSError * error;
    NSData* savedData = [_defaults objectForKey:@"tasksArr"];
//    NSSet* set = [NSSet setWithArray:
//                   @[[NSMutableArray class], [Tasks class]]];
    _arr = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:savedData];
    
    if (_arr == nil) {
//        printf ("nill inside load\n");
        _arr = [NSMutableArray<Tasks*> new];
    }
    _view_indices=[NSMutableArray<Tasks*> new];
    for(int i=0;i<_arr.count;i++){
        if([_arr[i].state isEqualToString:@"todo"]){
            [_view_indices addObject:[NSNumber numberWithInt:i]];
        }
    }
//    printf("inside load \n");
//    for (int i=0;i<_arr.count;++i) {
//        NSLog(@"%@", _arr[i].name);
//    }
    _search_view_indices = [NSMutableArray<NSNumber*> new];
    if (! [_searchBar.text isEqualToString:@""]) {
        _search_is_active=true;
        NSMutableString * search_string = [NSMutableString stringWithString: _searchBar.text];
        search_string = [NSMutableString stringWithString:[search_string lowercaseString]];
        //NSLog(@"inside load : |%@|", search_string);
        //(search bar text)comp == substr of _arr[view_indices[i]].name (0, comp.size - 1)
        for (int i=0;i<_view_indices.count;++i) {
        
        NSString * task_name = _arr[[_view_indices[i] intValue]].name;
        //NSLog(@"|%@|", [task_name substringToIndex:search_string.length]);
        task_name=[NSMutableString stringWithString:[task_name lowercaseString]];
        
        if (search_string.length <= task_name.length) {
            // I am a prefix
        if ([search_string isEqualToString:[task_name substringToIndex:(search_string.length)]]) {
            
        [_search_view_indices addObject:[NSNumber numberWithInt:[_view_indices[i] intValue]]];
        }
       }
     }
   }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //NSLog(@"%@", searchBar.text);
    
    if ([searchText isEqualToString:@""]) {
        _search_is_active = false;
    }
    else {
        _search_is_active = true;
    }
    [self load];
    [_todoTableView reloadData];
    
}

- (void) save {
//    printf ("inside save\n");
//    for (int i=0;i<_arr.count;++i) {
//        NSLog(@"%@", _arr[i].name);
//    }
//    NSError * error;
    NSData * archiveData = [NSKeyedArchiver archivedDataWithRootObject:_arr];
    [_defaults setObject:archiveData forKey:@"tasksArr"];
    [_defaults synchronize];
//    [self load];
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self load];

    _todoTableView.delegate=self;
    _todoTableView.dataSource=self;
    _searchBar.delegate = self;
    _search_is_active = false;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self load];
    [self.todoTableView reloadData];
}

- (IBAction)addBtnClicked:(id)sender {
    AddVC* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddVC"];
    [self.navigationController pushViewController:vc animated:true];
    
}

#pragma mark - Table View Functions

//Table View Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_search_is_active) {
        return _search_view_indices.count;
    }
    return [_view_indices count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.textLabel.text= _arr[indexPath.row].name;
    if (_search_is_active) {
        cell.textLabel.text=_arr[[_search_view_indices[indexPath.row] intValue]].name;

//        if ([_arr[[_search_view_indices[indexPath.row] intValue]].periority isEqualToString: @"high"]) {
//            cell.imageView.image = [UIImage imageNamed:@"high"];
//        }
//        else if ([_arr[[_search_view_indices[indexPath.row] intValue]].periority isEqualToString:@"medium"]) {
//            cell.imageView.image = [UIImage imageNamed:@"medium"];
//        }
//        else if ([_arr[[_search_view_indices[indexPath.row] intValue]].periority isEqualToString: @"low" ]) {
//            cell.imageView.image = [UIImage imageNamed:@"low"];
//        }

    }
    else {
        cell.textLabel.text=_arr[[_view_indices[indexPath.row] intValue]].name;

//        if ([_arr[[_view_indices[indexPath.row] intValue]].periority isEqualToString: @"high"]) {
//            cell.imageView.image = [UIImage imageNamed:@"high"];
//        }
//        else if ([_arr[[_view_indices[indexPath.row] intValue]].periority isEqualToString:@"medium"]) {
//            cell.imageView.image = [UIImage imageNamed:@"medium"];
//        }
//        else if ([_arr[[_view_indices[indexPath.row] intValue]].periority isEqualToString: @"low" ]) {
//            cell.imageView.image = [UIImage imageNamed:@"low"];
//        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditVC* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"EditVC"];
    //edit_vc.my_index = [_view_indices[indexPath.row] intValue];
    if (_search_is_active) {
        vc.recieve = [_search_view_indices[indexPath.row] intValue];
    }
    else {
        vc.recieve = [_view_indices[indexPath.row] intValue];
    }    [self.navigationController pushViewController:vc animated:true];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//         [self.monthTitle removeObjectAtIndex:indexPath.row];
//        [_arr removeObjectAtIndex:indexPath.row];
//        [self save];
//
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
//    }
//    else if (editingStyle==UITableViewCellEditingStyleInsert)
//    {
//    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warinig!" message:@"Do you want to delet?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ac = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction* ac2 = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            
    if (self->_search_is_active) {
        [self->_arr removeObjectAtIndex:[self->_search_view_indices[indexPath.row] intValue]];
        [self->_search_view_indices removeObjectAtIndex:indexPath.row];
        [self save];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
    else {
        [self->_arr removeObjectAtIndex:[self->_view_indices[indexPath.row] intValue]];
        [self->_view_indices removeObjectAtIndex:indexPath.row];
        [self save];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
    
    //         [self.monthTitle removeObjectAtIndex:indexPath.row];
    //        [_arr removeObjectAtIndex:[_view_indices[indexPath.row] intValue]];
    //        [_view_indices removeObjectAtIndex:indexPath.row];
    //        [self save];
    //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
    else if (editingStyle==UITableViewCellEditingStyleInsert)
    {
    }
        
    }];
    [alert addAction:ac];
    [alert addAction:ac2];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
