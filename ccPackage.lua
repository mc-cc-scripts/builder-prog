local spath =
    debug.getinfo(1,'S').source:sub(2):gsub("/+", "/"):gsub("[^/]*$","")
package.path = spath.."?.lua;"
    .. spath.."turtleController-lib/?.lua;"
    .. package.path
require(spath.."turtleEmulator-lib/ccPackage")