import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto l = readln.chomp.to!size_t;
  auto b = new int[](l);
  foreach (i; 0..l) b[i] = readln.chomp.to!int;

  auto bs = b[0..$-1].reduce!"a^b";
  if (bs != b[$-1]) {
    writeln(-1);
    return;
  }

  auto ai = 0;
  writeln(ai);
  foreach (i; 0..l-1) {
    ai ^= b[i];
    writeln(ai);
  }
}
