I am the artificial identifer of an object. Two objects with the same identifier are assumed to represent two versions of the same object, which was captured at different points in time. Objects may be decorated with a SquotNameDecorator to attach the name directly to an object, or they may get names assigned in SquotShadowGraph/SquotObjectGraph. Usually the names are also entered in a SquotObjectRegistry, so that the names remain stable for a single object even if the working copy gets dissolved at some point.

At this time, I have no instances. The identifers are instead arrays which are built like this:
From the root of an object graph, each array element is the name of an instance variable or other reference to reach the next object on the path to the object that has this name. The last element of the array is a UUID. The UUID alone is enough to find two instances of the same object, but the trail of references makes it easiser for the human to see by the name where this object was encountered, and thus which object it should be.

This class currently only serves utility methods to deal with object names.