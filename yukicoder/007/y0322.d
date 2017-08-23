import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ti = readln.split.to!(int[]);
  auto di = readln.split.to!(int[]);

  auto ai = zip(ti, di).map!(a => a[1].to!real / a[0]).array;
  auto ri = iota(n).array;
  ri.sort!((a, b) => ai[a] < ai[b]);

  writeln(ri.map!"a+1".array.to!(string[]).join(" "));
}
