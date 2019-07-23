//
//  AppController.h
//  Self
//
//  Created by MariyaShestakova on 6/30/19.
//  Copyright © 2019 MariyaShestakova. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class ViewController;

@interface AppController : NSObject
{
    NSString *m_directoryName;
    NSString *m_directoryToCopyName;
    NSString *m_currentFileName;
    NSString *m_lastCopiedFile;
    double_t m_progressValue;
    double_t m_summarySize;
    
    NSMutableArray *m_tableOfFileLengths;
    NSMutableArray *m_tableOfRelativeFileLengths;
}

@property NSString *directoryName;
@property NSString *directoryToCopy;
@property NSString *currentFileName;
@property NSString *lastCopiedFileName;
@property double_t progressValue;
@property double_t summarySize;

- (id) init;
- (void) prepareToCopy: (NSFileManager*) manager;
- (void) copyFiles: (ViewController*) viewController;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MyDataObject : NSObject
{
    int m_number;
    NSString* m_fileName;
}

@property int number;
@property (copy) NSString* fileName;

- (id) initWithNumber: (int) number fileName: (NSString*) fileName;

@end



