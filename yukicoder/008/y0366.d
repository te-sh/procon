import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];
  auto a = readln.split.to!(int[]);

  auto idx = 0;
  int[int] buf;
  auto c = a.dup; c.sort();
  foreach (ci; c) buf[ci] = idx++;
  foreach (ref ai; a) ai = buf[ai];

  auto b = new int[][](n);
  foreach (i, ai; a) {
    if (ai % k != i % k) {
      writeln(-1);
      return;
    }
    b[i % k] ~= ai / k;
  }
  writeln(b.map!(bi => calc(bi)).sum);
}

auto calc(int[] a)
{
  auto n = a.length, r = 0;
  foreach (i; 0..n) {
    auto j = a.countUntil(i);
    r += j;
    a.remove(j);
  }
  return r;
}
