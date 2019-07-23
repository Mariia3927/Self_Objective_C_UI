//
//  ViewController.h
//  Self
//
//  Created by MariyaShestakova on 6/30/19.
//  Copyright © 2019 MariyaShestakova. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppController;
@class MyDataObject;

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
{
    IBOutlet NSTextField *m_tableLabel;
    IBOutlet NSTextField *m_fileLabel;
    IBOutlet NSTextField *m_fileName;
    IBOutlet NSTextField *m_progressLabel;
    IBOutlet NSProgressIndicator *m_progress;
    IBOutlet NSButton *m_chooseFolder;
    IBOutlet NSButton *m_start;
    IBOutlet NSButton *m_help;
    IBOutlet NSButton *m_close;

    NSMutableArray *m_data;
    AppController *m_appController;
}

@property NSMutableArray *data;
@property IBOutlet NSTableView *table;


- (void) updateProgressAndTable: (double) value;
- (void) updateLabel: (NSString*) currentCopyingFileName;

- (IBAction) chooseDirectory: (NSButton*) sender;
- (IBAction) startCopy: (NSButton*) sender;
- (IBAction) help: (NSButton*) sender;
- (IBAction) close: (NSButton*) sender;

@end


