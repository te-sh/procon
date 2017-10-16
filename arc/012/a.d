import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto tbl = ["Sunday": 0, "Monday": 5, "Tuesday": 4, "Wednesday": 3, "Thursday": 2, "Friday": 1, "Saturday": 0];
  auto d = readln.chomp;
  writeln(tbl[d]);
}
