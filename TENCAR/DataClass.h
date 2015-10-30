@interface DataClass : NSObject {
    
    NSDate *from_date;
    NSDate *to_date;
}

@property(nonatomic,retain)NSDate *from_date;
@property(nonatomic,retain)NSDate *to_date;
+(DataClass*)getInstance;
@end