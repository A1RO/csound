/*
 
 CsoundSwitchBinder.m:
 
 Copyright (C) 2014 Steven Yi, Aurelius Prochazka
 
 This file is part of Csound for iOS.
 
 The Csound for iOS Library is free software; you can redistribute it
 and/or modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 Csound is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with Csound; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
 02111-1307 USA
 
 */

#import "CsoundSwitchBinder.h"

@interface CsoundSwitchBinder()
@property float channelValue;
@property float *channelPtr;
@property (unsafe_unretained) NSString *channelName;
@property (unsafe_unretained) UISwitch *switcher;
@end

@implementation CsoundSwitchBinder

-(void)updateChannelValue:(id)sender {
    self.channelValue = ((UISwitch *)sender).on ? 1 : 0;
}

-(instancetype)init:(UISwitch *)uiSwitch channelName:(NSString *)channelName
{
    if (self = [super init]) {
        self.switcher = uiSwitch;
        self.channelName = channelName;
    }
    return self;
}

-(void)setup:(CsoundObj*)csoundObj
{
    self.cachedValue = self.mSwitch.on ? 1 : 0;
    self.channelPtr = [csoundObj getInputChannelPtr:self.channelName
                                        channelType:CSOUND_CONTROL_CHANNEL];
    [self.mSwitch addTarget:self
                     action:@selector(updateValueCache:)
           forControlEvents:UIControlEventValueChanged];
}


-(void)updateValuesToCsound {
    *self.channelPtr = self.cachedValue;
}

-(void)cleanup {
    [self.mSwitch removeTarget:self
                        action:@selector(updateValueCache:)
              forControlEvents:UIControlEventValueChanged];
}

@end
