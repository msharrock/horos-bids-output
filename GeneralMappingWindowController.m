//
//  GeneralMappingWindowController.m
//  OsirixBidsOutput
//
//  Created by Michał Szczepanik on 30.08.2017.
//
//

#import "GeneralMappingWindowController.h"
#import <OsiriXAPI/DicomStudy.h>
#import <OsiriXAPI/DicomSeries.h>
#import <OsiriXAPI/BrowserController.h>

#import "OBOCollectedData.h"

@implementation GeneralMappingWindowController

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    OBOCollectedData *sharedData = [OBOCollectedData sharedManager];
    return [sharedData.seriesDescription count];
}

-(NSView* )tableView:(NSTableView*)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    OBOCollectedData *sharedData = [OBOCollectedData sharedManager];
    
    NSArray *sequenceNames = [sharedData.seriesDescription allKeys];
    NSString *currentName = [sequenceNames objectAtIndex:row];
    
    NSString *identifier = [tableColumn identifier];
    
    if ([identifier isEqualToString:@"NameCol"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"NameCell" owner:self]; // will give us back the view that we created in the gui editor; identifier refers to TableCellView
        
        [cellView.textField setStringValue:currentName];
        return cellView;
    }
    // suffix - T1w, bold, ... - will also determine anat, func, fmap
    else if ([identifier isEqualToString:@"SuffixCol"]){
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"SuffixCell" owner:self];
        return cellView;
    }
    //session
    else if ([identifier isEqualToString:@"SessionCol"]){
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"SessionCell" owner:self];
        [cellView.textField setEditable:TRUE];
        return cellView;
    }
    // run
    else if ([identifier isEqualToString:@"RunCol"]){
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"RunCell" owner:self];
        [cellView.textField setEditable:TRUE];
        return cellView;
    }
    // task
    else if ([identifier isEqualToString:@"TaskCol"]){
        
        NSString *currentSuffix = [[sharedData.seriesDescription objectForKey:currentName] objectForKey:@"suffix"];
        
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"TaskCell" owner:self];

        if ([currentSuffix isEqualToString:@"bold"]) {
            [cellView.textField setEditable:TRUE];
        } else {
            [cellView.textField setEditable:FALSE];
            [cellView.textField setStringValue:@""];
        }
        return cellView;
    }
    return nil;

}

- (IBAction)updateSuffix:(id)sender {
    OBOCollectedData *sharedData = [OBOCollectedData sharedManager];
    
    NSInteger selectedRow = [self.tableView rowForView:sender];
    NSString *selectedSuffix = [sender titleOfSelectedItem];  // WOW that worked
    
    NSArray *sequenceNames = [sharedData.seriesDescription allKeys];  // may move to class variable
    NSString *currentName = [sequenceNames objectAtIndex:selectedRow];
    
    NSDictionary * currentItem = [sharedData.seriesDescription objectForKey:currentName];
    [currentItem setValue:selectedSuffix forKey:@"suffix"];

    [self.tableView abortEditing]; // in case editing of a text field was not finished
    [self.tableView reloadData];
}

@end