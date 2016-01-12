//
//  MCExceptionLog.h
//
// Copyright (c) 2015 czxghostyueqiu (http://blog.csdn.net/czxghostyueqiu)
//

#import "MCExceptionLog.h"

#define LogPath @"MCLog"

#define ErrorFile @"UncaughtException.log"

@implementation MCExceptionLog {
    /*

     */
    BOOL _isDebugLog;
    BOOL _isDebugUncaughtException;
    NSString * _timeFormat;
}

+ (MCExceptionLog *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (id)init {
    self = [super init];
    if (self) {
        _timeFormat = @"yyyy-MM-dd";
        _isDebugLog = NO;
        _isDebugUncaughtException = NO;

    }
    return self;
}
//Debug模式不记录普通记录
- (void)MCCloseLogDubug {
#ifdef DEBUG
    _isDebugLog = YES;
#else
    _isDebugLog = NO;
#endif
}
//Debug模式不记录错误记录
- (void)MCCloseErrorDubug {
#ifdef DEBUG
    _isDebugUncaughtException = YES;
#else
    _isDebugUncaughtException = NO;
#endif
}

//删除一搬记录文件
- (void)MCRemoveLog {
    for (NSString * path in [self MCGetAllFile]) {
        if (![path isEqualToString:ErrorFile]) {
            NSString *logDirectory = [[self MCGetMainPath] stringByAppendingPathComponent:path];
            NSFileManager *defaultManager = [NSFileManager defaultManager];
            [defaultManager removeItemAtPath:logDirectory error:nil];
        }
    }
    [self MCCreateDir];
}
//获取错误文件路径
- (NSString *)MCErrorFilePath {
    NSString *logDirectory = [self MCGetMainPath];
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:ErrorFile];
    return logFilePath;
}
//删除错误记录文件
- (void)MCRemoveError {
    NSString *logDirectory = [self MCGetMainPath];
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:ErrorFile];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    [self MCCreateDir];
}
//删除所有文件
- (void)MCRemoveAllFile {
    NSString *logDirectory = [self MCGetMainPath];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logDirectory error:nil];
    [self MCCreateDir];
}
//获取指定日期的文件
- (NSString *)MCTimeFile:(NSString *)time {
    NSString *logDirectory = [self MCGetMainPath];
    NSString *timeFilePath = [NSString stringWithFormat:@"%@/%@.log",logDirectory,time];
    return [self readFile:timeFilePath];
}
//获取指定文件
- (NSString *)MCLogFile:(NSString *)name {
    NSString *logDirectory = [self MCGetMainPath];
    NSString *FilePath = [NSString stringWithFormat:@"%@/%@.log",logDirectory,name];
    return [self readFile:FilePath];
}
//获取今天消息
- (NSString *)MCTodayLog {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:_timeFormat];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *logDirectory = [self MCGetMainPath];
    NSString *FilePath = [NSString stringWithFormat:@"%@/%@.log",logDirectory,dateStr];
    return [self readFile:FilePath];
}
//获取错误消息
- (NSString *)MCErrorLog {
    NSString *logDirectory = [self MCGetMainPath];
    NSString *FilePath = [NSString stringWithFormat:@"%@/%@",logDirectory,ErrorFile];
    return [self readFile:FilePath];
}
//读取文件
- (NSString *)readFile:(NSString *)filepath{
    NSFileManager * mgr = [NSFileManager defaultManager];
    BOOL dir=NO;
    BOOL exists =[mgr fileExistsAtPath:filepath isDirectory:&dir];
    if (exists) {
        return [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    }else {
        return nil;
    }
}
//获取路径下所有文件
- (NSArray *)MCGetAllFile {
    NSString *logDirectory = [self MCGetMainPath];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:logDirectory error:nil];
    return files;
}
//记录所有打印
- (void)MCRecordNSlog
{
    
    NSString *logDirectory = [self MCGetMainPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:_timeFormat];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.log",dateStr];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}
- (void)MCSetFormatter:(NSString *)format {
    _timeFormat = [format copy];
}
//记录错误打印
- (void)MCRecordErrorLog {
    if (_isDebugUncaughtException == YES) {
        return;
    }
    NSSetUncaughtExceptionHandler(&MCUncaughtExceptionHandler);
}
- (NSString *)MCGetMainPath {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:LogPath];
}
void MCUncaughtExceptionHandler(NSException* exception)
{
    NSString* name = [ exception name ];
    NSString* reason = [ exception reason ];
    
    NSArray* symbols = [exception callStackSymbols ];
    if ([MCExceptionLog sharedInstance].isRecordStack) {
        symbols = [exception callStackSymbols];
    }else {
        symbols = nil;
    }
    
    NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ];
    for ( NSString* item in symbols )
    {
        [ strSymbols appendString: item ];
        [ strSymbols appendString: @"\r\n" ];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:LogPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logDirectory]) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:ErrorFile];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *crashString;
    if ([MCExceptionLog sharedInstance].isRecordStack) {
        crashString = [NSString stringWithFormat:@"<- %@ ->[ Uncaught Exception ]\r\nName: %@, Reason: %@\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]\r\n\r\n", dateStr, name, reason, strSymbols];
    }else {
        crashString = [NSString stringWithFormat:@"<- %@ ->[ Uncaught Exception ]\r\nName: %@, Reason: %@\r\n\r\n\r\n", dateStr, name, reason];
    }
    if (![fileManager fileExistsAtPath:logFilePath]) {
        [crashString writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        [outFile seekToEndOfFile];
        [outFile writeData:[crashString dataUsingEncoding:NSUTF8StringEncoding]];
        [outFile closeFile];
    }
}
- (void)MCCreateDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:LogPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logDirectory]) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:ErrorFile];

    NSString *crashString = @"\n";
    if (![fileManager fileExistsAtPath:logFilePath]) {
        [crashString writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        [outFile seekToEndOfFile];
        [outFile writeData:[crashString dataUsingEncoding:NSUTF8StringEncoding]];
        [outFile closeFile];
    }
}
@end

