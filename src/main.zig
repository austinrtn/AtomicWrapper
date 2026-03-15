const std = @import("std");
const AW = @import("AtomicWrapper").AtomicWrapper;
const AtomicWrapper = AW.AtomicWrapper;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var buf: [256]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(&buf);
    const writer = &stdout.interface;

    var is_loading = AtomicWrapper(bool, .Signaling).init(true);
    var loop_counter = AtomicWrapper(usize, .Counting).init(0);

    var thread = try std.Thread.spawn(
        .{ .allocator = allocator }, 
        threadFunc,
        .{&is_loading, &loop_counter},
    );

    try writer.print("\x1bc", .{});
    while(is_loading.get()) {
        _ = loop_counter.increment();
        try writer.print("Loading: {} |Counter: {d}\r", .{is_loading.get(), loop_counter.get()});
        try writer.flush(); 
    }
    thread.join();

    try writer.print("Loading: {} |Counter: {d}\r", .{is_loading.get(), loop_counter.get()});

    try writer.flush();
    try writer.writeAll("\nDone loading!\n");
    try writer.flush(); 
}

fn threadFunc(loading: *AtomicWrapper(bool, .Signaling), counter: *AtomicWrapper(usize, .Counting)) void {
    while(true) {
        _ = counter.increment();

        if(counter.get() >= 500_000_000) {
            loading.set(false);
            break;
        } 
    } 
}
