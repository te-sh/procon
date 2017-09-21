import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = readln.chomp;
  auto x = 0, m = 0;
  foreach (si; s) {
    x += si.predSwitch('I', +1, 'D', -1);
    m = max(m, x);
  }
  writeln(m);
}
