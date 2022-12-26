//
//  WIBDataModel.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBDataModel.h"

// GamePlayManager keeps track of used names
#import "WIBGamePlayManager.h"

@interface WIBDataModel()
@property (atomic, strong) NSMutableDictionary *gameItemsDictionary;
@end

@implementation WIBDataModel

+ (WIBDataModel *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBDataModel *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBDataModel alloc] init];
        shared.gameItemsDictionary = [NSMutableDictionary dictionary];
    });
    return shared;
}


- (void) generateTestData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"csv"];

    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    //NSArray *rows = [NSArray arrayWithContentsOfCSVFile:path encoding:NSUTF8StringEncoding error:&error];
    
    //CHCVParser *parser = [[CHCSVParser alloc] initWithContentsOfCSVURL:url];
    
    
   NSString* fileContents = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    
    NSCharacterSet* separatorCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@","];

    
    NSMutableArray* rowStrings = [fileContents componentsSeparatedByString:@"\n"].mutableCopy;
    [rowStrings removeObjectAtIndex:0];
    for (NSString *rowString in rowStrings){
        NSString *strippedRowString = [rowString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
         NSArray* fieldsInRow = [strippedRowString componentsSeparatedByCharactersInSet:separatorCharactersSet];
        if (fieldsInRow.count == 7) {
            WIBGameItem *item = [[WIBGameItem alloc] init];
            item.name = fieldsInRow[0];
            
            item.categoryString = fieldsInRow[1];
            item.unit = fieldsInRow[3];
            item.tagArray = [NSArray arrayWithObject: fieldsInRow[4]];
            //[fieldsInRow[4] componentsSeparatedByString:@","];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *baseQuantity = [f numberFromString:fieldsInRow[5]];
            
            item.baseQuantity = fieldsInRow[5];
            
            NSString *trimmedPhotoURL = [fieldsInRow[6] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

            item.photoURL = trimmedPhotoURL;
            
            
            item.objectId = @"asdf1";
            if (item.baseQuantity >0 && baseQuantity.integerValue >0) {
                [self insertGameItem: item];
            }
        }
    }
}

- (void) generateTestDataLocal {
    WIBGameItem *gameItem1 = [[WIBGameItem alloc] init];
    gameItem1.name = @"Shaquille O'Neal";
    gameItem1.baseQuantity = @325;
    gameItem1.unit = @"lbs";
    gameItem1.categoryString = @"weight";
    gameItem1.tagArray = @[@"person", @"celebrity"];
    gameItem1.photoURL = @"https://upload.wikimedia.org/wikipedia/commons/a/ab/Shaquille_O%27Neal_Buckley_Air_Base.jpg";
    gameItem1.objectId = @"asdf1";
    
    [self insertGameItem: gameItem1];
    
    WIBGameItem *gameItem2 = [[WIBGameItem alloc] init];
    gameItem2.name = @"Tim Cook";
    gameItem2.baseQuantity = @174;
    gameItem2.unit = @"lbs";
    gameItem2.categoryString = @"weight";
    gameItem2.tagArray = @[@"person", @"celebrity"];
    gameItem2.photoURL = @"https://upload.wikimedia.org/wikipedia/commons/e/e1/%D0%A2%D0%B8%D0%BC_%D0%9A%D1%83%D0%BA_%2802-09-2021%29.jpg";
    gameItem2.objectId = @"asdf2";
    
    [self insertGameItem: gameItem2];
    
    WIBGameItem *gameItem3 = [[WIBGameItem alloc] init];
    gameItem3.name = @"Mariah Carey";
    gameItem3.baseQuantity = @124;
    gameItem3.unit = @"lbs";
    gameItem3.categoryString = @"weight";
    gameItem3.tagArray = @[@"person", @"celebrity"];
    gameItem3.photoURL = @"https://upload.wikimedia.org/wikipedia/commons/9/93/Mariah_Carey_WBLS_2018_Interview_2.jpg";
    gameItem3.objectId = @"asdf3";
    
    [self insertGameItem: gameItem3];
    
    WIBGameItem *gameItem4 = [[WIBGameItem alloc] init];
    gameItem4.name = @"Kanye West";
    gameItem4.baseQuantity = @183;
    gameItem4.unit = @"lbs";
    gameItem4.categoryString = @"weight";
    gameItem4.tagArray = @[@"person", @"celebrity"];
    gameItem4.photoURL = @"https://upload.wikimedia.org/wikipedia/commons/1/10/Kanye_West_at_the_2009_Tribeca_Film_Festival_%28cropped%29.jpg";
    gameItem4.objectId = @"asdf4";
    
    [self insertGameItem: gameItem4];
    
    WIBGameItem *gameItem5 = [[WIBGameItem alloc] init];
    gameItem5.name = @"Rihanna";
    gameItem5.baseQuantity = @125;
    gameItem5.unit = @"lbs";
    gameItem5.categoryString = @"weight";
    gameItem5.tagArray = @[@"person", @"celebrity"];
    gameItem5.photoURL = @"https://upload.wikimedia.org/wikipedia/commons/7/75/Rihanna_Met_Gala_2017.jpg";
    gameItem5.objectId = @"asdf5";
    
    [self insertGameItem: gameItem5];
    
    WIBGameItem *gameItem6 = [[WIBGameItem alloc] init];
    gameItem6.name = @"Natalie Portman";
    gameItem6.baseQuantity = @124;
    gameItem6.unit = @"lbs";
    gameItem6.categoryString = @"weight";
    gameItem6.tagArray = @[@"person", @"celebrity"];
    gameItem6.photoURL = @"https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Natalie_Portman_%2848470988352%29_%28cropped%29.jpg/1280px-Natalie_Portman_%2848470988352%29_%28cropped%29.jpg";
    gameItem6.objectId = @"asdf6";
    
    [self insertGameItem: gameItem6];
    
    WIBGameItem *gameItem7 = [[WIBGameItem alloc] init];
    gameItem7.name = @"Michelle Yeoh";
    gameItem7.baseQuantity = @123;
    gameItem7.unit = @"lbs";
    gameItem7.categoryString = @"weight";
    gameItem7.tagArray = @[@"person", @"celebrity"];
    gameItem7.photoURL = @"https://upload.wikimedia.org/wikipedia/commons/6/61/Michelle_Yeoh_Cannes_2017.jpg";
    gameItem7.objectId = @"asdf7";
    
    [self insertGameItem: gameItem7];
    
    WIBGameItem *gameItem8 = [[WIBGameItem alloc] init];
    gameItem8.name = @"Ryan Gosling";
    gameItem8.baseQuantity = @182;
    gameItem8.unit = @"lbs";
    gameItem8.categoryString = @"weight";
    gameItem8.tagArray = @[@"person", @"celebrity"];
    gameItem8.photoURL = @"https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Ryan_Gosling_in_2018.jpg/1280px-Ryan_Gosling_in_2018.jpg";
    gameItem8.objectId = @"asdf8";
    
    [self insertGameItem: gameItem8];
    
    WIBGameItem *gameItem9 = [[WIBGameItem alloc] init];
    gameItem9.name = @"Christina Le";
    gameItem9.baseQuantity = @122;
    gameItem9.unit = @"lbs";
    gameItem9.categoryString = @"weight";
    gameItem9.tagArray = @[@"person", @"celebrity"];
    gameItem9.photoURL = @"https://i.scdn.co/image/ab6775700000ee85bd411915e73e26ce6ce36767";
    gameItem9.objectId = @"asdf9";
    
    [self insertGameItem: gameItem9];
    
    WIBGameItem *gameItem10 = [[WIBGameItem alloc] init];
    gameItem10.name = @"PJ Loury";
    gameItem10.baseQuantity = @178;
    gameItem10.unit = @"lbs";
    gameItem10.categoryString = @"weight";
    gameItem10.tagArray = @[@"person", @"celebrity"];
    gameItem10.photoURL = @"https://scontent-ord5-1.xx.fbcdn.net/v/t39.30808-1/279848587_10200608999881536_659037373231340383_n.jpg?stp=dst-jpg_p320x320&_nc_cat=108&ccb=1-7&_nc_sid=0c64ff&_nc_ohc=lQK11VdTuAsAX-nM1b5&_nc_ht=scontent-ord5-1.xx&edm=AP4hL3IEAAAA&oh=00_AT_USo10gI-WZ3U4ewgsX00RuN1GQuLWbbIMMa1un6ovnw&oe=6334E343";
    gameItem10.objectId = @"asdf3";
    
    [self insertGameItem: gameItem10];
    
}


- (void)insertGameItem:(WIBGameItem *)gameItem
{
    if (!self.gameItemsDictionary) {
        self.gameItemsDictionary = [NSMutableDictionary dictionary];
    }
    NSMutableArray* categoryArray = [self.gameItemsDictionary objectForKey:gameItem.categoryString];
    if(!categoryArray)
    {
        categoryArray = [NSMutableArray array];
        [self.gameItemsDictionary setObject:categoryArray forKey:gameItem.categoryString];
    }
    [categoryArray addObject:gameItem];  
}

- (BOOL)itemNameAlreadyUsed:(NSString *)name
{
    return [[WIBGamePlayManager sharedInstance].gameRound.usedNames containsObject:name];
}

- (void)invalidateDataModel {
    _gameItemsDictionary = nil;
}

- (WIBGameItem*)firstGameItemForQuestionType:(WIBQuestionType *)type
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:type.category];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    if(![self itemNameAlreadyUsed:gameItem.name] && [gameItem supportsQuestionType:type])
    {
        [[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
        return gameItem;
    }
    else
    {
        return [self firstGameItemForQuestionType:type];
    }
}

- (WIBGameItem*)firstNonHumanGameItemForQuestionType:(WIBQuestionType *)type
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:type.category];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    if(![self itemNameAlreadyUsed:gameItem.name] && [gameItem supportsQuestionType:type] && !gameItem.isPerson)
    {
        [[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
        return gameItem;
    }
    else
    {
        return [self firstGameItemForQuestionType:type];
    }
}

- (WIBGameItem*)secondGameItemForQuestionType:(WIBQuestionType *)type dissimilarTo:(WIBGameItem *)item orderOfMagnitude:(double)magnitude
{
    NSAssert(magnitude>1,@"Magnitude is too small");
    
    // Start with Large Magnitude difference, then progressively smaller
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:type.category];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    // Example, 300 ft item, 10 ft gameItem
    double scaling = item.baseQuantity.doubleValue/gameItem.baseQuantity.doubleValue;
    // scaling.. 30x bigger
    
    NSAssert((item.baseQuantity.doubleValue > 0 && gameItem.baseQuantity.doubleValue > 0), @"Base quantities must be greater than zero!");
    
    double reciprocal = 1/magnitude;
    
    BOOL differentEnough = (scaling > magnitude || scaling < reciprocal);
    
    static int tries = 0;
    
    if(![self itemNameAlreadyUsed:gameItem.name] &&
       [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] && differentEnough && [gameItem supportsQuestionType:type])
    {
        [[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
        return gameItem;
    }
    else
    {
        tries++;
        if (tries < [gameItemsWithSameCategory count])
        {
            return [self secondGameItemForQuestionType:type dissimilarTo:item orderOfMagnitude:magnitude];
        }
        else
        {
            return [self secondGameItemForQuestionType:type dissimilarTo:item orderOfMagnitude:magnitude-1];
        }
    }
}

- (WIBGameItem*)secondGameItemForQuestionType:(WIBQuestionType *)type withRespectToItem:(WIBGameItem *)item withQuestionCeiling:(double)questionCeiling
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:type.category];
    
    int r = 0;
    if (gameItemsWithSameCategory.count > 0) {
        r = arc4random() % [gameItemsWithSameCategory count];
    }
   
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    

    double percentDifference = (fabs((gameItem.baseQuantity.doubleValue - item.baseQuantity.doubleValue)/fmin(item.baseQuantity.doubleValue,gameItem.baseQuantity.doubleValue))) * 100;
    BOOL closeEnough = (percentDifference < questionCeiling && percentDifference > [WIBGamePlayManager sharedInstance].questionFloor);
    
    static int tries = 0;
    
    // Cannot, be already used name, cannot be a tie, must be close enough
    if(![self itemNameAlreadyUsed:gameItem.name] &&
       [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] && closeEnough && [gameItem supportsQuestionType:type])
    {
        NSLog(@"%@ vs %@", gameItem.name,item.name);
        //[[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
        NSLog(@"%@ and %@ are %.2f%% different",item.name, gameItem.name ,percentDifference);
        return gameItem;
    }
    else
    {
        tries++;
        if (tries < [gameItemsWithSameCategory count])
        {
            return [self secondGameItemForQuestionType:type withRespectToItem:item withQuestionCeiling:questionCeiling];
        }
        // ADDED THIS TO AVOID ISSUES
        else if ( tries > 100 && !closeEnough) {
            NSLog(@"%@ vs %@", gameItem.name,item.name);
            //[[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
            NSLog(@"%@ and %@ are %.2f%% different",item.name, gameItem.name ,percentDifference);
            return gameItem;
        }
        
        else
        {
            return [self secondGameItemForQuestionType:type withRespectToItem:item withQuestionCeiling:questionCeiling+10];
        }
    }
}

