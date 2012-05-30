# WPSKit

WPSKit contains various tidbits of Objective-C code for iOS and Mac apps. This library is used at [White Peak Software](http://whitepeaksoftware.com) in in-house and client projects. WPSKit is licensed under the MIT license unless stated differently in the individual source files.

## Automatic Reference Counting

All code in WPSKit is ARC compatible with the following exceptions:

- Foundation/Reachability.m

You must include the compiler flag -fno-objc-arc for each of these files.

## Additional Apple Frameworks

WPSKit relies on additional frameworks from Apple. The following frameworks must be included in your project to use all the code in WPSKit.

- CoreData.framework (to use source code in the CoreData directory)
- CoreLocation.framework (to use source code in the CoreLocation directory) 
- MapKit.framework (to use source code in the MapKit directory)
- SystemConfiguration.framework

# Support, Bugs and Feature requests

There is absolutely **no support** offered for this library. You're on your own. If you want to submit a feature request, please do so via [the issue tracker on github](http://github.com/kirbyt/WPSKit/issues). Please note, however, new features will only be added if and when there is a need for the feature at White Peak Software. The primary goal of this library is to support White Peak Software projects, and a feature you deem as a "must have" might not be a must have for White Peak Software.

If you want to submit a bug report, please do so via the [issue tracker](http://github.com/kirbyt/WPSKit/issues). Include a diagnosis of the problem and a suggested fix (in code) with the report. If you're using WPSKit, you're a developer - so I expect you to do your homework and provide a fix along with each bug report. You can also submit pull requests or patches.

Please don't submit bug reports without fixes!

# License

The MIT License  

Copyright (c) 2010-2012 White Peak Software Inc

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.