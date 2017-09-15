import std.algorithm, std.conv, std.range, std.stdio, std.string;

const k1 = "WBWBWWBWBWBW", k2 = k1 ~ k1 ~ k1;
const o = ["Do", "", "Re", "", "Mi", "Fa", "", "So", "", "La", "", "Si"];

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  writeln(o[k2.indexOf(s)]);
}