- (WIBGameItem*)secondNonHumanGameItemForQuestionType:(WIBQuestionType *)type withRespectToItem:(WIBGameItem *)item withQuestionCeiling:(double)questionCeiling
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:type.category];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    NSLog(@"%@ vs %@", gameItem.name,item.name);
    double percentDifference = (fabs((gameItem.baseQuantity.doubleValue - item.baseQuantity.doubleValue)/fmin(item.baseQuantity.doubleValue,gameItem.baseQuantity.doubleValue))) * 100;
    BOOL closeEnough = (percentDifference < questionCeiling && percentDifference > [WIBGamePlayManager sharedInstance].questionFloor);
    
    static int tries = 0;
    
    // Cannot, be already used name, cannot be a tie, must be close enough
    if(![self itemNameAlreadyUsed:gameItem.name] &&
       [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] && closeEnough && [gameItem supportsQuestionType:type] && !gameItem.isPerson)
    {
        [[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
        NSLog(@"%@ and %@ are %.2f%% different",item.name, gameItem.name ,percentDifference);
        return gameItem;
    }
    else
    {
        tries++;
        if (tries < [gameItemsWithSameCategory count])
        {
            return [self secondGameItemForQuestionType:type withRespectToItem:item withQuestionCeiling:questionCeiling];
        }
        else
        {
            return [self secondGameItemForQuestionType:type withRespectToItem:item withQuestionCeiling:questionCeiling+10];
        }
    }
}

@end
