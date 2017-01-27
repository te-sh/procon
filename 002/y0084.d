import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), r = rd[0], c = rd[1];

  if (r == c) {
    auto a = (r / 2) ^^ 2;
    if (r % 2 == 1) a += (r + 1) / 2;
    writeln(a - 1);
  } else {
    auto a = (r / 2) * c;
    if (r % 2 == 1) a += (c + 1) / 2;
    writeln(a - 1);
  }
}
