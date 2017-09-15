import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]), mi = a.reduce!min, ma = a.reduce!max;

  auto ans = int.max;
  foreach (x; mi..ma+1)
    ans = min(ans, a.map!(ai => (ai - x) ^^ 2).sum);

  writeln(ans);
}
