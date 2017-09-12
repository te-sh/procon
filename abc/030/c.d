import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto rd2 = readln.split.to!(int[]), x = rd2[0], y = rd2[1];
  auto a = readln.split.to!(int[]).assumeSorted;
  auto b = readln.split.to!(int[]).assumeSorted;

  auto t = 0, r = 0;
  for (;;) {
    auto ta = a.lowerBound(t);
    a = a[ta.length..$];
    if (a.empty) break;
    t = a.front + x;

    auto tb = b.lowerBound(t);
    b = b[tb.length..$];
    if (b.empty) break;
    t = b.front + y;

    ++r;
  }

  writeln(r);
}
