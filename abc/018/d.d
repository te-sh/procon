import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]);
  auto n = rd1[0], m = rd1[1], p = rd1[2], q = rd1[3], r = rd1[4];
  auto v = new int[][](m, n);
  foreach (_; 0..r) {
    auto rd2 = readln.split;
    auto x = rd2[0].to!size_t-1, y = rd2[1].to!size_t-1, z = rd2[2].to!int;
    v[y][x] = z;
  }

  auto ans = 0;
  foreach (i; 0..1<<n) {
    if (i.popcnt != p) continue;
    auto mv = new int[](m);
    foreach (j; 0..m)
      mv[j] = v[j].indexed(i.bitsSet).sum;
    mv.sort!"a > b";
    ans = max(ans, mv[0..q].sum);
  }

  writeln(ans);
}

pragma(inline) {
  import core.bitop;
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
