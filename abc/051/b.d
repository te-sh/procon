import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), k = rd[0], s = rd[1];

  auto ans = 0;
  foreach (x; 0..k+1)
    foreach (y; 0..k+1) {
      auto z = s-x-y;
      if (0 <= z && z <= k) ++ans;
    }

  writeln(ans);
}
