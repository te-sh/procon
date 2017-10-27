import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], k = rd1[1], x = rd1[2];
  auto a = new int[](k), b = new int[](k);
  foreach (i; 0..k) {
    auto rd2 = readln.splitter;
    if (i != x-1) {
      a[i] = rd2.front.to!int-1; rd2.popFront();
      b[i] = rd2.front.to!int-1;
    }
  }
  auto c = readln.split.map!(to!int).map!"a-1".array;

  auto d = new int[](n);
  foreach (i; 0..n) d[i] = i;

  foreach (i; 0..x-1) swap(d[a[i]], d[b[i]]);
  foreach_reverse (i; x..k) swap(c[a[i]], c[b[i]]);

  int[] ans;
  foreach (i; 0..n)
    if (d[i] != c[i]) ans ~= i;

  ans.sort();
  writeln(ans[0]+1, " ", ans[1]+1);
}
