//
//  XcodeProjectArrangementTool.h
//  HSFCollatingFiles
//
//  Created by 胡双飞 on 2017/9/13.
//  Copyright © 2017年 胡双飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XcodeProjectArrangementTool : NSObject

@property(nonatomic,copy)void(^usedClassBlock) (NSString *usedClassString);

@property(nonatomic,copy)void(^unUsedClassBlock) (NSString *unUsedClassString,NSInteger count);


/**
 button select
 */
@property(nonatomic,assign)BOOL isSelect;
/**
 Filter special files
 */
@property(nonatomic,copy)NSString *specialFilesStr;

/**
 *  start search Action
 *
 *  @param path .xcodeproj path
 */
-(BOOL)searchWithFilePath:(NSString *)path;


/**
 get All unusedFiles

 @return All unusedFiles
 */
-(NSString *)allClass_Files;

/**
 get object_C Files

 @return object_C Files
 */
-(NSString *)object_C_Files;

/**
 get swift_Files

 @return swift_Files
 */
-(NSString *)swift_Files;
@end
