import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1];
  auto s = readln.chomp;

  foreach (i, c; s) {
    if (i == a) {
      if (c != '-') {
        writeln("No");
        return;
      }
    } else {
      if (c < '0' || c > '9') {
        writeln("No");
        return;
      }
    }
  }

  writeln("Yes");
}
