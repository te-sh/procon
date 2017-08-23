import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  
  auto l = s.length, ma = int.min;
  foreach (i; 0..l)
    ma = max(ma, calc(s[i..$] ~ s[0..i]));

  writeln(ma);
}

auto calc(string s)
{
  if (s[0] == '+' || s[0] == '-' || s[$-1] == '+' || s[$-1] == '-') return int.min;

  auto mi = s.matchAll(r"[-+]?\d+"), acc = 0;
  foreach (m; mi) {
    acc += m[0].to!int;
    m.popFront();
  }

  return acc;
}
