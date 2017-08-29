import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], k = rd[1];
  auto r = readln.split.to!(int[]);

  r = r.sort().array.drop(n-k);
  auto t = real(0);

  foreach (ri; r)
    t = (t + ri) / 2;

  writefln("%.7f", t);
}
