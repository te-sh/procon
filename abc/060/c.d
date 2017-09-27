import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc073_a

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), n = rd[0], ts = rd[1];
  auto t = readln.split.to!(long[]);

  auto ans = 0L;
  foreach (i; 0..n-1)
    ans += t[i+1]-t[i] > ts ? ts : t[i+1]-t[i];
  ans += ts;

  writeln(ans);
}
