import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), a = rd1[0], b = rd1[1], c = rd1[2], k = rd1[3];
  auto rd2 = readln.split.to!(int[]), s = rd2[0], t = rd2[1];

  auto ans = a * s + b * t;
  if (s + t >= k) ans -= c * (s + t);

  writeln(ans);
}
