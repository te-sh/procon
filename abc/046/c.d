import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto t = 1L, a = 1L;
  foreach (_; 0..n) {
    auto rd = readln.split.to!(long[]), ti = rd[0], ai = rd[1];
    auto k = max((t+ti-1)/ti, (a+ai-1)/ai);
    t = k*ti;
    a = k*ai;
  }

  writeln(t+a);
}
