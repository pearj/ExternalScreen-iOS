//
//  PGExternalScreen.m
//  MultiScreenPlugin
//
//  Created by Andrew Trice on 1/9/12.
//
//
// THIS SOFTWARE IS PROVIDED BY THE ANDREW TRICE "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
// EVENT SHALL ANDREW TRICE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "PGExternalScreen.h"


@implementation PGExternalScreen


NSString* WEBVIEW_UNAVAILABLE = @"External Web View Unavailable";
NSString* WEBVIEW_OK = @"OK";
NSString* SCREEN_NOTIFICATION_HANDLERS_OK =@"External screen notification handlers initialized";
NSString* SCREEN_CONNECTED =@"connected";
NSString* SCREEN_DISCONNECTED =@"disconnected";

//used to load an HTML file in external screen web view
- (void) loadHTMLResource:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSArray *arguments = command.arguments;

    CDVPluginResult* pluginResult;
    
    if (webView)
    {
        
        NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0];

        
        NSRange textRange;
        textRange =[[stringObtainedFromJavascript lowercaseString] rangeOfString:@"http://"];
        NSError *error = nil;
        NSURL *url;
        
        //found "http://", so load remote resource
        if(textRange.location != NSNotFound)
        {
            url = [NSURL URLWithString:stringObtainedFromJavascript];       
            //[url retain];
        }
        //load local resource
        else
        {
            
            NSString* path = [NSString stringWithFormat:@"%@/%@", baseURLAddress, stringObtainedFromJavascript];
            //[path retain];
            url = [NSURL fileURLWithPath:path isDirectory:NO];
            //[url retain];
            //[path release];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        
        //[url release];
        //[stringObtainedFromJavascript release];
        
        if(error) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: [error localizedDescription]];        
            [self writeJavascript: [pluginResult toErrorCallbackString:callbackId]];    
        }  
        else
        {
            if (screenNeedsInit) {
                [self makeScreenVisible];
            }

            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: WEBVIEW_OK];
            [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
        }
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: WEBVIEW_UNAVAILABLE];        
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackId]];    
    }
}

//used to load an HTML string in external screen web view
- (void) loadHTML:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSArray *arguments = command.arguments;

    CDVPluginResult* pluginResult;
    
    if (webView)
    {
        NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0]; 
        //[stringObtainedFromJavascript retain];
        [webView loadHTMLString:stringObtainedFromJavascript baseURL:baseURL];
        //[stringObtainedFromJavascript release];
        
        if (screenNeedsInit) {
            [self makeScreenVisible];
        }

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: WEBVIEW_OK];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: WEBVIEW_UNAVAILABLE];        
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackId]];    
    }
    
}

//used to invoke javascript in external screen web view
- (void) invokeJavaScript:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSArray *arguments = command.arguments;

    CDVPluginResult* pluginResult;
    
    if (webView)
    {
        NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0]; 
        //[stringObtainedFromJavascript retain];
        [webView stringByEvaluatingJavaScriptFromString: stringObtainedFromJavascript];
        //[stringObtainedFromJavascript release];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: WEBVIEW_OK];
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: WEBVIEW_UNAVAILABLE];        
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackId]];    
    }
    
}

//used to initialize monitoring of external screen
- (void) setupScreenConnectionNotificationHandlers:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(handleScreenConnectNotification:)
                   name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(handleScreenDisconnectNotification:)
                   name:UIScreenDidDisconnectNotification object:nil];
    
    [self attemptSecondScreenView];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: SCREEN_NOTIFICATION_HANDLERS_OK];
    
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
}

//used to determine if an external screen is available
- (void) checkExternalScreenAvailable:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    
    NSString* result = nil;
    if ([[UIScreen screens] count] > 1) {  
        result = @"YES";
    }
    else
    {
        result = @"NO";
    }
    //[result retain];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: result];
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    //[result release];
}

// Register the callbackId which will be a persistent callback that will be invoked when the screen connection status changes.
- (void) registerForNotifications:(CDVInvokedUrlCommand*)command
{
    _callbackId = command.callbackId;
}


//invoked when an additional screen is connected to iOS device (VGA or Airplay)
- (void)handleScreenConnectNotification:(NSNotification*)aNotification
{
    if (!externalWindow)
    {
        [self attemptSecondScreenView];
    }
}

//invoked when an additional screen is disconnected 
- (void)handleScreenDisconnectNotification:(NSNotification*)aNotification
{
    if (externalWindow)
    {
        externalWindow.hidden = YES;
        //[externalWindow release];
        externalWindow = nil;    }
    
    if (webView)
    {
        //[webView release];
        webView = nil;
    }
    
    if (_callbackId) {
        // Send notification
        [self sendNotification:SCREEN_DISCONNECTED];
    }
}


- (void) attemptSecondScreenView
{
    if ([[UIScreen screens] count] > 1) {
        
    // Internal display is 0, external is 1.
    //externalScreen = [[[UIScreen screens] objectAtIndex:1] retain];
        externalScreen = [[UIScreen screens] objectAtIndex:1];
        
        CGRect        screenBounds = externalScreen.bounds;
        
        externalWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        externalWindow.screen = externalScreen;
        
        externalWindow.frame = screenBounds;
        externalWindow.clipsToBounds = YES;
        
        webView = [[UIWebView alloc] initWithFrame:screenBounds];

        baseURLAddress = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www"];
        
        baseURL = [NSURL URLWithString:baseURLAddress];

        // If we have a callback we don't want to initialise the screen with a loading message, instead notify javascript and make visible later.
        if (_callbackId) {
            screenNeedsInit = YES;
            
            // Since we have a callback we're going to assume that content is about to be loaded so we probably want a black background
            [webView setBackgroundColor:[UIColor blackColor]];
            

            // Send notification
            [self sendNotification:SCREEN_CONNECTED];
        }
        else {
            [webView loadHTMLString:@"loading..." baseURL:baseURL];

            [self makeScreenVisible];
        }
    }
    else
    {
        externalWindow.hidden = YES;
    }
}

// Make the second screen visible.
- (void) makeScreenVisible
{
    [externalWindow addSubview:webView];
    [externalWindow makeKeyAndVisible];
    externalWindow.hidden = NO;
    screenNeedsInit = NO;
}

// Let javascript know that the screen connection status has changed.
- (void) sendNotification:(NSString*)message
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: message];

    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:_callbackId];
}

@end
