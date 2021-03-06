//
//  ViewController.m
//  DB
//
//  Created by ShaoFeng on 16/7/8.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
@interface ViewController ()
@property (nonatomic,strong)FMDatabaseQueue *queue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"contact.sqlite"];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    [_queue inDatabase:^(FMDatabase *db) {
        //创建数据表
        BOOL flag = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS T_USER (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, age INTEGER);"];
        if (flag) {
            NSLog(@"表创建成功");
        } else {
            NSLog(@"表创建失败");
        }
    }];
}

//为数据表插入数据
- (IBAction)insert:(id)sender {
    
    __block BOOL flag;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        @try {
            flag = [db executeUpdate:@"INSERT INTO T_USER (name,age) VALUES (?,?)",@"少锋",@18];
            
        } @catch (NSException *exception) {
            *rollback = YES;
            flag = NO;
            
        } @finally {
            *rollback=!flag;
        }
    }];
    
    
    //    [_queue inDatabase:^(FMDatabase *db) {
    //        BOOL flag = [db executeUpdate:@"INSERT INTO T_USER (name,age) VALUES (?,?)",@"少锋",@18];
    //        if (flag) {
    //            NSLog(@"数据添加成功");
    //        } else {
    //            NSLog(@"数据添加失败");
    //        }
    //    }];
}

//为数据表删除数据,表任然存在
- (IBAction)delete:(id)sender {
    
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL flag = [db executeUpdate:@"DELETE FROM T_USER;"];
        if (flag) {
            NSLog(@"数据删除成功");
        } else {
            NSLog(@"数据删除失败");
        }
    }];
}

//更新数据表数据
- (IBAction)update:(id)sender {
    
    __block BOOL flag;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        @try {
            flag = [db executeUpdate:@"UPDATE T_USER SET age = ?",@20];
            
        } @catch (NSException *exception) {
            *rollback = YES;
            flag = NO;
            
        } @finally {
            *rollback=!flag;
        }
    }];
    
    //    [_queue inDatabase:^(FMDatabase *db) {
    //
    //        //开启事务
    //        [db beginTransaction];
    //        BOOL flag = [db executeUpdate:@"UPDATE T_USER SET age = ?",@20];
    //        if (flag) {
    //            NSLog(@"数据更新成功");
    //        } else {
    //            NSLog(@"数据更新失败");
    //            //事务回滚
    //            [db rollback];
    //        }
    //        //提交事务
    //        [db commit];
    //    }];
}

//查询数据表数据
- (IBAction)select:(id)sender {
    
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM T_USER"];
        
        while ([result next]) {
            NSString *name = [result stringForColumn:@"name"];
            NSString *age = [result stringForColumn:@"age"];
            NSLog(@"%@---%@",name,age);
        }
    }];
}

//删除数据表
- (IBAction)drop:(id)sender {
    
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL flag = [db executeUpdate:@"DROP TABLE IF EXISTS T_USER"];
        if (flag) {
            NSLog(@"数据表删除成功");
        } else {
            NSLog(@"数据表删除失败");
        }
    }];
}

@end
