import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;

  auto dpl = new int[](5), dpr = new int[](5);
  foreach (c; s)
    switch (c) {
    case '(':
      ++dpl[0];
      ++dpr[0];
      break;
    case '^':
      dpl[2] = dpl[1];
      dpl[1] = dpl[0];
      dpr[3] = dpr[2];
      dpr[2] = dpr[1];
      break;
    case '*':
      dpl[3] = dpl[2];
      dpr[1] = dpr[0];
      break;
    case ')':
      dpl[4] += dpl[3];
      dpr[4] += dpr[3];
      break;
    default:
      assert(0);
    }

  writeln(dpl[4], " ", dpr[4]);
}
