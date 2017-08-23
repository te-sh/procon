import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], m = rd[1];
  auto ai = readln.split.to!(size_t[]).map!"a - 1";

  auto ci = n.iota.map!"a + 1".array;
  foreach (a; ai)
    ci = ci[a] ~ ci.take(a) ~ ci.drop(a + 1);

  writeln(ci.front);
}
