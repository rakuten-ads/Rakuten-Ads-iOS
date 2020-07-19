//
//  RUNACacheFile.m
//  Core
//
//  Created by Wu, Wei b on R 2/07/17.
//  Copyright © Reiwa 2 Rakuten MPD. All rights reserved.
//

#import "RUNACacheFile.h"

@implementation RUNACacheFile

-(instancetype)initWithName:(NSString *)fileName {
    self = [super init];
    if (self) {
        self->_fileName = fileName;
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if (paths.count > 0) {
            NSString* path = [paths objectAtIndex:0];
            self->_abstractPath = [path stringByAppendingPathComponent:self.fileName];
        }
    }
    return self;
}

-(BOOL)isExist {
    return [[NSFileManager defaultManager] fileExistsAtPath:self.abstractPath isDirectory:nil];
}

-(BOOL)writeData:(NSData *)data {
    if (self.abstractPath && data) {
        return [data writeToFile:self.abstractPath atomically:YES];
    }
    return NO;
}

-(NSString *)readStringWithError:(NSError**) error {
    if (self.isExist) {
        return [NSString stringWithContentsOfFile:self.abstractPath encoding:NSUTF8StringEncoding error:error];
    }
    return nil;
}

@end
