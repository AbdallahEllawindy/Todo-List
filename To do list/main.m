//
//  main.m
//  To do list
//
//  Created by Abdallah on 30/08/2023.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
is    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
