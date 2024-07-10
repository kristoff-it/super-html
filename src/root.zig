// const interpreter = @import("interpreter.zig");
const std = @import("std");
pub const html = @import("html.zig");
pub const max_size = html.max_size;
pub const Ast = @import("Ast.zig");

pub const Language = enum { html, superhtml };

// pub const SuperVM = interpreter.SuperVM;
// pub const Exception = interpreter.Exception;

const Range = struct {
    start: Pos,
    end: Pos,

    const Pos = struct {
        row: u32,
        col: u32,
    };
};

pub const Line = struct { line: []const u8, start: u32 };

pub const Span = struct {
    start: u32,
    end: u32,
    pub fn slice(self: Span, src: []const u8) []const u8 {
        return src[self.start..self.end];
    }

    pub fn range(self: Span, code: []const u8) Range {
        var selection: Range = .{
            .start = .{ .row = 0, .col = 0 },
            .end = undefined,
        };

        for (code[0..self.start]) |c| {
            if (c == '\n') {
                selection.start.row += 1;
                selection.start.col = 0;
            } else selection.start.col += 1;
        }

        selection.end = selection.start;
        for (code[self.start..self.end]) |c| {
            if (c == '\n') {
                selection.end.row += 1;
                selection.end.col = 0;
            } else selection.end.col += 1;
        }
        return selection;
    }

    /// Finds the line around a Node. Choose simple nodes
    //  if you don't want unwanted newlines in the middle.
    pub fn line(span: Span, src: []const u8) Line {
        var idx = span.start;
        const s = while (idx > 0) : (idx -= 1) {
            if (src[idx] == '\n') break idx + 1;
        } else 0;

        idx = span.end;
        const e = while (idx < src.len) : (idx += 1) {
            if (src[idx] == '\n') break idx;
        } else src.len - 1;

        return .{ .line = src[s..e], .start = s };
    }

    pub fn debug(span: Span, src: []const u8) void {
        std.debug.print("{s}", .{span.slice(src)});
    }
};

test {
    // _ = @import("template.zig");
    _ = @import("Ast.zig");
}
