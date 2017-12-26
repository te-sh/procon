import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.split, n = s.length;

  foreach (i; 0..n) {
    write(s[i][0].predSwitch('L', "<", 'R', ">", 'A', "A"));
    if (i < n-1) write(" ");
  }
  writeln;
}
