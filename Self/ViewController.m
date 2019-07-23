//
//  ViewController.m
//  Self
//
//  Created by MariyaShestakova on 6/30/19.
//  Copyright © 2019 MariyaShestakova. All rights reserved.
//

#import "ViewController.h"
#import "AppController.h"

@implementation ViewController

@synthesize data = m_data;
@synthesize table;

static const unsigned int g_defaultNumberOfItems = 20;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_appController = [[AppController alloc] init];
    self.data = [NSMutableArray arrayWithCapacity: g_defaultNumberOfItems];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void) updateProgressAndTable: (double) value
{
    m_progress.doubleValue = value;
    [self.table reloadData];
}

- (void) updateLabel: (NSString*) currentCopyingFileName
{
    m_fileName.stringValue = currentCopyingFileName;
}

- (IBAction) chooseDirectory: (NSButton*) sender
{
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setCanChooseFiles: true];
    [op setCanChooseDirectories: true];
    [op runModal];

    m_appController.directoryName = [[[op.URLs firstObject] absoluteString] stringByReplacingOccurrencesOfString: @"file://" withString: @""];
}

- (IBAction) startCopy: (NSButton*) sender
{
    if (![m_appController.directoryName isEqualToString: @""])
    {
        [m_appController copyFiles: self];
    }
}

- (IBAction) help: (NSButton*) sender
{
    
}

- (IBAction) close: (NSButton*) sender
{
    [[NSApp mainWindow] close];
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.data.count;
}

- (NSView *) tableView: (NSTableView *)tableView viewForTableColumn: (NSTableColumn *)tableColumn row: (NSInteger)row
{
    MyDataObject *object = [self.data objectAtIndex: row];
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier: [tableColumn identifier] owner: self];
   
    cellView.textField.stringValue = [object valueForKey: [tableColumn identifier]];
    
    return cellView;
}

@end


