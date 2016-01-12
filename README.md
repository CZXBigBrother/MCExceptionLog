# MCExceptionLog 记录捕获的错误的信息

使用方法 
在Appdelegate中初始化代码

    MCExceptionLog * error = [MCExceptionLog sharedInstance];
    error.isRecordStack = NO;
    [error MCRecordErrorLog];

/**
 *  初始化
 */
+ (MCExceptionLog *)sharedInstance;

///------------------------------------------------
/// 记录错误消息
///------------------------------------------------
/**
 *  记录错误消息
 */
- (void)MCRecordErrorLog;

/**
 *  获取错误消息
 */
- (NSString *)MCErrorLog;
/**
 *  获取错误文件路径
 */
- (NSString *)MCErrorFilePath;

///------------------------------------------------
/// 记录所有消息
///------------------------------------------------
/**
 *  记录所有消息
 */
- (void)MCRecordNSlog;

/**
 *  获取今天消息
 */
- (NSString *)MCTodayLog;
/**
 *  获取指定日期的消息(默认格式:yyyy-MM-dd)
 */
- (NSString *)MCTimeFile:(NSString *)time;

/**
 *  设置存储日期格式
 */
- (void)MCSetFormatter:(NSString *)format;

/**
 *  获取指定文件
 */
- (NSString *)MCLogFile:(NSString *)name;

/**
 *  获取所有文件
 */
- (NSArray *)MCGetAllFile;


///------------------------------------------------
/// 是否在Dubug模式做记录
///------------------------------------------------
/**
 *  Debug模式不记录普通记录
 */
- (void)MCCloseLogDubug;

/**
 *  Debug模式不记录错误记录
 */
- (void)MCCloseErrorDubug;


///------------------------------------------------
/// 删除文件
///------------------------------------------------
/**
 *  删除一般记录文件
 */
- (void)MCRemoveLog;

/**
 *  删除错误记录文件
 */
- (void)MCRemoveError;

/**
 *  删除所有文件
 */
- (void)MCRemoveAllFile;
