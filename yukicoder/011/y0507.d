import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  auto kp = readln.chomp.to!int;
  auto a = new int[](n-1);
  foreach (i; 0..n-1) a[i] = readln.chomp.to!int;

  a.sort!"a>b";

  if (n/2 == m) {
    writeln(a[$-1]);
    return;
  }

  auto calc(int i)
  {
    auto p = kp+a[i];
    auto b = (a[0..i] ~ a[i+1..$])[0..m*2];
    foreach (j; 0..m)
      if (b[j]+b[$-1-j] <= p) return true;
    return false;
  }

  auto bsearch = iota(n-1).map!(i => tuple(i, calc(i))).assumeSorted!"a[1]>b[1]";
  auto r = bsearch.lowerBound(tuple(0, false));
  writeln(r.empty ? -1 : a[r.back[0]]);
}
