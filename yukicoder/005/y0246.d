import std.algorithm, std.conv, std.range, std.stdio, std.string;

const maxR = 10 ^^ 9 + 2;

version(unittest) {} else
void main()
{
  auto r = iota!int(1, maxR+2).assumeSorted!isLow.lowerBound(0);
  writeln("! ", r.back); stdout.flush();
}

bool isLow(int x, int _)
{
  writeln("? ", x); stdout.flush();
  auto r = readln.chomp.to!int;
  return r == 1;
}
