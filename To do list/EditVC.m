//
//  EditVC.m
//  To do list
//
//  Created by Abdallah on 30/08/2023.
//

#import "EditVC.h"
#import "Tasks.h"
#pragma mark - interface & implementation
@interface EditVC ()
@property NSMutableArray<Tasks*>* arr;
@property NSUserDefaults* defaults;

@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *desTxtField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *perioritySeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSeg;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateOutlet;

@end

@implementation EditVC
- (void) load {
    _defaults = [NSUserDefaults standardUserDefaults];
//    NSError * error;
    NSData * savedData = [_defaults objectForKey:@"tasksArr"];
//    NSSet * set = [NSSet setWithArray:
//                   @[[NSMutableArray class], [Tasks class]]];
    _arr = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:savedData];
    if (_arr == nil) {
//        printf ("nill inside load\n");
        _arr = [NSMutableArray<Tasks*> new];
    }
//    printf("inside load \n");
//    for (int i=0;i<_arr.count;++i) {
//        NSLog(@"%@", _arr[i].name);
//    }
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
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self load];
    
    _nameTxtField.text=_arr[_recieve].name;
    _desTxtField.text=_arr[_recieve].disc;
    _dateOutlet.date=_arr[_recieve].date;
    NSArray<NSString*>* values = @[@"low", @"medium", @"high"];
    NSArray<NSString*>* values2 = @[@"todo", @"in_progress", @"done"];
    for(int i=0;i<3;i++){
        if([_arr[_recieve].periority isEqualToString:values[i]]){
            _perioritySeg.selectedSegmentIndex=i;
        }
        if([_arr[_recieve].state isEqualToString:values2[i]]){
            _stateSeg.selectedSegmentIndex=i;
        }
    }
#pragma mark - Action
}
- (IBAction)editBtnTapped:(id)sender {
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warinig!" message:@"Do you want to edit?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ac = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction* ac2 = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            Tasks *t = [Tasks new];
      
            t.name = self->_nameTxtField.text;
            t.disc = self->_desTxtField.text;
            NSArray <NSString * >* values = @[@"low", @"medium", @"high"];
            t.periority = values[(int)self->_perioritySeg.selectedSegmentIndex];
            NSArray <NSString * >* values2 = @[@"todo", @"in_progress", @"done"];
            t.state = values2[(int)self->_stateSeg.selectedSegmentIndex];
            t.date = self->_dateOutlet.date;
        //    NSLog(@"%@", t.name);
        //    NSLog(@"%@", t.desc);
        //    NSLog(@"%@", t.priority);
        //    NSLog(@"%@", t.state);
        //    NSLog(@"%@", t.date);
            self->_arr[self->_recieve]=t;
            [self save];
            //[self load];
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alert addAction:ac];
        [alert addAction:ac2];
        [self presentViewController:alert animated:YES completion:nil];
     }
    }
@end
