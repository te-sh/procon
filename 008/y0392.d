import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto m = readln.chomp.to!size_t;
  foreach (_; 0..m) {
    auto c = readln.chomp.to!int + 1;
    auto i = c.bsr;
    foreach (j; 0..i)
      write(c.bitTest(i-j-1) ? "R" : "L");
    writeln;
  }
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
}
