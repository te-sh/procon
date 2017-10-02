// path: arc080_a

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto co = 0, c2 = 0, c4 = 0;
  auto rd = readln.splitter;
  foreach (_; 0..n) {
    auto a = rd.front.to!int; rd.popFront();
    if (a % 2 != 0) ++co;
    else if (a % 4 != 0) ++c2;
    else ++c4;
  }

  writeln(c2 > 0 && co <= c4 || c2 == 0 && co <= c4+1 ? "Yes" : "No");
}
