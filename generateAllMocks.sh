#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "${DIR}"
cd ./Authorization
./../Pods/SwiftyMocky/bin/swiftymocky generate
cd ../Course
./../Pods/SwiftyMocky/bin/swiftymocky generate
cd ../Dashboard
./../Pods/SwiftyMocky/bin/swiftymocky generate
cd ../Discovery
./../Pods/SwiftyMocky/bin/swiftymocky generate
cd ../Discussion
./../Pods/SwiftyMocky/bin/swiftymocky generate
cd ../Profile
./../Pods/SwiftyMocky/bin/swiftymocky generate
cd ../WhatsNew
./../Pods/SwiftyMocky/bin/swiftymocky generate