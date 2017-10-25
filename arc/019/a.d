import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp.dup;
  foreach (ref c; s)
    c = c.predSwitch('O', '0', 'D', '0', 'I', '1', 'Z', '2', 'S', '5', 'B', '8', c, c);
  writeln(s);
}
