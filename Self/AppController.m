//
//  AppController.m
//  Self
//
//  Created by MariyaShestakova on 6/30/19.
//  Copyright © 2019 MariyaShestakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "AppController.h"


@implementation MyDataObject

@synthesize number = m_number;
@synthesize fileName = m_fileName;

- (id) initWithNumber: (int)number fileName: (NSString*)fileName
{
    if (self = [super init])
    {
        self.number = number;
        self.fileName = fileName;
    }
    return self;
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation AppController

@synthesize directoryName = m_directoryName;
@synthesize directoryToCopy = m_directoryToCopyName;
@synthesize currentFileName = m_currentFileName;
@synthesize lastCopiedFileName = m_lastCopiedFile;
@synthesize progressValue = m_progressValue;
@synthesize summarySize = m_summarySize;

static const unsigned int g_defaultNumberOfFiles = 20;

- (id) init
{
    if (self = [super init])
    {
        self.directoryName = @"";
        self.directoryToCopy = @"";
        self.currentFileName = @"";
        self.lastCopiedFileName = @"";
        self.progressValue = 0.0;
        self.summarySize = 0.0;
        
        self->m_tableOfFileLengths = [NSMutableArray arrayWithCapacity: g_defaultNumberOfFiles];
        self->m_tableOfRelativeFileLengths = [NSMutableArray arrayWithCapacity: g_defaultNumberOfFiles];
    }
    return self;
}

- (void) prepareToCopy: (NSFileManager*) manager
{
    if ([self.directoryName isEqualToString: @""])
    {
        return;
    }
    
    NSDirectoryEnumerator *dirEnum;
    dirEnum = [manager enumeratorAtPath: self.directoryName];
    
    BOOL isDirectory;
    NSString *fileName;
    NSNumber *fileSize;
    while (fileName = [dirEnum nextObject])
    {
        [manager fileExistsAtPath: [self.directoryName stringByAppendingString: fileName] isDirectory: &isDirectory];
        if (!isDirectory)
        {
            fileSize = [[manager attributesOfItemAtPath: [self.directoryName stringByAppendingString: fileName] error: nil] objectForKey: NSFileSize];
            if (fileSize)
            {
                self.summarySize += [fileSize doubleValue];
                [m_tableOfFileLengths addObject: fileSize];
            }
        }
        else
        {
            [dirEnum skipDescendents];
        }
    }
    
    double_t tmpValue;
    for (NSNumber *fileLength in m_tableOfFileLengths)
    {
        tmpValue = [fileLength doubleValue] / m_summarySize * 100;
        
        [m_tableOfRelativeFileLengths addObject: [NSNumber numberWithDouble: tmpValue]];
    }
    
    self.directoryToCopy = @"/Users/mariyashestakova/Documents/Copy/";
    
    NSError *errorOfCreating;
    if (![manager createDirectoryAtPath: self.directoryToCopy withIntermediateDirectories: YES attributes: nil error: &errorOfCreating])
    {
        NSLog(@"Directory didn't create successfully");
        NSLog(@"%@", errorOfCreating);
    }
}

- (void) copyFiles: (ViewController*) viewController
{
    NSFileManager *manager  = [NSFileManager defaultManager];
    
    [self prepareToCopy: manager];
    
    NSDirectoryEnumerator * dirEnum = [manager enumeratorAtPath: self.directoryName];
    
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        BOOL isDirectory;
        NSString *fileName;
        int32_t index = 0;
        while (fileName = [dirEnum nextObject])
        {
            [manager fileExistsAtPath: [self.directoryName stringByAppendingString: fileName] isDirectory: &isDirectory];
            if (!isDirectory)
            {
                sleep(2);
                
                NSError *error;
                if (![manager copyItemAtPath: [self.directoryName stringByAppendingString: fileName] toPath: [self.directoryToCopy stringByAppendingString: fileName] error: &error])
                {
                    NSLog(@"%@", error);
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.lastCopiedFileName = fileName;
                    [viewController updateLabel: fileName];
                    
                    MyDataObject* data = [[MyDataObject alloc] initWithNumber: (index + 1) fileName: self.lastCopiedFileName];
                    [viewController.data addObject: data];
                    
                    self.progressValue += [[self->m_tableOfRelativeFileLengths objectAtIndex: index] doubleValue];
                    [viewController updateProgressAndTable: self.progressValue];
                });
                
                ++index;
            }
            else
            {
                [dirEnum skipDescendents];
            }
        }
    });
}
    

@end



