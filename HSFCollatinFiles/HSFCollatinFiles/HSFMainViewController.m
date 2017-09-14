//
//  HSFMainViewController.m
//  HSFCollatingFiles
//
//  Created by 胡双飞 on 2017/9/9.
//  Copyright © 2017年 胡双飞. All rights reserved.
//

#import "HSFMainViewController.h"
#import "XcodeProjectArrangementTool.h"
@interface HSFMainViewController (){
    NSString *projectPath;
}

@property (weak) IBOutlet NSTextFieldCell *xcodePathTextField;

@property (unsafe_unretained) IBOutlet NSTextView *unUsedFilesTextView;
@property (unsafe_unretained) IBOutlet NSTextView *usedFilesTextView;
@property (weak) IBOutlet NSTextField *explainLabel;
@property(nonatomic,strong) XcodeProjectArrangementTool *arrangementTool;
@property(nonatomic,strong) NSOpenPanel *openPanel;
@property (weak) IBOutlet NSTextField *specialFilesFidld;

@property (weak) IBOutlet NSPopUpButtonCell *selectItem;

@property (weak) IBOutlet NSTextField *subTitleLable;

@property (weak) IBOutlet NSButton *filterSwiftExtensionBtn;

@end

@implementation HSFMainViewController

-(void)awakeFromNib{
    self.usedFilesTextView.string = @"The classes that are used are shown here";
    self.unUsedFilesTextView.string = @"The classes that are unUsed are shown here";
    self.explainLabel.stringValue = @"1.enter xcodeproj path \n2.enter “search” button \n3.unusedFiles in “unUsedFiles” TextView \n4.Select unused files to Xcode to determine if they are useless\n\n --->>click “Save”button, Save the unused files name to the project directory and save them as ”plist“ files\n";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    __weak typeof(self) weakSelf = self;

    [self.arrangementTool setUsedClassBlock:^(NSString * usedClassSting) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.usedFilesTextView.string = usedClassSting;
            [weakSelf.usedFilesTextView scrollRectToVisible:NSMakeRect(0, 0, 0, 0)];
        
        });
    }];
    
    
    [self.arrangementTool setUnUsedClassBlock:^(NSString *unString,NSInteger count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.unUsedFilesTextView.string = unString;
            [weakSelf.unUsedFilesTextView scrollRectToVisible:NSMakeRect(0, 0, 0, 0)];
            weakSelf.subTitleLable.stringValue = [NSString stringWithFormat:@"May be useless Files -- %ld ",count];
        });
    }];
    
    self.arrangementTool.isSelect = self.filterSwiftExtensionBtn.state;
}

-(XcodeProjectArrangementTool *)arrangementTool{
    if (!_arrangementTool) {
        _arrangementTool = [[XcodeProjectArrangementTool alloc]init];
    }
    return _arrangementTool;
}



#pragma mark -- Action
- (IBAction)browseAction:(id)sender {
    
    self.xcodePathTextField.stringValue = @"";
    if (self.openPanel) {
        [self.openPanel close];
        self.openPanel = nil;
    }
    self.openPanel = [NSOpenPanel openPanel];
    
    
    [self.openPanel setCanChooseDirectories:YES];
    [self.openPanel setCanChooseFiles:YES];
    self.openPanel.allowsMultipleSelection = NO;
    
    [self.openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        
        if (result == NSModalResponseOK) {
            NSString *path = [[self.openPanel URL] path];
            self.xcodePathTextField.stringValue = path;
        }
 
    }];

}

- (IBAction)searchAction:(id)sender {
    self.usedFilesTextView.string = @"search Class ...";
    self.unUsedFilesTextView.string = @"search Class ...";
    self.arrangementTool.specialFilesStr = self.specialFilesFidld.stringValue;
    [self.selectItem selectItemAtIndex:0];
   
   BOOL isOK = [self.arrangementTool searchWithFilePath:[self.xcodePathTextField stringValue]];
    
    if (isOK) {
        projectPath = [self.xcodePathTextField stringValue];
    }
}

- (IBAction)saveAction:(id)sender {
    
    if (!projectPath) {

        NSAlert* errorAlert = [[NSAlert alloc] init];
        errorAlert.messageText = @" “Xcodeproj” path input error";
       
        [errorAlert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
        return;
    }
    
    NSString *lastPath = [NSString stringWithFormat:@"%@/XcodeProjectArrangement.txt",projectPath.stringByDeletingLastPathComponent];
    
    NSError* error;
    [self.unUsedFilesTextView.string writeToFile:lastPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
  
        NSAlert* okAlert = [[NSAlert alloc] init];
        okAlert.messageText = @"Save Ok To Project";
        [okAlert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
    }
}

- (IBAction)filterSwiftExtensionAction:(NSButton *)sender {
      self.arrangementTool.isSelect = self.filterSwiftExtensionBtn.state;
}

- (IBAction)selectFilesAction:(NSPopUpButton *)sender {
    
    if ([sender.title isEqualToString:@"AllClass"]) {
        self.unUsedFilesTextView.string = [self.arrangementTool allClass_Files];
        [self.unUsedFilesTextView scrollRectToVisible:NSMakeRect(0, 0, 0, 0)];
    }else if ([sender.title isEqualToString:@"Objec-C"]) {
        self.unUsedFilesTextView.string = [self.arrangementTool object_C_Files];
        [self.unUsedFilesTextView scrollRectToVisible:NSMakeRect(0, 0, 0, 0)];
    }else if ([sender.title isEqualToString:@"Swift"]) {
        self.unUsedFilesTextView.string = [self.arrangementTool swift_Files];
        [self.unUsedFilesTextView scrollRectToVisible:NSMakeRect(0, 0, 0, 0)];
    }
}



@end
