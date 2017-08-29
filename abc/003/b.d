import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp, t = readln.chomp;
  writeln(calc(s, t) ? "You can win" : "You will lose");
}

auto calc(string s, string t)
{
  foreach (i; 0..s.length)
    if (!compare(s[i], t[i])) return false;
  return true;
}

auto compare(char a, char b)
{
  if (b == '@') swap(a, b);

  if (b == '@') return true;
  if (a == '@') return ['a','t','c','o','d','e','r'].canFind(b);

  return a == b;
}
