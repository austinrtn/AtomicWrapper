# Atomic Wrapper
This library is used to create simple, thread-safe Atomic Value wrappers that make it easy to set and get values, as well as create thread-safe counters that can easily be incremented.  

# Setup
First, run this command in your project directory: `zig fetch --save`

Then, add this to your `build.zig` file: 

```zig

```

Finally, add the library to your Zig file of choice:
```zig
```

# Usage
The AtomicWrapper has two modes: Signaling and Counter.  This is determined by the  AtomicWrapper's `mode` parameter
```zig
```
### Signaling
This is primarily used for simple, "single write communicates" such as bools, enums, pointers, and error types.  You can use the `get` and `set` functions to read and write the value across threads
```
```
## Counting
This is used to create thread-safe counters, and offers the user the `increment` and `reset` methods to increase the AtomicValue by 1.  Using a non-integer type along side with Counting mode will result in a compile-time error.
```zig
```

