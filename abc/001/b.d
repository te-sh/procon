import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto m = readln.chomp.to!int;
  writefln("%02d", calcVV(m) / 1000);
}

auto calcVV(int m)
{
  if      (m <    100) return 0;
  else if (m <=  5000) return m * 10;
  else if (m <= 30000) return m + 50000;
  else if (m <= 70000) return (m - 30000) / 5 + 80000;
  else                 return 89000;
}
