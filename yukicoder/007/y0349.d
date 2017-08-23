import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = n.iota.map!(_ => readln.chomp).array;

  a.sort();
  writeln(a.group.map!"a[1]".maxElement <= (n+1)/2 ? "YES" : "NO");
}
