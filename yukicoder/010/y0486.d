import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto i1 = s.indexOf("OOO"), i2 = s.indexOf("XXX");
  if (i1 == -1 && i2 == -1) {
    writeln("NA");
  } else if (i1 == -1) {
    writeln("West");
  } else if (i2 == -1) {
    writeln("East");
  } else {
    writeln(i1 < i2 ? "East" : "West");
  }
}
