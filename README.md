# Atomic Wrapper
This library is used to create simple, thread-safe Atomic Value wrappers that make it easy to set and get values, as well as create thread-safe counters that can easily be incremented.  

# Setup
First, run this command in your project directory: `zig fetch --save  https://github.com/austinrtn/AtomicWrapper/archive/refs/tags/V1.0.tar.gz`

Then, add this to your `build.zig` file:

```zig
const atomic_wrapper_dep = b.dependency("AtomicWrapper", .{
    .target = target,
    .optimize = optimize,
});
exe.root_module.addImport("AtomicWrapper", atomic_wrapper_dep.module("AtomicWrapper"));
```

Finally, add this to the top of your Zig file of choice to use the library:
```zig
const AtomicWrapper = @import("AtomicWrapper").AtomicWrapper;
```

# Usage
The AtomicWrapper has two modes: Signaling and Counting.  This is determined by the AtomicWrapper's `mode` parameter
```zig
var is_loading = AtomicWrapper(bool, .Signaling).init(true);
var loop_counter = AtomicWrapper(usize, .Counting).init(0);
```
### Signaling
This is primarily used for simple, "single write communicates" such as bools, enums, pointers, and error types.  You can use the `get` and `set` functions to read and write the value across threads
```zig
var is_loading = AtomicWrapper(bool, .Signaling).init(true);

// In one thread: read the value
while (is_loading.get()) {
    // do work...
}

// In another thread: signal completion
is_loading.set(false);
```
## Counting
This is used to create thread-safe counters, and offers the user the `increment` and `reset` methods to increase the AtomicValue by 1.  Using a non-integer type along side with Counting mode will result in a compile-time error.
```zig
var loop_counter = AtomicWrapper(usize, .Counting).init(0);

// Increment from any thread
_ = loop_counter.increment();

// Read the current value
const count = loop_counter.get();

// Reset back to zero
loop_counter.reset();
```

