import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = new char[][](n);
  foreach (i; 0..n) {
    auto si = readln.chomp.dup;
    si.reverse();
    s[i] = si;
  }

  s.sort();

  foreach (si; s) {
    si.reverse();
    writeln(si);
  }
}
