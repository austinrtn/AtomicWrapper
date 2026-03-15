const std = @import("std");

pub const Mode = enum {
    Signaling, 
    Counting,
};

pub fn AtomicWrapper(comptime T: type, comptime mode: Mode) type {
    if(mode == .Signaling) {
        return SignalWrapper(T);
    }
    else if(mode == .Counting) {
        return CounterWrapper(T);
    }
}

fn SignalWrapper(comptime T: type) type {
    return struct {
        pub const Self = @This();
        value: std.atomic.Value(T),
        
        pub fn init(val: T) Self {
            return Self{
                .value = std.atomic.Value(T).init(val),
            };
        }

        pub fn set(self: *Self, val: T) void {
            self.value.store(val, .release);
        }

        pub fn get(self: *Self) T {
                return self.value.load(.acquire);
        }
    };
}
fn CounterWrapper(comptime T: type) type {
    return struct {
        pub const Self = @This();
        value: std.atomic.Value(T),
        
        pub fn init(val: T) Self {
            return Self{
                .value = std.atomic.Value(T).init(val),
            };
        }

        pub fn get(self: *Self) T {
                return self.value.load(.monotonic);
        }

        pub fn increment(self: *Self) T {
            return self.value.fetchAdd(1, .monotonic);
        }

        pub fn reset(self: *Self) void {
            self.value.store(0, .monotonic);
        }
    };
}
