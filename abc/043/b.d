import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto t = "";

  foreach (c; s)
    switch (c) {
    case '0':
    case '1':
      t ~= c;
      break;
    case 'B':
      t = t.empty ? t : t[0..$-1];
      break;
    default:
      assert(0);
    }

  writeln(t);
}
