import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp.dup;
  foreach (int i, ref c; s) {
    auto d = c - 'A';
    d = (d - (i + 1) + 26 * 50) % 26;
    c = (d + 'A').to!char;
  }
  writeln(s);
}
