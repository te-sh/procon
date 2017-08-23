import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, a = rd[0], b = rd[1];

  writeln(calc(a, b) ? a : b);
}

auto calc(string a, string b)
{
  if (a.length != b.length)
    return a.length > b.length;

  foreach (ca, cb; lockstep(a, b)) {
    if (ca == '4' && cb == '7')
      return true;
    else if (ca == '7' && cb == '4')
      return false;
    else if (ca != cb)
      return ca > cb;
  }

  return true;
}
