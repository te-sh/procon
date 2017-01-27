import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto ni = readln.split.to!(int[]);
  auto r = ni.map!(n => n % 4).fold!"a ^ b";
  writeln(r ? "Taro" : "Jiro");
}
