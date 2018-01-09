import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], h = rd[1];
  auto a = new int[](n), b = new int[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    a[i] = rd2.front.to!int; rd2.popFront();
    b[i] = rd2.front.to!int;
  }

  auto am = a.reduce!max;
  b.sort!"a>b";

  auto s = 0, ans = h;
  foreach (i; 0..n) {
    s += b[i];
    if (s >= h) {
      ans = min(ans, i+1);
      break;
    }
    ans = min(ans, i+1+(h-s+am-1)/am);
  }

  writeln(ans);
}
