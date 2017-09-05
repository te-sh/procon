import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  bool[int] b;
  auto rd = readln.splitter;
  foreach (_; 0..n) {
    auto a = rd.front.to!int; rd.popFront();
    b[a >> (a.bsf)] = true;
  }
  writeln(b.length);
}

pragma(inline) {
  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
