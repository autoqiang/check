//
//  ObJectToDictionary.m
//  chat demo
//
//  Created by auto on 2017/3/13.
//  Copyright © 2017年 auto. All rights reserved.
//

#import "ObJectToDictionary.h"

@implementation ObJectToDictionary
+(NSDictionary *)ObjectToDictionary:(id)Object{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary] ;
    unsigned int propsCount ;
    objc_property_t * props = class_copyPropertyList([Object class], &propsCount) ;
    for (int i = 0; i < propsCount; i++) {
        objc_property_t prop = props[i] ;
        NSString * propName = [NSString stringWithUTF8String:property_getName(prop)] ;
        id value = [Object valueForKey:propName] ;
        if (value==nil) {
            value = [NSNull null] ;
        }else{
            value = [self getObjectInternal:value] ;
        }
        [dic setObject:value forKey:propName] ;
    }
    return dic ;
}
+(id)getObjectInternal:(id)Object{
    if ([Object isKindOfClass:[NSString class]]||[Object isKindOfClass:[NSNumber class]]||[Object isKindOfClass:[NSNull class]]) {
        return Object ;
    }
    if ([Object isKindOfClass:[NSArray class]]) {
        NSArray * temp = Object ;
        NSMutableArray * mutablearray = [NSMutableArray arrayWithCapacity:temp.count] ;
        for (int i = 0; i<temp.count; i++) {
            [mutablearray setObject:[self getObjectInternal:[temp objectAtIndex:i]] atIndexedSubscript:i] ;
        }
        return mutablearray ;
    }
    if ([Object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *temp = Object ;
        NSMutableDictionary * mutabledictionary =[NSMutableDictionary dictionaryWithCapacity:[temp count]] ;
        for (NSString *key in temp.allKeys) {
            [mutabledictionary setObject:[self getObjectInternal:[temp objectForKey:key]] forKey:key] ;
        }
        return mutabledictionary ;
    }
    return [self ObjectToDictionary:Object] ;
}
@end
