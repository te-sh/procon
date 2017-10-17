import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), a = rd1[0], n = rd1[1], m = rd1[2];
  auto l = new int[](n);
  foreach (i; 0..n) l[i] = readln.chomp.to!int;

  auto d = new int[](n-1);
  foreach (i; 0..n-1) d[i] = l[i+1]-l[i]-1;
  auto ds = d.sort();

  auto cd = new int[](n);
  foreach (i; 1..n) cd[i] = cd[i-1]+d[i-1];

  foreach (_; 0..m) {
    auto rd2 = readln.splitter;
    auto x = rd2.front.to!int; rd2.popFront();
    auto y = rd2.front.to!int;

    auto lb = ds.lowerBound(x+y), nlb = lb.length;
    auto t = n + cd[nlb] + (x+y)*(n-1-nlb) + min(l[0]-1, x) + min(a-l[$-1], y);
    writeln(t);
  }
}
