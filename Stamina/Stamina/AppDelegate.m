//
//  AppDelegate.m
//  Stamina
//
//  Created by Danilo Augusto Mative on 10/09/14.
//  Copyright (c) 2014 Danilo Augusto Mative. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataLoading.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.backgroundColor = [UIColor colorWithRed:249.0/255/0 green:216.0/255.0 blue:0 alpha:1];

    [FBLoginView class];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor clearColor];

    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"] allowLoginUI:false completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self sessionStateChanged:session state:status error:error];
        }];
    }
    CoreDataLoading *core = [[CoreDataLoading alloc] init];
    [core initCoreData];
    UserData *user = [UserData alloc];
    [user loadFromUserDefaults];
    return YES;
}

//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    
//    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
//                                sourceApplication:sourceApplication
//                                  fallbackHandler:^(FBAppCall *call) {
//                                      NSLog(@"Unhandled deep link: %@", url);
//                                      // Here goes the code to handle the links
//                                      // Use the links to show a relevant view of your app to the user
//                                  }];
//    
//    return urlWasHandled;
//}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
   
    BOOL wasHadled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    return wasHadled;
}


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    // customize your code...
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            abort();
        }
    }
}



#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"teachmeray" withExtension:@"momd"];
    //_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"teachmeray.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

-(void)applicationDidFinishLaunching:(UIApplication *)application{
    
    UserData *data = [UserData alloc];
    [data saveOnUserDefaults];
    
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
    
    UserData *data = [UserData alloc];
    [data saveOnUserDefaults];
    
}

-(void)applicationWillTerminate:(UIApplication *)application{
    
    UserData *data = [UserData alloc];
    [data saveOnUserDefaults];
    
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    
//    BOOL urlWasHandled =
//    [FBAppCall handleOpenURL:url
//           sourceApplication:sourceApplication
//             fallbackHandler:
//     ^(FBAppCall *call) {
//         // Parse the incoming URL to look for a target_url parameter
//         NSString *query = [url query];
//         NSDictionary *params = [self parseURLParams:query];
//         // Check if target URL exists
//         NSString *appLinkDataString = [params valueForKey:@"al_applink_data"];
//         if (appLinkDataString) {
//             NSError *error = nil;
//             NSDictionary *applinkData =
//             [NSJSONSerialization JSONObjectWithData:[appLinkDataString dataUsingEncoding:NSUTF8StringEncoding]
//                                             options:0
//                                               error:&error];
//             if (!error &&
//                 [applinkData isKindOfClass:[NSDictionary class]] &&
//                 applinkData[@"target_url"]) {
//                 self.refererAppLink = applinkData[@"referer_app_link"];
//                 NSString *targetURLString = applinkData[@"target_url"];
//                 // Show the incoming link in an alert
//                 // Your code to direct the user to the
//                 // appropriate flow within your app goes here
//                 [[[UIAlertView alloc] initWithTitle:@"Received link:"
//                                             message:targetURLString
//                                            delegate:nil
//                                   cancelButtonTitle:@"OK"
//                                   otherButtonTitles:nil] show];
//             }
//         }
//     }];
//    
//    return urlWasHandled;
//}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}



@end
