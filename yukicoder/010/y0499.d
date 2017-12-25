import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  char[] s;

  if (n == 0) {
    writeln(0);
    return;
  }

  while (n > 0) {
    s ~= cast(char)(n%7+'0');
    n /= 7;
  }

  writeln(s.retro);
}
