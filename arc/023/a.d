import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto y = readln.chomp.to!int;
  auto m = readln.chomp.to!int;
  auto d = readln.chomp.to!int;

  writeln(calcDate(2014, 5, 17) - calcDate(y, m, d));
}

auto calcDate(int y, int m, int d)
{
  if (m <= 2) {
    m += 12;
    --y;
  }

  return 365*y+y/4-y/100+y/400+306*(m+1)/10+d-429;
}
