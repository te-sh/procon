import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  auto a = new int[](n), b = new int[](n);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    foreach (j; 0..n) {
      a[j] = rd2.front.to!int;
      rd2.popFront();
    }
    foreach (j; 1..n) a[j] += a[j-1];
    b[] += a[];

    auto bs = b.assumeSorted!"a < b";
    if (bs.contains(777)) {
      writeln("YES");
      return;
    }
    foreach (bi; bs.upperBound(777)) {
      if (bs.contains(bi-777)) {
        writeln("YES");
        return;
      }
    }
  }
  writeln("NO");
}
