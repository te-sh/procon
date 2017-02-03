import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  auto ci = readln.split.to!(int[]);

  ci.sort();
  auto r = 0;
  foreach (c; ci) {
    if (m < c) break;
    m -= c;
    ++r;
  }
      
  writeln(r);
}
