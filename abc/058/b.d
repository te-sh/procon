import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto o = readln.chomp, no = o.length;
  auto e = readln.chomp, ne = e.length;

  auto r = new char[](no+ne);
  foreach (i, c; o) r[i*2] = c;
  foreach (i, c; e) r[i*2+1] = c;

  writeln(r);
}
