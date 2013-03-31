//
//  AsynchImageView.h
//  GetPix
//
//  Created by Darren Venn on 3/30/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MAX_TIME_TO_WAIT_FOR_IMAGE 30.0 // timeout if the image was not loaded after 30 seconds

@interface AsynchImageView : UIImageView

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSString *urlString;

- (id)initWithFrameURLStringAndTag:(CGRect)frame :(NSString*) urlString :(NSInteger) tag;
- (void)loadImageFromNetwork;

@end
