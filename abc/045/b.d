import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = 3;
  auto s = new string[](n);
  foreach (i; 0..n) s[i] = readln.chomp;

  auto turn = 0;
  for (;;) {
    if (s[turn].empty) {
      writeln(cast(char)('A' + turn));
      return;
    }

    auto next = cast(int)(s[turn][0] - 'a');
    s[turn] = s[turn][1..$];
    turn = next;
  }
}
