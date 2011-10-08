# WPSKit

WPSKit contains various tidbits of code for iOS and Mac reused at White Peak Software for in-house and client projects. The WPSKit is under the MIT license.

## Automatic Reference Counting

All code in WPSKit is ARC compatible with the following exceptions:

- Foundation/Reachability.m

You must include the compiler flag -fno-objc-arc for each of these files.

## Additional Apple Frameworks

WPSKit relies on additional frameworks from Apple. The following frameworks must be included in your project to use all the code in WPSKit.

- CoreData.framework
- SystemConfiguration.framework
