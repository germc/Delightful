//
//  Model.m
//  Delightful
//
//  Created by Jared on 2/11/13.
//  Copyright (c) 2013 com.company. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (Model *)modelSingleton
{
    static Model *modelSingleton;
    @synchronized(self)
    {
        if (!modelSingleton)
            modelSingleton = [[Model alloc] init];
        return modelSingleton;
    }
}

#pragma mark - Create

- (void) addItemWithName:(NSString *)name
    withCategory:(NSNumber *)category
 withMeasurement:(NSNumber*)measurement
    withQuantity:(NSNumber*)quantity
       withPrice:(NSNumber*)price
{
    NSEntityDescription *entity = [[_fetchedResultsController fetchRequest] entity];
    Item *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:_managedObjectContext];
    newManagedObject.timeStamp = [NSDate date];
    newManagedObject.name = name;
    newManagedObject.category = category;
    newManagedObject.measurement = measurement;
    newManagedObject.quantity = quantity;
    newManagedObject.price = price;
    newManagedObject.checked = [[NSNumber alloc] initWithBool:NO];
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

#pragma mark - Read

// Metric = YES, US = NO
- (BOOL) getMeasuringSetting {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:@"measuringSetting"] boolValue];
}

- (NSNumber*) getTaxRate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"taxRate"];
}

#pragma mark - Update

// Metric = YES, US = NO
- (void) setMeasuringSetting:(BOOL)measuring {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:measuring forKey:@"measuringSetting"];
    [defaults synchronize];
}

- (void) setTaxRate:(NSNumber*)measuring {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:[measuring doubleValue] forKey:@"taxRate"];
    [defaults synchronize];
}

- (void)updateItem:(Item *)item {
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
}
@end
