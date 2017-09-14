import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = new string[](n), p = new int[](n);
  foreach (i; 0..n) {
    auto rd = readln.split;
    s[i] = rd[0];
    p[i] = rd[1].to!int;
  }

  size_t maxI = n;
  auto maxP = 0;
  foreach (i; 0..n)
    if (p[i] > maxP) {
      maxI = i;
      maxP = p[i];
    }

  writeln(maxP * 2 > p.sum ? s[maxI] : "atcoder");
}
