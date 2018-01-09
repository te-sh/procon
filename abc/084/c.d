import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto c = new int[](n-1), s = new int[](n-1), f = new int[](n-1);
  foreach (i; 0..n-1) {
    auto rd = readln.split.to!(int[]);
    c[i] = rd[0];
    s[i] = rd[1];
    f[i] = rd[2];
  }

  int calc(int i, int t)
  {
    if (i == n-1) return t;
    auto t2 = max(s[i], (t+f[i]-1)/f[i]*f[i])+c[i];
    return calc(i+1, t2);
  }

  foreach (i; 0..n) writeln(calc(i, 0));
}
