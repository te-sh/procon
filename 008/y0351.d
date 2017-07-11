import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), h = rd1[0], w = rd1[1];
  auto n = readln.chomp.to!size_t;

  auto s = new char[](n), k = new int[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.chomp;
    s[i] = rd2[0];
    k[i] = rd2[2..$].to!int;
  }

  auto x = 0, y = 0;
  foreach_reverse (si, ki; lockstep(s, k)) {
    switch (si) {
    case 'R':
      if (y == ki) {
        --x;
        if (x < 0) x = w-1;
      }
      break;
    case 'C':
      if (x == ki) {
        --y;
        if (y < 0) y = h-1;
      }
      break;
    default:
      assert(0);
    }
  }

  writeln((x + y) % 2 == 0 ? "white" : "black");
}
