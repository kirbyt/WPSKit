# WPSKit

WPSKit contains various tidbits of code for iOS and Mac reused at White Peak Software for in-house and client projects. The WPSKit is licensed under the MIT license unless statement differently in the individual source files.

## Automatic Reference Counting

All code in WPSKit is ARC compatible with the following exceptions:

- Foundation/Reachability.m

You must include the compiler flag -fno-objc-arc for each of these files.

## Additional Apple Frameworks

WPSKit relies on additional frameworks from Apple. The following frameworks must be included in your project to use all the code in WPSKit.

- CoreData.framework (to use source code in the CoreData directory)
- CoreLocation.framework (to use source code in the CoreLocation directory) 
- SystemConfiguration.framework
