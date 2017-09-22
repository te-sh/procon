import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc068_a

version(unittest) {} else
void main()
{
  auto x = readln.chomp.to!long;
  auto ans = x / 11 * 2, mod = x % 11;
  if (1 <= mod && mod <= 6) ans += 1;
  else if (5 <= mod)        ans += 2;
  writeln(ans);
}
