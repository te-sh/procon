import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;

  foreach (i, c; s) {
    if (i >= 1 && s[i-1] == c) {
      writeln(i, " ", i+1);
      return;
    }
    if (i >= 2 && s[i-2] == c) {
      writeln(i-1, " ", i+1);
      return;
    }
  }

  writeln("-1 -1");
}
