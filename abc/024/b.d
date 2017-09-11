import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], t = rd[1];
  auto a = new int[](n);
  foreach (i; 0..n) a[i] = readln.chomp.to!int;

  auto ans = t;
  foreach_reverse (i; 0..n-1) {
    if (a[i+1] - a[i] > t)
      ans += t;
    else
      ans += a[i+1] - a[i];
  }

  writeln(ans);
}
