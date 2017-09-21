import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto t = readln.split.to!(int[]), s = t.sum;
  auto m = readln.chomp.to!size_t;
  foreach (_; 0..m) {
    auto rd = readln.splitter;
    auto p = rd.front.to!size_t-1; rd.popFront();
    auto x = rd.front.to!int;
    writeln(s - t[p] + x);
  }
}
