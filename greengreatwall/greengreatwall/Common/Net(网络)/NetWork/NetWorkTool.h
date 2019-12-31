//
//  NetWorkTool.h
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/10/25.
//  Copyright © 2019 葛朋. All rights reserved.
//

/*
一 封装的目的:
1. 集约管理,如需更换网络管理工具可以轻松应对
2. 单例的 AFHTTPSessionManager 实例避免内存泄漏,
3. 单例可以共享 NSURLSession 中的 TCP 通道避免多次握手

二 目前只有四种网络请求方式:
1. 普通的服务器接口API GET请求
2. 普通的服务器API POST请求
3. 资源文件的上传根据文件路径
4. 资源文件的上传根据 NSData

三 设置BaseURL
设置BaseURL可以使在此目标服务器的地址,带不带域名都可以

四 注意:
   如果需要修改 AFManager 的序列化配置来进行请求的话(比如进行图片下载),
   请增加另外一个AFHTTPSessionManager实例, 避免在多线程的情况下修改 AFManager 造成线程不安全.
*/

#import <Foundation/Foundation.h>
@class AFNetworking;
NS_ASSUME_NONNULL_BEGIN

@interface NetWorkTool : NSObject

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;


/**
 根据文件的路径进行上传, 下列参数除了block, 全部不能为nil

 @param URLString 服务器API地址
 @param filePath 需上传的文件的完整路径(包含文件名和后缀)
 @param fileName 保存在服务器上的文件名(注意名的唯一性,带上后缀避免让服务器推断文件类型)
 @param name 服务器用来解释文件的字段,由服务器提供
 @param mimeType 文件类型常用的: (.jpeg 或 .jpe : image/jpeg) , (.png : image/png) , (.mov : video/quicktime) , (.wav : audio/x-wav)
 @param parameters API参数字典
 @param uploadProgress 上传进度回调
 @param success 上传成功回调
 @param failure 上传失败回调
 @return 上传任务实例,可以用于取消等
 */
- (NSURLSessionDataTask *)upload:(NSString *)URLString
                        filePath:(NSString *)filePath
                        fileName:(NSString *)fileName
                            name:(NSString *)name
                        mimeType:(NSString *)mimeType
                      parameters:(id)parameters
                        progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 根据文件的NSData进行上传, 下列参数除了block, 全部不能为nil
 
 @param URLString 服务器API地址
 @param fileData 需上传的文件的 NSData
 @param fileName 保存在服务器上的文件名(注意名的唯一性,带上后缀避免让服务器推断文件类型)
 @param name 服务器用来解释文件的字段,由服务器提供
 @param mimeType 文件类型常用的: (.jpeg 或 .jpe : image/jpeg) , (.png : image/png) , (.mov : video/quicktime) , (.wav : audio/x-wav)
 @param parameters API参数字典
 @param uploadProgress 上传进度回调
 @param success 上传成功回调
 @param failure 上传失败回调
 @return 上传任务实例,可以用于取消等
 */
- (NSURLSessionDataTask *)upload:(NSString *)URLString
                        fileData:(NSData *)fileData
                        fileName:(NSString *)fileName
                            name:(NSString *)name
                        mimeType:(NSString *)mimeType
                      parameters:(id)parameters
                        progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
