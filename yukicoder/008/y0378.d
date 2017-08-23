import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;

  long[] r;
  for (; n > 0; n /= 2) r ~= n;

  auto s = r.sum, t = 0L;
  foreach (i; 0..r.length)
    t = max(t, r[0..i+1].sum + r[i] - s);

  writeln(t);
}
