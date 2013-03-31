//
//  AsynchImageView.m
//  GetPix
//
//  Created by Darren Venn on 3/30/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import "AsynchImageView.h"

@implementation AsynchImageView

// This class implements a "self-loading" UIImageView, with each image containing it's own NSURLConnection.
// When a new AsynchImageView is created, the frame etc. are set up, but the image itself is not loaded until
// the loadImageFromNetwork method is called.

// lazy instantiating getter for data
- (NSMutableData*) data {
    if (_data == nil) {
        _data = [NSMutableData data];
    }
    return _data;
}

- (id)initWithFrameURLStringAndTag:(CGRect)frame :(NSString*) urlString :(NSInteger) tag;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.urlString = urlString;
        // image is grey tile before loading
        self.backgroundColor = [UIColor grayColor];
        // set the tag so we can find this image on the UI if we need to
        self.tag = tag;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrameURLStringAndTag:frame :@"" :0];
}

- (void)loadImageFromNetwork {
    
    // spawn a new thread to load the image in the background, from the network
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:MAX_TIME_TO_WAIT_FOR_IMAGE];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // if the load faield then draw a timeout message on the image here, instead of displaying the actual image...
    self.image=[UIImage imageNamed:@"TimeOut.jpg"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.darrenvenn.completedImageLoad" object:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // we have received the complete image, so update it now and notify the ShowPix VC that we have completed...
    self.image=[UIImage imageWithData:self.data];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.darrenvenn.completedImageLoad" object:nil];
}

@end
